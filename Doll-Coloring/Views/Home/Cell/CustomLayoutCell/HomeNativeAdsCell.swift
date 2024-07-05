//
//  HomeNativeAdsCell.swift
//  AquaLanguage
//
//  Created by Lê Minh Sơn on 20/6/24.
//

import UIKit
import Reusable
import SkeletonView

class HomeNativeAdsCell: UICollectionViewCell, NibReusable {
    
    @IBOutlet private weak var viewNativeAds: UIView!
    
    func loadAds(nativeAd: NativeAdProtocol?) {
        if nativeAd == nil {
            self.viewNativeAds.isSkeletonable = true
            let gradient = SkeletonGradient(baseColor: UIColor.clouds)
            let animation = SkeletonAnimationBuilder()
                .makeSlidingAnimation(withDirection: .leftRight,
                                      duration: 0.7)
            viewNativeAds.showAnimatedGradientSkeleton(usingGradient: gradient,
                                                      animation: animation)
        } else {
            self.viewNativeAds.hideSkeleton()
            self.addViewAndLoadData(nativeAd: nativeAd)
        }
    }
    
    private func addViewAndLoadData(nativeAd: NativeAdProtocol?) {
        guard
            let nibObjects = Bundle.main.loadNibNamed("CustomMediaNativeAdViewFixedHeight",
                                                      owner: nil,
                                                      options: nil),
            let adNativeProtocol = nibObjects.first as? NativeAdProtocol else {
            return
        }
        if let parent = viewNativeAds {
            parent.subviews.forEach { $0.removeFromSuperview() }
            let adNativeView = adNativeProtocol.getGADView()
            adNativeView.removeFromSuperview()
            adNativeView.translatesAutoresizingMaskIntoConstraints = false
            parent.addSubview(adNativeView)
            NSLayoutConstraint.activate([
                adNativeView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 0),
                adNativeView.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: 0),
                adNativeView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 0),
                adNativeView.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: 0)
            ])
            adNativeView.layoutIfNeeded()
        }
        guard let adNative = nativeAd?.gadNativeAd else { return }
        adNativeProtocol.bindingData(nativeAd: adNative)
    }

}
