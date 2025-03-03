//
//  StartColoringIPadViewController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 22/5/24.
//

import Foundation
import RxSwift
import UIKit
import simd
#if canImport(PhotosUI)
import PhotosUI
#endif
import Lottie
import SDWebImage

class StartColoringIPadViewController: BaseViewController {
    
    var viewModel: StartColoringVM!
    
    @IBOutlet weak var progessRing: ALProgressRing!
    
    @IBOutlet weak var lbPercenColoring: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnUndo: UIButton!
    
    @IBOutlet weak var btnFill: UIButton!
    
    @IBOutlet weak var btnPen: UIButton!
    
    @IBOutlet weak var btnRedo: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var stackContent: UIStackView!
    
    @IBOutlet weak var viewChangeLineWidth: UIView!
    
    @IBOutlet weak var btnMinus: UIButton!
    
    @IBOutlet weak var sliderView: UISlider!
    
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var viewColorPicker: UIView!
    
    @IBOutlet weak var heightColorpicker: NSLayoutConstraint!
    
    @IBOutlet weak var widthColorpicker: NSLayoutConstraint!
    
    @IBOutlet weak var listColor: UICollectionView!
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var heightViewAds: NSLayoutConstraint!
    
    @IBOutlet weak var stackToolView: UIStackView!
    
    @IBOutlet weak var stackColorView: UIStackView!
    
    @IBOutlet weak var stackToolsView: UIStackView!
    
    @IBOutlet weak var btnPencil: UIButton!
    
    @IBOutlet weak var btnEraser: UIButton!
    
    @IBOutlet weak var btnPaintPalette: UIButton!
    
    @IBOutlet weak var viewTools: UIView!
    
    @IBOutlet weak var viewColor: UIView!
    
    private var currentConstraintColorView: CGFloat = 160
    private var palettes: PalettesColor = .Plain
    private var colors: [ItemColor?] = []
    private var currentColor: UIColor?
    private var nameColor: String?
    private var isEraser: Bool = false
    private var lineWidthPen: Float = 0.2
    private let startColor = UIColor.black
    private let endColor = UIColor.white
    var coloringBookView: ColoringBookView!
    private let circleLayer = CAShapeLayer()
    private var panGesture: UIPanGestureRecognizer!
    let soundColoring =  AudioPlayer()
    
    private var indexListColor: Int? = 0
    private var indexColorBling: Int? = 0
    private var indexItemColor: Int? = 0
    
    override func setup() {
        super.setup()
        updateLayoutContent()
        setupView()
        getListColorIpad()
        createColoringBookView()
        loadAdsView()
        ADManager.shared.preLoadNative(DollColoringAdID.native_dialog, nativeAdType: .customMediaFixedHeight)
    }
    
    override func updateMorePortrait() {
        super.updateMorePortrait()
        swapViews(at: 0, with: 1, in: stackColorView)
        updateLayoutContent()
    }
    
    override func updateMoreLandscape() {
        super.updateMoreLandscape()
        updateLayoutContent()
    }
    
