//
//  FillColoringController.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 22/4/24.
//  
//

import Foundation
import RxSwift
import UIKit
import Lottie

class FillColoringController: BaseViewController {
    
    var viewModel: FillColoringVM!
    
    @IBOutlet weak var topBarView: TopBarView!
    
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSaver: UIButton!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var viewAnmation: LottieAnimationView!
    
    @IBOutlet weak var btnNextPageRight: UIButton!
    
    @IBOutlet weak var listCategory: UICollectionView!
    
    @IBOutlet weak var btnNextPageLeft: UIButton!
    
    @IBOutlet weak var viewSliderColor: UIView!
    @IBOutlet weak var sliderColor: UISlider!
    
    @IBOutlet weak var listColor: UICollectionView!
    
    @IBOutlet weak var heightListColor: NSLayoutConstraint!
    
    @IBOutlet weak var viewFillterColor: UIView!
    @IBOutlet weak var listFillter: UICollectionView!
    
    @IBOutlet weak var viewAds: UIView!
    
    var listItemCategory: [TableColor] = TableColor.allCases
    var themeColor: ListFillterColor = .Pastel
    var listItemColor: [ItemColor] = []
    
    private var currentIndex = 0
    private var indexItemColor: Int = 0
    private var indexTheme: Int = 0
    private let startColor = UIColor.black
    private let endColor = UIColor.white
    private let minimumNumberOfTouches = 1
    private var currentColor: UIColor = .black
    private var imageColor: PaintImageView!
    
    override func setup() {
        super.setup()
        setupView()
    }

    override func bindingData() {
        super.bindingData()
    }
    
    func setupView() {
        let heightView = ((listColor.frame.width - 56) / 8) * 2 + 8
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
            AppRouter.shared.popToController(controller: MainColoringsController.classForCoder())
        }
        
        topBarView.onRightClick = {
            
        }
        
        if let img = UIImage(contentsOfFile: FileManagerLocal.shared.getFileFoderFileUssing(typeFile: .Coloring, file: viewModel.coloringImage).path) {
            addViewImage(image: img)
        }
        
        sliderColor.minimumValue = 0
        sliderColor.maximumValue = 200
        sliderColor.value = 0
        sliderColor.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        listColor.register(cellType: ColorCell.self)
        listColor.delegate = self
        listColor.dataSource = self
        
        listFillter.register(cellType: FillterColorCell.self)
        listFillter.delegate = self
        listFillter.dataSource = self
        
        listCategory.register(cellType: CategoryColorCell.self)
        listCategory.delegate = self
        listCategory.dataSource = self
        reloadCategory(.Skin_Color)
        
    }
    
    func addViewImage(image: UIImage) {
        imageColor = PaintImageView(image: image)
        imageColor.isUserInteractionEnabled = true
        imageColor.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(imageColor)
        imageColor.layer.cornerRadius =  10
        NSLayoutConstraint.activate([
            imageColor.leadingAnchor.constraint(greaterThanOrEqualTo: viewContent.leadingAnchor, constant: 0),
            imageColor.trailingAnchor.constraint(greaterThanOrEqualTo: viewContent.trailingAnchor, constant: 0),
            imageColor.topAnchor.constraint(greaterThanOrEqualTo: viewContent.topAnchor, constant: 0),
            imageColor.bottomAnchor.constraint(greaterThanOrEqualTo: viewContent.bottomAnchor, constant: 0),
            imageColor.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: 0),
            imageColor.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0)
        ])
        imageColor.newColor = currentColor
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
        listCategory.setContentOffset(CGPoint(x: currentIndex * Int(listCategory.frame.width), y: 0), animated: true)
    }
    
    func reloadTheme(_ index: Int) {
        listItemColor = []
        themeColor.listColor[index].listColor.forEach { item in
            listItemColor.append(ItemColor(color: item.color))
        }
        indexTheme = index
        selectItemColor(0)
        listFillter.reloadData()
    }
    
    func selectItemColor(_ index: Int) {
        indexItemColor = index
        updateSliderColor()
        listColor.reloadData()
    }
    
    func updateSliderColor() {
        sliderColor.value = 100
        updateColors()
    }
    
    func updateColors() {
        let totalValue = CGFloat(sliderColor.maximumValue)
        let currentValue = CGFloat(sliderColor.value)
        var minddleColor = UIColor()
        guard !listItemColor.isEmpty, let hex = listItemColor[indexItemColor].hex else {
            currentColor = listItemColor[indexItemColor].color ?? .black
            imageColor.newColor = currentColor
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
        if imageColor != nil {
            imageColor.newColor = currentColor
        }
    }
    
    func scrollToItemCategory(_ index: Int) {
        if index == -1 || index == listItemCategory.count {
            return
        }
        currentIndex = index
        reloadCategory(listItemCategory[currentIndex])
    }
    
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        updateColors()
    }
    
    @objc private func changePanGestureTemplate(_ gesture: UIPanGestureRecognizer) {
        let transform = imageColor.transform
        imageColor.transform = CGAffineTransform.identity
        let point: CGPoint = gesture.translation(in: imageColor)
        let movedPoint = CGPoint(x: imageColor.center.x + point.x,
                                 y: imageColor.center.y + point.y)
        imageColor.center = movedPoint
        imageColor.transform = transform
        gesture.setTranslation(CGPoint.zero, in: imageColor)
    }
    
    @objc private func changePinchGestureTemplate(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.changed { // Pinching in operating
            
            let pinchCenter = CGPoint(x: gesture.location(in: imageColor).x - imageColor.bounds.midX,
                                      y: gesture.location(in: imageColor).y - imageColor.bounds.midY)
            let transform = imageColor.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: gesture.scale, y: gesture.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            imageColor.transform = transform
            gesture.scale = 1
        }
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
}

extension FillColoringController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case listCategory:
            return listItemCategory.count
        case listColor:
            return listItemColor.count
        case listFillter:
            return themeColor.listColor.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case listCategory:
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CategoryColorCell.self)
            cell.lbName.text = listItemCategory[indexPath.row].title
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
        case listFillter:
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
        case listFillter:
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
        case listFillter:
            let height = collectionView.frame.height
            return CGSize(width: height, height: height)
        default:
            let height = (collectionView.frame.height)
            let width = (collectionView.frame.width)
            return CGSize(width: width, height: height)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(listCategory) {
            scrollToItemCategory(Int(listCategory.contentOffset.x / listCategory.frame.width))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listCategory {
            return 0
        }
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listCategory {
            return 0
        }
        return 8
    }
}
