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
import Photos
#if canImport(PhotosUI)
import PhotosUI
#endif
import Lottie
import SDWebImage

class StartColoringIPadViewController: BaseViewController {
    
    var viewModel: StartColoringVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
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
    
    
    @IBOutlet weak var btnEraser: UIButton!
    
    @IBOutlet weak var btnPaintPalette: UIButton!

    /// Thin pencil brush — restored programmatically (was removed from storyboard).
    private lazy var btnPencil: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_not_select_pencil"), for: .normal)
        button.setImage(UIImage(named: "ic_select_pencil"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(actionPencil), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
        return button
    }()
    
    @IBOutlet weak var viewTools: UIView!
    
    @IBOutlet weak var viewColor: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var btnHidenNative: UIButton!
    
    @IBOutlet weak var viewAdsNative: UIView!
    @IBOutlet weak var viewCollapNative: UIView!
    
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
    private var bannerReloadTimer: Timer?
    
    override func setup() {
        super.setup()
        updateLayoutContent()
        setupView()
        getListColorIpad()
        createColoringBookView()
        loadAdsView()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerReloadTimer?.invalidate()
        bannerReloadTimer = nil
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
        
        installPencilToolIfNeeded()
        installUndoInToolBar()
        hideLegacyCanvasActionStrip()
        applyCrayoChrome()
    }

    /// Back + Share as plain white circular chips; no title.
    private func configureTopBarActions() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        let backIcon = UIImage(systemName: "chevron.left", withConfiguration: symbolConfig)
            ?? UIImage(named: "ic_left_back")
            ?? UIImage(named: "ic_back")
        let saveIcon = UIImage(systemName: "square.and.arrow.up", withConfiguration: symbolConfig)
            ?? UIImage(named: "ic_download_theme")
            ?? UIImage(named: "ic_save_image")

        topBarView.showPremium = false
        topBarView.setTitleHidden(true)
        topBarView.applyPlainWhiteActionButtons(
            leftImage: backIcon,
            rightImage: saveIcon,
            tintColor: AppTheme.text
        )
        topBarView.onLeftClick = { [weak self] in
            self?.actionBackTabbars()
        }
        topBarView.onRightClick = { [weak self] in
            self?.exportArtworkToPhotos()
        }
    }

    private func installPencilToolIfNeeded() {
        guard btnPencil.superview == nil else { return }
        // Order: Undo → Pencil → Fill → Brush → Eraser → Palette
        stackToolView.insertArrangedSubview(btnPencil, at: 0)
    }

    /// Put Undo next to drawing tools so the previous stroke can be undone easily.
    private func installUndoInToolBar() {
        guard let btnUndo else { return }
        btnUndo.removeFromSuperview()
        let undoIcon = UIImage(systemName: "arrow.uturn.backward",
                               withConfiguration: UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold))
            ?? UIImage(named: "ic_undo")
        btnUndo.setImage(undoIcon?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnUndo.setImage(nil, for: .selected)
        btnUndo.backgroundColor = .clear
        stackToolView.insertArrangedSubview(btnUndo, at: 0)
    }

    /// Old floating Undo/Clear/Save/Redo strip — replaced by top-bar Save + tool-bar Undo.
    private func hideLegacyCanvasActionStrip() {
        btnBack?.isHidden = true
        btnSave?.isHidden = true
        btnRedo?.isHidden = true
        btnBack?.superview?.superview?.isHidden = true
    }

