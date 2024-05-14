//
//  StartColoringController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//
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

class StartColoringController: BaseViewController {
    
    var viewModel: StartColoringVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var btnUndo: UIButton!
    
    @IBOutlet weak var btnRedo: UIButton!
    
    @IBOutlet weak var btnFill: UIButton!
    
    @IBOutlet weak var btnPens: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var btnZoomOut: UIButton!
    
    @IBOutlet weak var btnZoomIn: UIButton!
    
    @IBOutlet weak var listLibraryColor: UICollectionView!
    
    @IBOutlet weak var listColor: UICollectionView!
    
    @IBOutlet weak var heightListColor: NSLayoutConstraint!
    
    @IBOutlet weak var viewFillterColor: UIView!
    @IBOutlet weak var listFilterColor: UICollectionView!
    
    @IBOutlet weak var viewSliderColor: UIView!
    
    @IBOutlet weak var sliderColor: UISlider!
    
    @IBOutlet weak var viewAds: UIView!
    
    @IBOutlet weak var heightViewAds: NSLayoutConstraint!
    
    @IBOutlet weak var viewAnimation: LottieAnimationView!
    
    @IBOutlet weak var sliderLineWidth: UISlider!
    
    @IBOutlet weak var viewChangeLineWidth: UIView!
    
    let soundColoring =  AudioPlayer()
    
    var listCategory: [TableColor] = TableColor.allCases
    var themeColor: ListFillterColor = .Pastel
    var listItemColor: [ItemColor] = []
    private var currentIndex = 0
    private var indexItemColor: Int = 0
    private var indexTheme: Int = 0
    private var lineWidthPen: Float = 0.2
    private let startColor = UIColor.black
    private let endColor = UIColor.white
    private let minimumNumberOfTouches = 2
    private var currentColor: UIColor = .black
    var coloringBookView: ColoringBookView!
    private let circleLayer = CAShapeLayer()
    
    override func setup() {
        super.setup()
        setupView()
        createColoringBookView()
        loadAdsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listColor.reloadData()
        viewAnimation.loadAnimation(file: "animationView_StartColoring", animationSpeed: 0.7) {[weak self] isSuccess in
            self?.viewAnimation.isHidden = isSuccess
        }
    }
    
    override func bindingData() {
        super.bindingData()
    }
    
    override func viewDidLayoutSubviews() {
        viewFillterColor.layer.cornerRadius = viewFillterColor.frame.height / 2
        viewContent.roundCorners(corners: [.topLeft, .topRight], radius: 16)
    }
    
    func setupView() {
        let screen = UIScreen.main.bounds.width - 62
        let heightView = ((screen - 56) / 8) * 2 + 8
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changePinchGestureTemplate(_ :)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(changePanGestureTemplate(_ :)))
        
        panGesture.minimumNumberOfTouches = minimumNumberOfTouches
        panGesture.maximumNumberOfTouches = minimumNumberOfTouches
        viewContent.addGestureRecognizer(pinchGesture)
        viewContent.addGestureRecognizer(panGesture)
        heightListColor.constant = heightView
        topBarView.title = LocalizableUtils.commonStartColoring().uppercased()
        topBarView.titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        topBarView.onLeftClick = {
            switch self.viewModel.typeScreen {
            case .home:
                AppRouter.shared.popToController(controller: HomeController.classForCoder())
            case .coloring:
                AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
            case .detailColoring:
                AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
            case .collection:
                AppRouter.shared.popToController(controller: CollectionsController.classForCoder())
            }
        }
        