    private func setupView() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changePinchGestureTemplate(_ :)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(changePanGestureTemplate(_ :)))
        contentView.addGestureRecognizer(pinchGesture)
        contentView.addGestureRecognizer(panGesture)
        sliderView.setThumbImage(R.image.ic_pen_line_width(), for: .normal)
        sliderView.setThumbImage(R.image.ic_pen_line_width(), for: .highlighted)
        sliderView.setThumbImage(R.image.ic_pen_line_width(), for: .selected)
        sliderView.minimumValue = 0
        sliderView.maximumValue = 1
        sliderView.value = lineWidthPen
        sliderView.addTarget(self, action: #selector(sliderValueChangedLineWidth(_:)), for: .valueChanged)
        listColor.register(cellType: ColorCell.self)
        listColor.delegate = self
        listColor.dataSource = self
        
    }
    
    private func getListColorIpad() {
        self.colors = palettes.palettes.first?.listColor.first ?? []
        self.updateColors()
    }
    
    private func updateColors() {
        if let color = self.colors[indexItemColor ?? 0]{
            if let hex = color.hex {
                self.currentColor = UIColor(hexString: hex)
            } else {
                self.currentColor = color.color
            }
            self.nameColor = color.name
        }
        self.listColor.reloadData()
        self.updateColor()
    }
    
    private func updateLayoutContent() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            currentConstraintColorView = 140
        } else {
            currentConstraintColorView = 110
        }
        let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        switch isLandscape {
        case .unknown:
            break
        case .portrait, .portraitUpsideDown:
            stackContent.axis = .vertical
            heightColorpicker.constant = currentConstraintColorView
            widthColorpicker.constant = contentView.frame.width
            if let layout = listColor.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.invalidateLayout()
                layout.scrollDirection = .horizontal
            }
            listColor.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            viewColor.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 20)
            viewTools.roundCorners(corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 20)
            stackToolView.axis = .horizontal
            stackToolsView.axis = .vertical
            stackColorView.axis = .horizontal
            listColor.reloadData()
        case .landscapeLeft, .landscapeRight:
            stackContent.axis = .horizontal
            heightColorpicker.constant = contentView.frame.width
            widthColorpicker.constant = currentConstraintColorView
            if let layout = listColor.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.invalidateLayout()
                layout.scrollDirection = .vertical
            }
            viewColor.roundCorners(corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 20)
            viewTools.roundCorners(corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 20)
            listColor.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
            stackToolView.axis = .vertical
            stackToolsView.axis = .horizontal
            stackColorView.axis = .vertical
            listColor.reloadData()
            swapViews(at: 0, with: 1, in: stackColorView)
        default:
            break
        }
        coloringBookView.transform = .identity
        coloringBookView.transform = .identity.scaledBy(x: 1.2, y: 1.2)
    }
    
    @objc private func changePanGestureTemplate(_ gesture: UIPanGestureRecognizer) {
        let transform = coloringBookView.transform
        coloringBookView.transform = CGAffineTransform.identity
        let point: CGPoint = gesture.translation(in: contentView)
        let movedPoint = CGPoint(x: coloringBookView.center.x + point.x,
                                 y: coloringBookView.center.y + point.y)
        coloringBookView.center = movedPoint
        coloringBookView.transform = transform
        gesture.setTranslation(CGPoint.zero, in: coloringBookView)
    }
    
    @objc private func changePinchGestureTemplate(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .possible:
            print("changePinchGestureTemplate possible")
        case .began:
            coloringBookView.isZooming = true
        case .changed:
            let pinchCenter = CGPoint(x: gesture.location(in: coloringBookView).x - coloringBookView.bounds.midX,
                                      y: gesture.location(in: coloringBookView).y - coloringBookView.bounds.midY)
            let transform = coloringBookView.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            let minScale: CGFloat = 0.7
            let maxScale: CGFloat = 20.0
            if transform.a < minScale || transform.d < minScale {
                return
            }
            
            if transform.a > maxScale || transform.d > maxScale {
                return
            }
            
            coloringBookView.transform = transform
            gesture.scale = 1
        case .ended:
            coloringBookView.isZooming = false
        case .cancelled:
            coloringBookView.isZooming = false
        case .failed:
            coloringBookView.isZooming = false
        case .recognized:
            print("changePinchGestureTemplate recognized")
        @unknown default:
            break
        }
    }
    
    func updateLineWidthPen() {
        addDashedCircle(size: simd_mix(1.0, 40.0, lineWidthPen))
        coloringBookView.currentWidth = CGFloat(simd_mix(1.0, 40.0, lineWidthPen))
    }
    
    func addDashedCircle(size: Float) {
        circleLayer.removeFromSuperlayer()
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: contentView.frame.size.width / 2,
                                                           y: contentView.frame.size.height / 2),
                                        radius: CGFloat(size / 2.0),
                                        startAngle: 0,
                                        endAngle: .pi * 2,
                                        clockwise: true).cgPath
        circleLayer.lineWidth = 2.0
        circleLayer.strokeColor =  UIColor.red.cgColor//border of circle
        if btnEraser.isSelected {
            circleLayer.fillColor = UIColor.clear.cgColor
        } else {
            circleLayer.fillColor = currentColor?.withAlphaComponent(0.5).cgColor//inside the circle
        }
        circleLayer.lineJoin = .round
        circleLayer.lineDashPattern = [6,3]
        contentView.layer.addSublayer(circleLayer)
    }
    
    func blend(_ start: UIColor, _ end: UIColor, percentage: CGFloat) -> UIColor {
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        start.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        end.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let blendedRed = startRed + (endRed - startRed) * percentage
        let blendedGreen = startGreen + (endGreen - startGreen) * percentage
        let blendedBlue = startBlue + (endBlue - startBlue) * percentage
        let blendedAlpha = startAlpha + (endAlpha - startAlpha) * percentage
        
        return UIColor(red: blendedRed, green: blendedGreen, blue: blendedBlue, alpha: blendedAlpha)
    }
    
    func changeStateColoring(_ isPens: Bool) {
        btnPen.isSelected = isPens
        btnFill.isSelected = !isPens
        viewChangeLineWidth.isHidden = !isPens
        coloringBookView.isPens = isPens
        panGesture.maximumNumberOfTouches = isPens ? 2 : 1
        panGesture.minimumNumberOfTouches = isPens ? 2 : 1
    }
    
    func changeStateTools(_ tools: ToolsColoring) {
        btnPen.isSelected = false
        btnFill.isSelected = false
        btnEraser.isSelected = false
        btnPencil.isSelected = false
        switch tools {
        case .Pencil:
            btnPencil.isSelected = true
            viewChangeLineWidth.isHidden = true
            coloringBookView.currentWidth = CGFloat(simd_mix(1.0, 40.0, 0.2))
            coloringBookView.currentColor = currentColor ?? .red
            coloringBookView.nameColor = nameColor ?? ""
            panGesture.maximumNumberOfTouches = 2
            panGesture.minimumNumberOfTouches = 2
            coloringBookView.isPens = true
        case .Eraser:
            panGesture.maximumNumberOfTouches = 2
            panGesture.minimumNumberOfTouches = 2
            coloringBookView.currentColor = UIColor(hexString: "FFFFFE")
            coloringBookView.nameColor = "FFFFFE"
            btnEraser.isSelected = true
        case .Bucket:
            btnFill.isSelected = true
            viewChangeLineWidth.isHidden = true
            coloringBookView.currentColor = currentColor ?? .red
            coloringBookView.nameColor = nameColor ?? ""
        case .Brush:
            viewChangeLineWidth.isHidden = false
            coloringBookView.currentColor = currentColor ?? .red
            coloringBookView.nameColor = nameColor ?? ""
            btnPen.isSelected = true
        }
        FirebaseEventManager.logEvent(with: RMBGEventTracking.tool_click, params: ["tool": tools.rawValue])
    }
    
    private func swapViews(at index1: Int, with index2: Int, in stackView: UIStackView) {
        guard index1 != index2,
              index1 >= 0, index1 < stackView.arrangedSubviews.count,
              index2 >= 0, index2 < stackView.arrangedSubviews.count else {
            return
        }
        
        let view1 = stackView.arrangedSubviews[index1]
        let view2 = stackView.arrangedSubviews[index2]
        
        stackView.removeArrangedSubview(view1)
        stackView.removeArrangedSubview(view2)
        
        stackView.insertArrangedSubview(view2, at: index1)
        stackView.insertArrangedSubview(view1, at: index2)
        
        stackView.addSubview(view1)
        stackView.addSubview(view2)
    }
    
    @objc func sliderValueChangedLineWidth(_ sender: UISlider) {
        lineWidthPen = sender.value
        updateLineWidthPen()
        
    }
    
    @IBAction func actionBack(_ sender: Any) {
        let percent = coloringBookView.percentColoring
        let percentColoring = Int((percent * 100).rounded())
        if percentColoring < 100 {
            PopupColoringViewController.show(in: self, _percent: percent, _title: LocalizableUtils.commonDescExit(), _titleOk: LocalizableUtils.commonOK(), _titleCancel: LocalizableUtils.commonNo()) {
                if IAPState.isUserVip {
                    self.dissmissHistoryColoring()
                    return
                }
                ADManager.shared.preLoadNative(DollColoringAdID.nativefull_afterinter, refreshAd: true, nativeAdType: .customFullScreenNative)
                AdLoadingView.show()
                ADManager.shared.loadFull(DollColoringAdID.inter_back, isSplash: true) { state in
                    AdLoadingView.dismiss()
                    switch state {
                    case .closed, .error:
                        DispatchQueue.main.async {
                            if IAPState.isUserVip {
                                self.dissmissHistoryColoring()
                                return
                            }
                            NativeFullScreenController.show() {
                                self.dissmissHistoryColoring()
                            }
                        }
                    default:
                        break
                    }
                }
            } actionCancel: {
                
            }
            return
        }
        ADManager.shared.preLoadNative(DollColoringAdID.nativefull_afterinter, refreshAd: true, nativeAdType: .customFullScreenNative)
        AdLoadingView.show()
        ADManager.shared.loadFull(DollColoringAdID.inter_back, isSplash: true) { state in
            AdLoadingView.dismiss()
            switch state {
            case .closed, .error:
                DispatchQueue.main.async {
                    if IAPState.isUserVip {
                        self.dissmissHistoryColoring()
                        return
                    }
                    NativeFullScreenController.show() {
                        self.dissmissHistoryColoring()
                    }
                }
            default:
                break
            }
        }
        
    }
    
    func dissmissHistoryColoring(){
        self.saveHistoryColoring()
        switch self.viewModel.typeScreen {
        case .home:
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        case .coloring:
            AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
        case .detailColoring:
            AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
        case .collection:
            AppRouter.shared.popToController(controller: TabbarViewController.classForCoder())
        }
    }
    
    @IBAction func actionUndo(_ sender: Any) {
        //Send undo action to Coloring Book
        coloringBookView?.undo()
        checkColoringBookState()
        saveHistoryColoring()
    }
    
    @IBAction func actionFillColor(_ sender: Any) {
        changeStateColoring(false)
        changeStateTools(.Bucket)
    }
    
    @IBAction func actionPen(_ sender: Any) {
        changeStateColoring(true)
        changeStateTools(.Brush)
    }
    
    @IBAction func actionPencil(_ sender: Any) {
        changeStateTools(.Pencil)
    }
    
    @IBAction func actionEraser(_ sender: Any) {
        changeStateColoring(true)
        changeStateTools(.Eraser)
    }
    
    @IBAction func actionPainPalette(_ sender: Any) {
        TableColorIpadController.showView(in: self, indexListColor: indexListColor, indexColorBling: indexColorBling, palettes: palettes) { [weak self] colors, indexListColor, indexColorBling, palettes, indexColor in
            guard let self = self else {return}
            self.indexColorBling = indexColorBling
            self.indexListColor = indexListColor
            self.palettes = palettes
            self.indexItemColor = indexColor ?? 0
            self.colors = colors
            self.updateColors()
        }
    }
    
    @IBAction func actionRedo(_ sender: Any) {
        coloringBookView?.redo()
        checkColoringBookState()
        saveHistoryColoring()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        let percent = coloringBookView.percentColoring
        let percentColoring = Int((percent * 100).rounded())
        if percentColoring < 100 {
            PopupColoringViewController.show(in: self, _percent: percent, _title: LocalizableUtils.commonSaveColoring(), _titleOk: LocalizableUtils.commonSave(), _titleCancel: LocalizableUtils.commonDiscard()) {
                self.saveHistoryColoring()
                self.coloringBookView.layer.borderWidth = 0
                AppRouter.shared.navigate(to: SaveColoringRoute.main(imageColoring: self.coloringBookView.asImage(), coloringLocal: self.viewModel.coloringLocal, history: self.viewModel.history, typeScreen: self.viewModel.typeScreen), with: .push)
                self.coloringBookView.layer.borderWidth = 0.5
            } actionCancel: {
                
            }
        } else {
            saveHistoryColoring()
            coloringBookView.layer.borderWidth = 0
            AppRouter.shared.navigate(to: SaveColoringRoute.main(imageColoring: coloringBookView.asImage(), coloringLocal: viewModel.coloringLocal, history: viewModel.history, typeScreen: viewModel.typeScreen), with: .push)
            coloringBookView.layer.borderWidth = 0.5
        }
    }
    
    @IBAction func actionMinus(_ sender: Any) {
        if sliderView.value > 0 {
            lineWidthPen -= 0.1
            sliderView.value = lineWidthPen
            updateLineWidthPen()
        }
    }
    
    @IBAction func actionPlus(_ sender: Any) {
        if sliderView.value < 1 {
            lineWidthPen += 0.1
            sliderView.value = lineWidthPen
            updateLineWidthPen()
        }
    }
    
    @IBAction func actionTouchUp() {
        circleLayer.removeFromSuperlayer()
    }
}