    /// Match Home / Crayo pink cream palette (replaces old blue–yellow chrome).
    private func applyCrayoChrome() {
        let bg = AppTheme.background
        view.backgroundColor = bg
        contentView.backgroundColor = bg
        stackContent?.backgroundColor = .clear
        viewColorPicker?.backgroundColor = .clear
        viewColorPicker?.isOpaque = false
        stackToolsView?.backgroundColor = .clear
        stackToolsView?.isOpaque = false
        // Storyboard full-bleed bg imageView still uses AppBackground asset — force pink.
        view.subviews
            .compactMap { $0 as? UIImageView }
            .forEach { $0.backgroundColor = bg; $0.image = nil }

        // Transparent top chrome so canvas shows through; only the corner chips remain.
        topView.backgroundColor = .clear
        topView.isOpaque = false
        topView.layer.cornerRadius = 0
        topView.layer.maskedCorners = []
        topView.clipsToBounds = false
        topBarView.backgroundColorView = .clear
        topBarView.backgroundColor = .clear
        topBarView.isOpaque = false
        topBarView.layer.cornerRadius = 0
        topBarView.clipsToBounds = false
        topBarView.setTitleHidden(true)
        topBarView.tintColor = AppTheme.text
        // iPad status bar often isn't in safeAreaInsets — keep Back/Share below it.
        if let heightConstraint = topView.constraints.first(where: { $0.firstAttribute == .height }) {
            heightConstraint.constant = max(118, LayoutChrome.windowTopSafeArea + 56 + 16)
        }

        // Only the floating tool pill stays white; strip behind it is clear.
        viewTools.backgroundColor = UIColor.white.withAlphaComponent(0.96)
        viewTools.layer.cornerRadius = 24
        viewTools.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        viewTools.layer.borderWidth = 1
        viewTools.layer.borderColor = AppTheme.border.cgColor
        viewTools.clipsToBounds = true
        viewTools.layer.shadowOpacity = 0
        viewTools.layer.shadowRadius = 0
        viewTools.layer.shadowOffset = .zero
        [btnUndo, btnFill, btnPen, btnPencil, btnEraser, btnPaintPalette].forEach { button in
            button?.backgroundColor = .clear
            button?.layer.cornerRadius = 12
            button?.clipsToBounds = true
        }
        applyConsistentToolIcons()

        viewColor.backgroundColor = .clear
        viewColor.isOpaque = false
        viewColor.layer.borderWidth = 0
        viewColor.layer.shadowOpacity = 0
        listColor?.backgroundColor = .clear
        listColor?.isOpaque = false
        // Clear storyboard fill on the tool-row host (not the color cells).
        viewTools.superview?.backgroundColor = .clear
        viewTools.superview?.isOpaque = false

        viewChangeLineWidth.backgroundColor = AppTheme.surface.withAlphaComponent(0.92)
        viewChangeLineWidth.layer.borderWidth = 1
        viewChangeLineWidth.layer.borderColor = AppTheme.border.cgColor
        sliderView.minimumTrackTintColor = AppTheme.primary
        sliderView.maximumTrackTintColor = AppTheme.primarySoft
        sliderView.tintColor = AppTheme.primary

        styleRoundChipButtons([btnMinus, btnPlus])
        styleToolUndoButton()
        configureTopBarActions()
    }

    private func styleToolUndoButton() {
        guard let btnUndo else { return }
        btnUndo.backgroundColor = .clear
        btnUndo.layer.cornerRadius = 12
        btnUndo.clipsToBounds = true
        btnUndo.tintColor = AppTheme.textSecondary
        btnUndo.imageView?.contentMode = .scaleAspectFit
    }

    /// Use one generated illustration family for every drawing action.
    private func applyConsistentToolIcons() {
        let tools: [(button: UIButton?, label: String, atlasIndex: Int, selectable: Bool)] = [
            (btnUndo, "Undo", 0, false),
            (btnPencil, "Pencil", 1, true),
            (btnFill, "Fill", 2, true),
            (btnPen, "Brush", 3, true),
            (btnEraser, "Eraser", 4, true),
            (btnPaintPalette, "Color palette", 5, false)
        ]

        for (button, label, atlasIndex, selectable) in tools {
            guard let button else { continue }
            let image = generatedToolIcon(at: atlasIndex)
            button.setImage(image, for: .normal)
            if selectable {
                button.setImage(image, for: .selected)
            }
            button.imageView?.contentMode = .scaleAspectFit
            button.accessibilityLabel = label
        }
    }