        topBarView.onRightClick = {
            self.showSettingView()
        }
        sliderColor.minimumValue = 0
        sliderColor.maximumValue = 200
        sliderColor.value = 0
        sliderColor.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderLineWidth.setThumbImage(R.image.ic_pen_line_width(), for: .normal)
        sliderLineWidth.setThumbImage(R.image.ic_pen_line_width(), for: .highlighted)
        sliderLineWidth.setThumbImage(R.image.ic_pen_line_width(), for: .selected)
        sliderLineWidth.minimumValue = 0
        sliderLineWidth.maximumValue = 1
        sliderLineWidth.value = lineWidthPen
        sliderLineWidth.addTarget(self, action: #selector(sliderValueChangedLineWidth(_:)), for: .valueChanged)
        
        
        listColor.register(cellType: ColorCell.self)
        listColor.delegate = self
        listColor.dataSource = self
        
        listFilterColor.register(cellType: FillterColorCell.self)
        listFilterColor.delegate = self
        listFilterColor.dataSource = self
        
        listLibraryColor.register(cellType: CategoryColorCell.self)
        listLibraryColor.delegate = self
        listLibraryColor.dataSource = self
        reloadCategory(.Skin_Color)
    }
    
    func reloadCategory(_ item: TableColor) {
        indexItemColor = 0
        indexTheme = 0
        viewFillterColor.isHidden = true
        viewSliderColor.isHidden = true
        switch item {
        case .Pastel_Color, .Sweet_Color, .Mystical_Color:
            viewFillterColor.isHidden = false
            themeColor = item.lisTheme ?? .Pastel
            reloadTheme(0)
        default:
            viewSliderColor.isHidden = false
            listItemColor = item.listColor
            selectItemColor(0)
        }
        listLibraryColor.setContentOffset(CGPoint(x: currentIndex * Int(listLibraryColor.frame.width), y: 0), animated: true)
    }
    
    func reloadTheme(_ index: Int) {
        listItemColor = []
        themeColor.listColor[index].listColor.forEach { item in
            listItemColor.append(ItemColor(color: item.color, name: item.name))
        }
        indexTheme = index
        selectItemColor(0)
        listFilterColor.reloadData()
    }
    
    func selectItemColor(_ index: Int) {
        indexItemColor = index
        updateSliderColor()
        listColor.reloadData()
    }
    
    func scrollToItemCategory(_ index: Int) {
        if index == -1 || index == listCategory.count {
            return
        }
        currentIndex = index
        reloadCategory(listCategory[currentIndex])
    }
    
    func updateColors() {
        let totalValue = CGFloat(sliderColor.maximumValue)
        let currentValue = CGFloat(sliderColor.value)
        var minddleColor = UIColor()
        guard !listItemColor.isEmpty, let hex = listItemColor[indexItemColor].hex else {
            currentColor = listItemColor[indexItemColor].color ?? .black
            coloringBookView.currentColor = currentColor
            coloringBookView.nameColor = listItemColor[indexItemColor].name ?? ""
            return
        }
        minddleColor = UIColor(hexString: hex)
        var color: UIColor
        if currentValue <= totalValue / 2 {
            // Transition from startColor to middleColor
            let percentage = currentValue / (totalValue / 2)
            color = blend(startColor, minddleColor, percentage: percentage)
        } else {
            // Transition from middleColor to endColor
            let percentage = (currentValue - totalValue / 2) / (totalValue / 2)
            color = blend(minddleColor, endColor, percentage: percentage)
        }
        sliderColor.minimumTrackTintColor = color
        currentColor = color
        if coloringBookView != nil {
            coloringBookView.currentColor = color
        }
    }
    
    func updateSliderColor() {
        sliderColor.value = 100
        updateColors()
    }
    
    func updateLineWidthPen() {
        addDashedCircle(size: lineWidthPen * 100)
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
        circleLayer.fillColor = currentColor.cgColor//inside the circle
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
        btnPens.isSelected = isPens
        btnFill.isSelected = !isPens
        viewChangeLineWidth.isHidden = !isPens
        coloringBookView.isPens = isPens
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        updateColors()
    }
    
    @objc func sliderValueChangedLineWidth(_ sender: UISlider) {
        lineWidthPen = sender.value
        updateLineWidthPen()
    }
    
