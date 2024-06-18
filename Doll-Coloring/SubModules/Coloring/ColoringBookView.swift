//
//  ColoringBookView.swift
//  InicioColoringBook
//
//  Created by Trabajo on 17/09/20.
//

import UIKit
import MobileCoreServices

protocol ColoringBookViewDelegate: AnyObject {
    func viewWillStartDrawing()
    func viewDidEndDrawing()
}
class ColoringBookView: UIView {
    
    private (set) var pixelSize:CGSize!
    //Stroke history
    private (set) var strokes:[Stroke] = [Stroke](){
        didSet{
            self.reduceHistory()
        }
    }
    private (set) var redoStrokes:[Stroke] = [Stroke]()
    
    private (set) var activeStroke:Stroke? = nil
    //A "frozen context" to actually draw, based on Apple's https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/illustrating_the_force_altitude_and_azimuth_properties_of_touch_input
    //More efficient than drawing directly into the view
    private var frozenContext:CGContext!
    
    //Processes masks
    private var coloringImage: ColoringImageBook!
    
    //Saves strokes history if we've drawn too much for better undo/redo performance
    private var savedImage:NSMutableData? = nil
    
    //Flag to know if mask is being generated in background
    private var generatingMask:Bool = false
    //Layer of coloring image, can be hidden
    private var coloringLayer:CALayer!
    
    public var percentColorImage: Double = 0
    public var percentColoring: Double = 0
    
    public var currentColor:UIColor = .red
    public var nameColor: String = ""
    public var currentWidth:CGFloat = 5.0
    
    //Variables to handle possible touch cancellations
    
    //Times to wait for touch cancel from ScrollView, magic numbers really
    private let cancellationTimeInterval = TimeInterval(0.1)
    private let pencilWaitTimeInterval = TimeInterval(0.042)
    private var initialTimestamp: TimeInterval?
    
    //Acumulator to keep touches unprocressed while waiting for a possible cancel
    private var pointAccumulator:[CGPoint] = [CGPoint]()
    private var touchIsPencil:Bool = false
    
    public var isPens: Bool = true
    
    public var isZooming: Bool = false
    
    public var canRedo:Bool{
        return !redoStrokes.isEmpty
    }
    
    public var canUndo:Bool{
        return !strokes.isEmpty
    }
    
    public func getStrokes() -> [Stroke] {
        return strokes
    }
    
    public func setStrokes(_ strokes: [Stroke]) {
        self.strokes = strokes
        redrawInFrozenContext()
    }
    