    private func generatedToolIcon(at index: Int) -> UIImage? {
        guard (0..<6).contains(index),
              let atlas = UIImage(named: "drawing_tool_icons"),
              let cgImage = atlas.cgImage else { return nil }

        let cellWidth = cgImage.width / 3
        let cellHeight = cgImage.height / 2
        let column = index % 3
        let row = index / 3
        let rect = CGRect(
            x: CGFloat(column * cellWidth),
            y: CGFloat(row * cellHeight),
            width: CGFloat(cellWidth),
            height: CGFloat(cellHeight)
        )
        guard let icon = cgImage.cropping(to: rect) else { return nil }
        return UIImage(cgImage: icon, scale: atlas.scale, orientation: .up)
    }

    private func styleCanvasActionButtons(_ buttons: [UIButton?]) {
        for button in buttons {
            guard let button else { continue }
            button.backgroundColor = AppTheme.primarySoft
            button.layer.cornerRadius = 14
            button.clipsToBounds = true
            button.tintColor = AppTheme.primary
            if let image = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate) {
                button.setImage(image, for: .normal)
            }
        }
    }

    private func styleRoundChipButtons(_ buttons: [UIButton?]) {
        for button in buttons {
            guard let button else { continue }
            button.backgroundColor = AppTheme.primarySoft
            button.layer.cornerRadius = 22
            button.clipsToBounds = true
            button.tintColor = AppTheme.primary
            if let image = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate) {
                button.setImage(image, for: .normal)
            }
        }
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
        viewTools.layer.cornerRadius = 24
        viewTools.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
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
        let size = resolvedStrokeWidth()
        addDashedCircle(size: Float(size))
        coloringBookView.currentWidth = size
    }

    /// Pencil stays thin/hard; brush uses the full soft range.
    private func resolvedStrokeWidth() -> CGFloat {
        if btnPencil.isSelected {
            return CGFloat(simd_mix(1.2, 12.0, lineWidthPen))
        }
        return CGFloat(simd_mix(2.5, 40.0, lineWidthPen))
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
        circleLayer.strokeColor =  UIColor.red.cgColor
        if btnEraser.isSelected {
            circleLayer.fillColor = UIColor.clear.cgColor
        } else {
            circleLayer.fillColor = currentColor?.withAlphaComponent(0.5).cgColor
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
        updateFlatToolSelection()
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
            viewChangeLineWidth.isHidden = false
            coloringBookView.currentColor = currentColor ?? .red
            coloringBookView.nameColor = nameColor ?? ""
            coloringBookView.strokeKind = .pencil
            panGesture.maximumNumberOfTouches = 2
            panGesture.minimumNumberOfTouches = 2
            coloringBookView.isPens = true
            updateLineWidthPen()
        case .Eraser:
            panGesture.maximumNumberOfTouches = 2
            panGesture.minimumNumberOfTouches = 2
            coloringBookView.currentColor = UIColor(hexString: "FFFFFE")
            coloringBookView.nameColor = "FFFFFE"
            coloringBookView.strokeKind = .brush
            coloringBookView.isPens = true
            btnEraser.isSelected = true
            viewChangeLineWidth.isHidden = false
            updateLineWidthPen()
        case .Bucket:
            btnFill.isSelected = true
            viewChangeLineWidth.isHidden = true
            coloringBookView.currentColor = currentColor ?? .red
            coloringBookView.nameColor = nameColor ?? ""
            coloringBookView.isPens = false
        case .Brush:
            viewChangeLineWidth.isHidden = false
            coloringBookView.currentColor = currentColor ?? .red
            coloringBookView.nameColor = nameColor ?? ""
            coloringBookView.strokeKind = .brush
            coloringBookView.isPens = true
            btnPen.isSelected = true
            panGesture.maximumNumberOfTouches = 2
            panGesture.minimumNumberOfTouches = 2
            updateLineWidthPen()
        }
        updateFlatToolSelection()
        FirebaseEventManager.logEvent(with: RMBGEventTracking.tool_click, params: ["tool": tools.rawValue])
    }

    /// Flat, tactile tool chips matching the lightweight 2D toolbar reference.
    private func updateFlatToolSelection() {
        [btnFill, btnPen, btnPencil, btnEraser].forEach { button in
            guard let button else { return }
            button.backgroundColor = button.isSelected ? AppTheme.primarySoft : .clear
            button.layer.borderWidth = button.isSelected ? 1 : 0
            button.layer.borderColor = button.isSelected
                ? AppTheme.primary.withAlphaComponent(0.18).cgColor
                : UIColor.clear.cgColor
            button.tintColor = button.isSelected ? AppTheme.primary : AppTheme.text
            button.layer.shadowOpacity = 0
        }
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
    @IBAction func actionCloseAds(_ sender: Any) {
        viewAdsNative.isHidden = true
        heightViewAds?.constant = 0
    }
    
    @IBAction func actionBack(_ sender: Any) {
        coloringBookView?.clear()
        createColoringBookView()
    }
    
    private func actionBackTabbars() {
        let percent = coloringBookView.percentColoring
        let percentColoring = Int((percent * 100).rounded())

        // 0% — leave quietly; do not persist into Collections.
        if percentColoring <= 0 {
            removeCurrentHistoryIfNeeded()
            popFromColoringScreen()
            return
        }

        if percentColoring < 100 {
            PopupColoringViewController.show(in: self,
                                             _percent: percent,
                                             _title: "Coloring.ExitConfirm".localizedString(
                                                tableName: "Localizable",
                                                defaultValue: "Save your progress before leaving?",
                                                comment: "Confirm leaving a coloring page"
                                             ),
                                             _titleOk: "Coloring.SaveAndLeave".localizedString(
                                                tableName: "Localizable",
                                                defaultValue: "Save & leave",
                                                comment: "Save progress and leave coloring"
                                             ),
                                             _titleCancel: "Coloring.KeepColoring".localizedString(
                                                tableName: "Localizable",
                                                defaultValue: "Keep coloring",
                                                comment: "Stay on the coloring page"
                                             )) {
                self.dissmissHistoryColoring()
            } actionCancel: {
            }
            return
        }

        dissmissHistoryColoring()
    }
    
    func dissmissHistoryColoring(){
        self.saveHistoryColoring()
        popFromColoringScreen()
    }

    private func popFromColoringScreen() {
        switch self.viewModel.typeScreen {
        case .home:
            AppRouter.shared.popToController(controller: MainTabbarViewController.classForCoder())
        case .coloring:
            AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
        case .detailColoring:
            AppRouter.shared.popToController(controller: DetailColoringController.classForCoder())
        case .collection:
            AppRouter.shared.popToController(controller: MainTabbarViewController.classForCoder())
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

    @objc private func actionPencil() {
        changeStateColoring(true)
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
        exportArtworkToPhotos()
    }

    /// Save the current artwork into the Photos library (download).
    private func exportArtworkToPhotos() {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited:
            writeArtworkToPhotos()
        case .denied, .restricted:
            createMyAlert(title: LocalizableUtils.title_open_library(), LocalizableUtils.message_open_libary()) {
                guard let url = URL(string: UIApplication.openSettingsURLString),
                      UIApplication.shared.canOpenURL(url) else { return }
                UIApplication.shared.open(url)
            }
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.writeArtworkToPhotos()
                    }
                }
            }
        @unknown default:
            break
        }
    }

    private func writeArtworkToPhotos() {
        guard coloringBookView != nil else { return }
        saveHistoryColoring()
        coloringBookView.layer.borderWidth = 0
        let image = coloringBookView.asImage()
        coloringBookView.layer.borderWidth = 0.5
        FirebaseEventManager.logEvent(with: RMBGEventTracking.save_coloring_screen)
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(artwork(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func artwork(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let title = LocalizableUtils.commonSave()
        let message = error == nil
            ? LocalizableUtils.save_picture_success()
            : LocalizableUtils.save_picture_fail()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizableUtils.commonOK(), style: .default))
        present(alert, animated: true)
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
        coloringBookView.currentColor = currentColor ?? .red
        coloringBookView.nameColor = ""
        coloringBookView.currentWidth = CGFloat(simd_mix(1.0, 40.0, lineWidthPen))
        coloringBookView.delegate = self
        coloringBookView.transform = .identity.scaledBy(x: 1.2, y: 1.2)
        getHistoryColoring()
    }
    
    private func checkColoringBookState(){
        btnUndo.isEnabled = coloringBookView.canUndo
        btnRedo.isEnabled = coloringBookView.canRedo
    }
    
    
    func saveHistoryColoring() {
        let percentColoring = Int((coloringBookView.percentColoring * 100).rounded())
        // Never add a blank (0%) page to Collections.
        if percentColoring <= 0 {
            removeCurrentHistoryIfNeeded()
            return
        }

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
        let newHistory = HistoryModel(
            imagePath: fileName,
            percent_complete: coloringBookView.percentColoring,
            strokes: coloringBookView.strokes.map { makeStrokeModel(from: $0) }
        )
        
        if coloringBookView != nil {
            let coloring = viewModel.coloringLocal
            if let history = viewModel.history, coloring.historys.contains(where: {$0.imagePath == history.imagePath}) {
                var newHis = coloring.historys
                newHis.removeAll(where: {$0.imagePath == history.imagePath})
                newHis.append(newHistory)
                let historys = ColoringHistoryModel(id: coloring.id, filePath: coloring.filePath, fileLocal: coloring.fileLocal, historys: newHis)
                if !SQLiteManager.shared.updateColorings(data: historys) {
                    self.coloringBookView?.reloadStrokes()
                    let new = HistoryModel(
                        imagePath: fileName,
                        percent_complete: newHistory.percent_complete,
                        strokes: coloringBookView.strokes.map { makeStrokeModel(from: $0) }
                    )
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
                    let new = HistoryModel(
                        imagePath: fileName,
                        percent_complete: newHistory.percent_complete,
                        strokes: coloringBookView.strokes.map { makeStrokeModel(from: $0) }
                    )
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

    private func makeStrokeModel(from stroke: Stroke) -> StrokeModel {
        StrokeModel(
            lineWidth: stroke.lineWidth,
            color: stroke.color.toHexString(),
            id: 0,
            nameColor: stroke.nameColor,
            isPens: stroke.isPens,
            strokeKind: stroke.kind.rawValue,
            points: stroke.points.map { PointModel(x: $0.x, y: $0.y) },
            strokeRect: StrokeRectMode(
                x: stroke.strokeRect.origin.x,
                y: stroke.strokeRect.origin.y,
                width: stroke.strokeRect.width,
                height: stroke.strokeRect.height
            )
        )
    }

    /// Drop the in-progress history when the page is fully blank again.
    private func removeCurrentHistoryIfNeeded() {
        guard let history = viewModel.history, !history.imagePath.isEmpty else { return }
        var coloring = viewModel.coloringLocal
        guard coloring.historys.contains(where: { $0.imagePath == history.imagePath }) else {
            viewModel.history = nil
            return
        }
        FileManagerLocal.shared.deleteFile(typeFile: .ColoringSave, fileName: history.imagePath)
        coloring.historys.removeAll(where: { $0.imagePath == history.imagePath })
        _ = SQLiteManager.shared.updateColorings(data: coloring)
        viewModel.coloringLocal = coloring
        viewModel.history = nil
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
                var item = Stroke(
                    color: color,
                    lineWidth: detail.lineWidth,
                    nameColor: detail.nameColor,
                    isPens: detail.isPens ?? true,
                    kind: StrokeKind(raw: detail.strokeKind)
                )
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
        bannerReloadTimer?.invalidate()
        viewAdsNative?.isHidden = true
        viewCollapNative?.isHidden = true
        viewAds?.isHidden = true
        heightViewAds?.constant = 0
    }
    
    func reloadNativeAds() {
        // Ads removed
    }
    
    
}

extension StartColoringIPadViewController: ColoringBookViewDelegate {
    func viewWillStartDrawing() {
        circleLayer.removeFromSuperlayer()
        guard !UserDefaultManager.disableSound else { return }
        if coloringBookView.isPens {
            // Loop ASMR brush sound for the whole stroke (old feel).
            soundColoring.loadAudio(type: .Sound, isLoop: true)
        } else {
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