    @objc private func changePanGestureTemplate(_ gesture: UIPanGestureRecognizer) {
        let transform = coloringBookView.transform
        coloringBookView.transform = CGAffineTransform.identity
        let point: CGPoint = gesture.translation(in: coloringBookView)
        let movedPoint = CGPoint(x: coloringBookView.center.x + point.x,
                                 y: coloringBookView.center.y + point.y)
        coloringBookView.center = movedPoint
        coloringBookView.transform = transform
        gesture.setTranslation(CGPoint.zero, in: coloringBookView)
    }
    
    @objc private func changePinchGestureTemplate(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.changed { // Pinching in operating
            
            let pinchCenter = CGPoint(x: gesture.location(in: coloringBookView).x - coloringBookView.bounds.midX,
                                      y: gesture.location(in: coloringBookView).y - coloringBookView.bounds.midY)
            let transform = coloringBookView.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            coloringBookView.transform = transform
            gesture.scale = 1
        }
    }
    
    @IBAction func actionUndo(_ sender: Any) {
        //Send undo action to Coloring Book
        self.coloringBookView?.undo()
        self.checkColoringBookState()
        self.saveHistoryColoring()
    }
    
    @IBAction func actionRedo(_ sender: Any) {
        self.coloringBookView?.redo()
        self.checkColoringBookState()
        self.saveHistoryColoring()
    }
    
    @IBAction func actionFill(_ sender: Any) {
        changeStateColoring(false)
    }
    
    @IBAction func actionPens(_ sender: Any) {
        changeStateColoring(true)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        coloringBookView.layer.borderWidth = 0
        AppRouter.shared.navigate(to: SaveColoringRoute.main(imageColoring: coloringBookView.asImage(), coloringLocal: viewModel.coloringLocal, history: viewModel.history, typeScreen: viewModel.typeScreen), with: .push)
        coloringBookView.layer.borderWidth = 0.5
    }
    
    @IBAction func actionSave(_ sender: Any) {
        coloringBookView.layer.borderWidth = 0
        AppRouter.shared.navigate(to: SaveColoringRoute.main(imageColoring: coloringBookView.asImage(), coloringLocal: viewModel.coloringLocal, history: viewModel.history, typeScreen: viewModel.typeScreen), with: .push)
        coloringBookView.layer.borderWidth = 0.5
    }
    
    @IBAction func actionZoom(_ sender: Any) {
        if sliderLineWidth.value > 0 {
            lineWidthPen -= 0.1
            sliderLineWidth.value = lineWidthPen
            updateLineWidthPen()
        }
    }
    
    @IBAction func actionZoomIn(_ sender: Any) {
        if sliderLineWidth.value < 1 {
            lineWidthPen += 0.1
            sliderLineWidth.value = lineWidthPen
            updateLineWidthPen()
        }
    }
    
    @IBAction func actionNextRight(_ sender: Any) {
        scrollToItemCategory(currentIndex + 1)
    }
    
    @IBAction func actionNextLeft(_ sender: Any) {
        scrollToItemCategory(currentIndex - 1)
    }
    
    func loadAdsView() {
        ADManager.shared.loadBanner(DollColoringAdID.banner_coloring, viewBanner: viewAds) {[weak self] success in
            self?.viewAds.isHidden = !success
        }
    }
}