    public weak var delegate:ColoringBookViewDelegate? = nil
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: pixelSize.width / UIScreen.main.scale,
                      height: pixelSize.height / UIScreen.main.scale)
    }
    
    init(coloringImage:ColoringImageBook){
        super.init(frame: .zero)
        
        self.isOpaque = false
        self.backgroundColor = UIColor(hexString: "FFFFFE")
        
        self.coloringImage = coloringImage
        self.pixelSize = CGSize(width: coloringImage.width,
                                height: coloringImage.height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        self.frozenContext = CGContext(data: nil,
                                       width: Int(self.pixelSize.width),
                                       height: Int(self.pixelSize.height),
                                       bitsPerComponent: 8,
                                       bytesPerRow: 0,
                                       space: colorSpace,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        //Add scale factor to the context since we created in pixel size
        let transform = CGAffineTransform.init(scaleX:UIScreen.main.scale, y: UIScreen.main.scale)
        self.frozenContext.concatenate(transform)
        
        //Set line Cap and Join, these settings work fine with this approach, otherwise the redraw looks funny
        self.frozenContext.setLineCap(.round)
        self.frozenContext.setLineJoin(.round)
        
        
        self.coloringLayer = CALayer()
        coloringLayer.frame = CGRect(origin: .zero,
                                     size: CGSize(width: pixelSize.width / UIScreen.main.scale,
                                                  height: pixelSize.height / UIScreen.main.scale))
        coloringLayer.contents = self.coloringImage.cgImage
        percentColorImage = calculateColorCoverageLayer()
        percentColoring = percentColorImage
        self.layer.addSublayer(coloringLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        
        //If we can create a CGImage from the frozen context we draw it to the view
        if let frozenImage = frozenContext.makeImage(){
            currentContext.draw(frozenImage, in: bounds)
        }
        
        //If mask is being generated in background the active stroke hasn't drawn to the Frozen Context, draw the whole active stroke as temporary marks that hopefully don't cross the image lines
        if generatingMask{
            //Temporary marks
            currentContext.setLineCap(.round)
            currentContext.setLineJoin(.round)
            activeStroke?.drawInContext(currentContext)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Send a signal to delegate
        delegate?.viewWillStartDrawing()
        
        //Create a stroke with current settings
        activeStroke = Stroke(color: currentColor,
                              lineWidth: currentWidth, nameColor: nameColor, isPens: isPens)
        
        let firstLocation = touches.first!.location(in: self)
        
        //Keep a timestamp of the touch start to wait for a possible cancel
        self.initialTimestamp = ProcessInfo.processInfo.systemUptime
        //Restart the accumulator
        self.pointAccumulator = []
        self.touchIsPencil = touches.first!.type == .pencil
        
        //Generate mask in background
        self.generatingMask = true
        let strokeID = activeStroke?.id
        DispatchQueue.global(qos: .background).async {
            let (clipRect, mask) = self.coloringImage.getFillMaskAt(x: Int(firstLocation.x * UIScreen.main.scale),
                                                                    y: Int(firstLocation.y * UIScreen.main.scale))
            
            self.generatingMask = false
            if let mask = mask{
                //We check the id of the current stroke to make sure we didn't took too long to process the mask
                if self.activeStroke?.id == strokeID {
                    DispatchQueue.main.async {
                        //Redraw the whole view so any temporary mark gets erased
                        self.setNeedsDisplay(self.bounds)
                        self.setClip(clipRect, maskImage: mask)
                    }
                }
            }
            else{
                //If we don't get a mask cancel active stroke
                if self.activeStroke?.id == strokeID {
                    DispatchQueue.main.async {
                        //Redraw the whole view so any temporary mark gets erased
                        self.setNeedsDisplay(self.bounds)
                        self.activeStroke = nil
                    }
                }
            }
        }
        
        //Use coalescedtouches to get a smoother line when drawing with an Apple Pencil
        if let point = touches.first, let coalescedTouches = event?.coalescedTouches(for: point){
            for touch in coalescedTouches{
                pointAccumulator.append(touch.location(in: self))
                self.activeStroke?.addPoint(touch.location(in: self))
            }
        }
        
        drawActiveFrozenContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPens else {return}
        if let point = touches.first, let coalescedTouches = event?.coalescedTouches(for: point){
            for touch in coalescedTouches{
                pointAccumulator.append(touch.location(in: self))
            }
        }
        drawActiveFrozenContext()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Beginning a new stroke destroys the redo array
        self.redoStrokes.removeAll()
        
        //Reset variables after a cancelation
        resetVariablesHistory()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard  !isZooming else {return}
        
        //Beginning a new stroke destroys the redo array
        self.redoStrokes.removeAll()
        
        //Active stroke goes to the array of already drawn strokes
        
        guard isPens  else {
            if touches.count == 1, let firstLocation = touches.first?.location(in: self) {
                fillColor(at: firstLocation, colorFill: currentColor)
            }
            return
        }
        if let activeStroke = self.activeStroke{
            strokes.append(activeStroke)
        }
        resetVariables()
    }
    
    private func resetVariables() {
        percentColoring = calculateColorCoverage()
        activeStroke = nil
        frozenContext.resetClip()
        pointAccumulator = []
        initialTimestamp = nil
        delegate?.viewDidEndDrawing()
    }
    
    private func resetVariablesHistory() {
        activeStroke = nil
        frozenContext.resetClip()
        pointAccumulator = []
        initialTimestamp = nil
    }
    
    private func drawActiveFrozenContext(){
        
        //If we have an initial time `  amp check if enough time has passed so a cancel is not likely
        if let initialTimeStamp = self.initialTimestamp{
            let dif = ProcessInfo.processInfo.systemUptime - initialTimeStamp
            
            if touchIsPencil && dif < self.pencilWaitTimeInterval ||
                !touchIsPencil && dif < self.cancellationTimeInterval{
                //A cancellation from the ScrollView is still possible
                return
            }
            //Not necessary anymore
            initialTimestamp = nil
        }
        
        //Add point from accumulator to active stroke and reset
        for point in pointAccumulator{
            activeStroke?.addPoint(point)
        }
        
        pointAccumulator = []
        
        
        if generatingMask{
            //While generating mask draw temporarily
            if let strokeRect = activeStroke?.strokeRect{
                self.setNeedsDisplay(strokeRect)
            }
            
        }
        else{
            //If received an update rect from the active stroke, we flag the view as needing to draw in the update rect
            if let updateRect = activeStroke?.drawSinceLastIn(frozenContext){
                self.setNeedsDisplay(updateRect)
            }
        }
    }
    
    public func undo(){
        if let last = self.strokes.popLast(){
            self.redoStrokes.append(last)
            redrawInFrozenContext()
        }
    }
    
    public func reloadStrokes() {
        _ = self.strokes.popLast()
        redrawInFrozenContext()
    }
    
    public func redo(){
        if let last = self.redoStrokes.popLast(){
            self.strokes.append(last)
            redrawInFrozenContext()
        }
    }
    
    public func clear(){
        self.strokes.removeAll()
        self.savedImage = nil
        redrawInFrozenContext()
    }
    
    public func hideColoringLayer(){
        self.coloringLayer.isHidden.toggle()
    }
    
    private func redrawInFrozenContext(updateScreen:Bool = true){
        frozenContext.clear(self.bounds)
        //Write saved image first if it exists
        if let savedImageData = self.savedImage,
           let dataProvider = CGDataProvider(data: savedImageData as CFData),
           let startImage = CGImage(pngDataProviderSource: dataProvider,
                                    decode: nil,
                                    shouldInterpolate: true,
                                    intent: .defaultIntent){
            frozenContext.draw(startImage, in: self.bounds)
        }
        loadHistoryStrokes(in: strokes)
    }
    
    private func loadHistoryStrokes(in strokes: [Stroke], updateScreen:Bool = true) {
        var newStrokes = strokes
        if newStrokes.count != 0 {
            let stroke = newStrokes.removeFirst()
            if stroke.isPens {
                if let firstPoint = stroke.points.first{
                    let (clipRect,mask) = self.coloringImage.getFillMaskAt(x: Int(firstPoint.x * UIScreen.main.scale),
                                                                           y: Int(firstPoint.y * UIScreen.main.scale))
                    if let mask = mask{
                        self.setClip(clipRect, maskImage: mask)
                    }
                }
                stroke.drawInContext(frozenContext)
                frozenContext.resetClip()
                loadHistoryStrokes(in: newStrokes)
            } else {
                if let firstPoint = stroke.points.first{
                    fillColor(at: firstPoint, colorFill: stroke.color){
                        self.loadHistoryStrokes(in: newStrokes)
                    }
                }
            }
        } else {
            self.setNeedsDisplay()
            self.resetVariables()
        }
    }
    
    private func setClip(_ rect:CGRect, maskImage:CGImage) {
        if coloringImage.isOptimized{
            //Optimized images don't flip the mask for us, this is necessary to apply the mask correctly (mixing coordinate systems suck)
            self.frozenContext.translateBy(x: 0, y: rect.origin.y + rect.height)
            self.frozenContext.scaleBy(x: 1.0, y: -1.0)
            self.frozenContext.clip(to: CGRect(x: rect.origin.x,
                                               y: 0,
                                               width: rect.width,
                                               height: rect.height),
                                    mask: maskImage)
            
            self.frozenContext.scaleBy(x: 1.0, y: -1.0)
            self.frozenContext.translateBy(x: 0, y: -(rect.origin.y + rect.height))
        }
        else{
            self.frozenContext.clip(to: rect,
                                    mask: maskImage)
        }
    }
    
    private func reduceHistory(){
        //Only enter if a number of strokes have been acummulated
        guard (coloringImage.isOptimized && strokes.count > 100) ||
                (!coloringImage.isOptimized && strokes.count > 8)else{
            return
        }
        
        if coloringImage.isOptimized{
            //Optimized drops a few strokes from history
            
            //Get current image from context
            guard let currentImage = frozenContext.makeImage() else {return}
            
            //Store the strokes intented to keep and remove them from the array
            let numberToKeep:Int = 30
            let indexStart:Int = self.strokes.count - numberToKeep
            let strokesToKeep:[Stroke] = Array(self.strokes[indexStart...(self.strokes.count - 1)])
            self.strokes.removeLast(numberToKeep)
            
            //Redraw again, no updating the screen is necessary
            self.redrawInFrozenContext(updateScreen: false)
            
            //Save current image to PNG encrypted data
            guard let imageToSave = frozenContext.makeImage() else {return}
            self.savedImage = NSMutableData()
            if let dest = CGImageDestinationCreateWithData(self.savedImage!,
                                                           kUTTypePNG,
                                                           1, nil){
                CGImageDestinationAddImage(dest,
                                           imageToSave, nil)
                if CGImageDestinationFinalize(dest){
                    self.strokes.removeAll()
                }
            }
            
            //Place strokes to be kept into the array
            self.strokes = strokesToKeep
            
            //Redraw the context again with the image before the reduction happened
            frozenContext.draw(currentImage, in: self.bounds)
        }
        else{
            //Non optimized removes all history up to his point (performance is too bad if we keep a few)
            guard let imageToSave = frozenContext.makeImage() else {return}
            self.savedImage = NSMutableData()
            if let dest = CGImageDestinationCreateWithData(self.savedImage!,
                                                           kUTTypePNG,
                                                           1, nil){
                CGImageDestinationAddImage(dest,
                                           imageToSave, nil)
                if CGImageDestinationFinalize(dest){
                    //Remove all, there is no point keeping a few
                    self.strokes.removeAll()
                }
            }
        }
    }
    
    public func fillColor(at point: CGPoint, colorFill: UIColor) {
        let location = CGPoint(x: point.x * UIScreen.main.scale, y: point.y * UIScreen.main.scale)
        DispatchQueue.global(qos: .background).async {
            let (clipRect, mask) = self.coloringImage.getFillMaskAt(x: Int(location.x), y: Int(location.y))
            if let mask = mask {
                DispatchQueue.main.async {
                    self.setClip(clipRect, maskImage: mask)
                    self.frozenContext.setFillColor(colorFill.cgColor)
                    self.frozenContext.fill(clipRect)
                    self.activeStroke?.drawInContext(self.frozenContext)
                    self.activeStroke?.addPoint(point)
                    self.setNeedsDisplay()
                    if let activeStroke = self.activeStroke{
                        self.strokes.append(activeStroke)
                    }
                    self.resetVariables()
                }
            }
        }
    }
    
    public func fillColor(at point: CGPoint, colorFill: UIColor, complete: (() -> Void)?) {
        let location = CGPoint(x: point.x * UIScreen.main.scale, y: point.y * UIScreen.main.scale)
        DispatchQueue.global(qos: .background).async {
            let (clipRect, mask) = self.coloringImage.getFillMaskAt(x: Int(location.x), y: Int(location.y))
            if let mask = mask {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveLinear) {
                        self.setClip(clipRect, maskImage: mask)
                        self.frozenContext.setFillColor(colorFill.cgColor)
                        self.frozenContext.fill(clipRect)
                        self.activeStroke?.drawInContext(self.frozenContext)
                        self.setNeedsDisplay()
                    }
                    self.resetVariablesHistory()
                    complete?()
                }
            }
        }
    }
    
    public func calculateColorCoverage() -> Double {
        guard let image = frozenContext.makeImage() else { return 0.0 }
        
        let width = image.width
        let height = image.height
        let totalPixelCount = width * height
        var coloredPixelCount = 0
        
        // Tạo một buffer dành cho dữ liệu pixel
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: totalPixelCount * 4)
        
        // Lấy dữ liệu pixel từ ảnh
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: buffer,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Đếm số lượng pixel đã được tô màu
        for i in 0..<totalPixelCount {
            let alpha = buffer[i * 4 + 3]
            let red = buffer[i * 4]
            let green = buffer[i * 4 + 1]
            let blue = buffer[i * 4 + 2]
            
            // Bỏ qua màu trong suốt và màu FFFFFE RGB(255, 255, 254)
            if alpha > 0 && !(red == 255 && green == 255 && blue == 254) {
                coloredPixelCount += 1
            }
        }
        
        // Giải phóng bộ nhớ của buffer
        buffer.deallocate()
        
        // Tính phần trăm phủ màu
        var per = Double(coloredPixelCount) / Double(totalPixelCount)
        per = percentColorImage + per
        
        return per
    }
    
    public func calculateColorCoverageLayer() -> Double {
        let image = coloringImage.cgImage
        
        let width = image.width
        let height = image.height
        let totalPixelCount = width * height
        var coloredPixelCount = 0
        
        // Tạo một buffer dành cho dữ liệu pixel
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: totalPixelCount * 4)
        
        // Lấy dữ liệu pixel từ ảnh
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: buffer,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: width * 4,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Đếm số lượng pixel đã được tô màu
        for i in 0..<totalPixelCount {
            let alpha = buffer[i * 4 + 3]
            let red = buffer[i * 4]
            let green = buffer[i * 4 + 1]
            let blue = buffer[i * 4 + 2]
            
            // Bỏ qua màu trong suốt và màu FFFFFE RGB(255, 255, 254)
            if alpha > 0 && !(red == 255 && green == 255 && blue == 254) {
                coloredPixelCount += 1
            }
        }
        
        // Giải phóng bộ nhớ của buffer
        buffer.deallocate()
        
        // Tính phần trăm phủ màu
        return Double(coloredPixelCount) / Double(totalPixelCount)
    }
}