extension StartColoringIPadViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        let data = colors[indexPath.row]
        if let hex = data?.hex {
            cell.setData(color: UIColor(hexString: hex), isSelect: indexPath.row == indexItemColor)
        } else {
            cell.setData(color: data?.color, isSelect: indexPath.row == indexItemColor)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = colors[indexPath.row]
        indexItemColor = indexPath.row
        if let hex = data?.hex {
            currentColor = UIColor(hexString: hex)
        } else {
            currentColor = data?.color
        }
        if !btnEraser.isSelected {
            updateColor()
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func updateColor() {
        coloringBookView.currentColor = currentColor ?? .red
        coloringBookView.nameColor = colors[indexItemColor ?? 0]?.name ?? ""
        nameColor = colors[indexItemColor ?? 0]?.name
        FirebaseEventManager.logEvent(with: RMBGEventTracking.item_color, params: ["table_color": colors[indexItemColor ?? 0]?.tableName ?? "",
                                                                                   "color": colors[indexItemColor ?? 0]?.name ?? ""])
        listColor.scrollToItem(at: IndexPath(row: indexItemColor ?? 0, section: 0), at: .centeredHorizontally, animated: false)
    }
}

extension StartColoringIPadViewController {
    func createColoringBookView() {
        //Add to contentView settings constraints
        coloringBookView.layer.cornerRadius = 16
        coloringBookView.layer.borderWidth = 0.5
        coloringBookView.layer.borderColor = UIColor.black.cgColor
        coloringBookView.clipsToBounds = true
        coloringBookView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coloringBookView)
        NSLayoutConstraint.activate([
            coloringBookView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coloringBookView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 40)
        ])
        //Change the default color and width of the new coloring Book View
        coloringBookView.currentColor = currentColor ?? .red
        coloringBookView.nameColor = ""
        coloringBookView.currentWidth = CGFloat(simd_mix(1.0, 40.0, lineWidthPen))
        coloringBookView.delegate = self
        coloringBookView.transform = .identity.scaledBy(x: 1.2, y: 1.2)
        progessRing.setProgress(Float(coloringBookView.percentColorImage), animated: true)
        lbPercenColoring.text = "\(Int(((coloringBookView.percentColorImage) * 100).rounded()))%"
        getHistoryColoring()
    }
    
    private func checkColoringBookState(){
        btnUndo.isEnabled = coloringBookView.canUndo
        btnRedo.isEnabled = coloringBookView.canRedo
    }
    
    
    func saveHistoryColoring() {
        if let history = viewModel.history, !history.imagePath.isEmpty {
            FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
        }
        let fileTo = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave)
        let indexName = FileManagerLocal.shared.getFileInDoucment(url: fileTo).sorted(by: {return ($0 as NSString).deletingPathExtension.compare(($1 as NSString).deletingPathExtension, options: .numeric) == .orderedAscending}).last?.replacingOccurrences(of: ".png", with: "")
        let fileName = fileTo.lastPathComponent + "\((Int(String(indexName?.extractNumbers() ?? "0")) ?? 0) + 1).png"
        
        // lưu ảnh vừa vẽ vào file manager của app
        coloringBookView.layer.borderWidth = 0
        guard  FileManagerLocal.shared.addImageToLocal(typeFile: .ColoringSave, fileName: fileName, image: coloringBookView.asImage()) else {
            coloringBookView.layer.borderWidth = 0.5
            return
        }
        coloringBookView.layer.borderWidth = 0.5
        // lưu các config và đường đãn của ảnh vừa vẽ vào DB
        let newHistory = HistoryModel(imagePath: fileName, percent_complete: coloringBookView.percentColoring, strokes: coloringBookView.strokes.map({ stroke in
            StrokeModel(lineWidth: stroke.lineWidth, color: stroke.color.toHexString(), id: 0, nameColor: stroke.nameColor, isPens: stroke.isPens, points: stroke.points.map({ point in
                PointModel(x: point.x, y: point.y)
            }), strokeRect: StrokeRectMode(x: stroke.strokeRect.x, y: stroke.strokeRect.y, width: stroke.strokeRect.width, height: stroke.strokeRect.height))
        }))
        
        if coloringBookView != nil {
            let coloring = viewModel.coloringLocal
            if let history = viewModel.history, coloring.historys.contains(where: {$0.imagePath == history.imagePath}) {
                var newHis = coloring.historys
                newHis.removeAll(where: {$0.imagePath == history.imagePath})
                newHis.append(newHistory)
                let historys = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
                if !SQLiteManager.shared.updateColorings(data: historys) {
                    self.coloringBookView?.reloadStrokes()
                    let new = HistoryModel(imagePath: fileName, percent_complete: newHistory.percent_complete, strokes: coloringBookView.strokes.map({ stroke in
                        StrokeModel(lineWidth: stroke.lineWidth, color: stroke.color.toHexString(), id: 0, nameColor: stroke.nameColor, points: stroke.points.map({ point in
                            PointModel(x: point.x, y: point.y)
                        }), strokeRect: StrokeRectMode(x: stroke.strokeRect.x, y: stroke.strokeRect.y, width: stroke.strokeRect.width, height: stroke.strokeRect.height))
                    }))
                    newHis.removeAll(where: {$0.imagePath == new.imagePath})
                    newHis.append(new)
                    let his = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
                    _ = SQLiteManager.shared.updateColorings(data: his)
                }
            } else {
                var newHis = coloring.historys
                newHis.append(newHistory)
                let historys = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
                if !SQLiteManager.shared.updateColorings(data: historys) {
                    self.coloringBookView?.reloadStrokes()
                    let new = HistoryModel(imagePath: fileName, percent_complete: newHistory.percent_complete, strokes: coloringBookView.strokes.map({ stroke in
                        StrokeModel(lineWidth: stroke.lineWidth, color: stroke.color.toHexString(), id: 0, nameColor: stroke.nameColor, points: stroke.points.map({ point in
                            PointModel(x: point.x, y: point.y)
                        }), strokeRect: StrokeRectMode(x: stroke.strokeRect.x, y: stroke.strokeRect.y, width: stroke.strokeRect.width, height: stroke.strokeRect.height))
                    }))
                    newHis.removeAll(where: {$0.imagePath == new.imagePath})
                    newHis.append(new)
                    let his = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
                    _ = SQLiteManager.shared.updateColorings(data: his)
                }
            }
            if let coloringModel = SQLiteManager.shared.selectionColorings().first(where: {$0.id == viewModel.coloringLocal.id}) {
                viewModel.coloringLocal = coloringModel
            }
            viewModel.history = newHistory
            let percent =  Float(newHistory.percent_complete ?? 0)
            progessRing.setProgress(percent, animated: true)
            lbPercenColoring.text = "\(Int((percent * 100).rounded()))%"
        }
    }
    
    func getHistoryColoring() {
        var stroke: [Stroke] = []
        if let history = viewModel.history {
            let imageUrlString = FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .ColoringSave, file: history.imagePath)
            let cacheKey = SDWebImageManager.shared.cacheKey(for: imageUrlString)
            SDImageCache.shared.removeImage(forKey: cacheKey, withCompletion: nil)
            let strokes = history.strokes
            strokes.forEach { detail in
                var color: UIColor = currentColor ?? UIColor(hexString: "FFFFFE")
                if let name = ItemThemeColor.allCases.first(where: {$0.itemColors.contains(where: {$0.name == detail.nameColor})}) {
                    if let c = name.itemColors.first(where: {$0.name?.contains(detail.nameColor) ?? true })?.color {
                        color = c
                    } else {
                        let hex = name.itemColors.first(where: {$0.name?.contains(detail.nameColor) ?? true})?.name
                        color = UIColor(hexString: hex ?? "")
                    }
                }
                var item = Stroke(color: color, lineWidth: detail.lineWidth, nameColor: detail.nameColor, isPens: detail.isPens ?? true)
                detail.points.forEach { point in
                    item.addPoint(CGPoint(x: point.x, y: point.y))
                }
                stroke.append(item)
            }
            coloringBookView.setStrokes(stroke)
            checkColoringBookState()
        }
        changeStateColoring(UserDefaultManager.ABTestFillColoring)
    }
    
    func loadAdsView() {
        if DeviceInfos.isIpad() {
            heightViewAds.constant = 90
        } else {
            heightViewAds.constant = 70
        }
        viewAds.isHidden = false
        ADManager.shared.loadBanner(DollColoringAdID.banner_coloring, viewBanner: viewAds) {[weak self] success in
            if DeviceInfos.isIpad() {
                self?.heightViewAds.constant = success ? 90 : 90
            } else {
                self?.heightViewAds.constant = success ? 70 : 70
            }
            self?.viewAds.isHidden = !success
        }
    }
    
}

extension StartColoringIPadViewController: ColoringBookViewDelegate {
    func viewWillStartDrawing() {
        circleLayer.removeFromSuperlayer()
        if !UserDefaultManager.disableSound, coloringBookView.isPens{
            soundColoring.loadAudio(type: .Sound)
        } else if !UserDefaultManager.disableSound, !coloringBookView.isPens {
            soundColoring.loadAudio(type: .fillColor)
        }
    }
    
    func viewDidEndDrawing() {
        self.checkColoringBookState()
        saveHistoryColoring()
        soundColoring.clearAudioPlayer()
    }
}

enum ToolsColoring: String {
    case Pencil = "Pencil"
    case Eraser = "Eraser"
    case Bucket = "Bucket"
    case Brush = "Brush"
}