extension StartColoringController {
    func createColoringBookView() {
        
        //Add to contentView settings constraints
        self.coloringBookView.layer.cornerRadius = 16
        self.coloringBookView.layer.borderWidth = 0.5
        self.coloringBookView.layer.borderColor = UIColor.black.cgColor
        self.coloringBookView.clipsToBounds = true
        self.coloringBookView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.coloringBookView)
        NSLayoutConstraint.activate([
            self.coloringBookView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.coloringBookView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        //Change the default color and width of the new coloring Book View
        self.coloringBookView.currentColor = self.currentColor
        self.coloringBookView.nameColor = ""
        self.coloringBookView.currentWidth = CGFloat(simd_mix(1.0, 40.0, self.lineWidthPen))
        self.coloringBookView.delegate = self
        self.coloringBookView.transform = .identity.scaledBy(x: 1.5, y: 1.5)
        self.getHistoryColoring()
    }
    
    private func checkColoringBookState(){
        self.btnUndo.isEnabled = coloringBookView.canUndo
        self.btnRedo.isEnabled = coloringBookView.canRedo
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
        let newHistory = HistoryModel(imagePath: fileName, strokes: coloringBookView.strokes.map({ stroke in
            StrokeModel(lineWidth: stroke.lineWidth, color: stroke.color.toHexString(), id: 0, nameColor: stroke.nameColor, points: stroke.points.map({ point in
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
                    let new = HistoryModel(imagePath: fileName, strokes: coloringBookView.strokes.map({ stroke in
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
                    let new = HistoryModel(imagePath: fileName, strokes: coloringBookView.strokes.map({ stroke in
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
                var color: UIColor = .black
                if let c = ItemThemeColor.allCases.first(where: {$0.name == detail.nameColor})?.color {
                   color = c
                } else if let name = TableColor.allCases.first(where: {$0.listColor.contains(where: {$0.name == detail.nameColor})}) {
                    if let c = name.listColor.first(where: {$0.name == detail.nameColor})?.color {
                        color = c
                    } else {
                        let hex = name.listColor.first(where: {$0.name == detail.nameColor})?.name
                        color = UIColor(hexString: hex ?? "")
                    }
                } else {
                    color = UIColor(hexString: detail.color.replacingOccurrences(of: "#", with: ""))
                }
                var item = Stroke(color: color, lineWidth: detail.lineWidth, nameColor: detail.nameColor)
                detail.points.forEach { point in
                    item.addPoint(CGPoint(x: point.x, y: point.y))
                }
                stroke.append(item)
            }
            coloringBookView.setStrokes(stroke)
            checkColoringBookState()
        }
    }
    
}

extension StartColoringController: ColoringBookViewDelegate {
    func viewWillStartDrawing() {
        circleLayer.removeFromSuperlayer()
        if !UserDefaultManager.disableSound {
            soundColoring.loadAudio(type: .Sound)
        }
        Vibration.rigid.vibrate()
    }
    
    func viewDidEndDrawing() {
        self.checkColoringBookState()
        saveHistoryColoring()
        soundColoring.clearAudioPlayer()
    }
}

extension StartColoringController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case listLibraryColor:
            return listCategory.count
        case listColor:
            return listItemColor.count
        case listFilterColor:
            return themeColor.listColor.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case listLibraryColor:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryColorCell.self)
            cell.lbName.text = listCategory[indexPath.row].title
            return cell
        case listColor:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ColorCell.self)
            let data = listItemColor[indexPath.row]
            if let hex = data.hex {
                cell.setData(color: UIColor(hexString: hex), isSelect: indexPath.row == indexItemColor)
            } else {
                cell.setData(color:  data.color, isSelect: indexPath.row == indexItemColor)
            }
            return cell
        case listFilterColor:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FillterColorCell.self)
            let index = indexPath.row
            cell.setupData(index, isSelect: indexTheme == index)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case listColor:
            selectItemColor(indexPath.row)
        case listFilterColor:
            reloadTheme(indexPath.row)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case listColor:
            let height = (collectionView.frame.width - 56) / 8
            return CGSize(width: height, height: height)
        case listFilterColor:
            let height = collectionView.frame.height
            return CGSize(width: height, height: height)
        default:
            let height = (collectionView.frame.height)
            let width = (collectionView.frame.width)
            return CGSize(width: width, height: height)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(listLibraryColor) {
            scrollToItemCategory(Int(listLibraryColor.contentOffset.x / listLibraryColor.frame.width))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listLibraryColor {
            return 0
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listLibraryColor {
            return 0
        }
        return 8
    }
}
