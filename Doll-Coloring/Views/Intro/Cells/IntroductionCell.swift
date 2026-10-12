//
//  IntroductionCell.swift
//  Doll-Coloring
//
//  Created by BBLabs on 13/08/2023.
//

import UIKit
import Reusable

class IntroductionCell: FSPagerViewCell, NibReusable {
    
    @IBOutlet private weak var imageviewIntro: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbSubTitle: UILabel!
    @IBOutlet weak var indicatorImg: UIImageView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgInside: UIImageView!
    
    @IBOutlet weak var btnNext2: UIButton!
    
    var onNext: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnNext2.customGenerateOuterShadow(shadowOpacity: 0.25, shadowRadius: 6, color: UIColor(hexString: "C13F68").withAlphaComponent(0.35), shadowOffset: CGSize(width: 0, height: 2))
    }
    
    func loadData(intro: IntroModel) {
        switch intro.id {
        case 0:
            changeButtonNext(LocalizableUtils.commonNext())
            viewAds?.isHidden = true
            self.btnNext.isHidden = false
            self.btnNext2.isHidden = true
        case 1:
            changeButtonNext(LocalizableUtils.commonNext())
            viewAds?.isHidden = true
            self.btnNext.isHidden = true
            self.btnNext2.isHidden = false
            self.indicatorImg.isHidden = true
        case 2:
            changeButtonNext(LocalizableUtils.commonStart())
            viewAds?.isHidden = true
            self.btnNext.isHidden = false
            self.btnNext2.isHidden = true
        default:
            break
        }
        // Keep the illustration as the focal image and use the blush surface behind it.
        imageviewIntro.image = nil
        imageviewIntro.backgroundColor = UIColor(hexString: "FFF1F5")
        lbTitle.text = intro.name
        lbSubTitle.text = intro.desc
        lbTitle.textColor = UIColor(hexString: "5B5056")
        lbSubTitle.textColor = UIColor(hexString: "756A70")

        imgInside.image = intro.image
        imgInside.contentMode = .scaleAspectFill
        imgInside.layer.cornerRadius = 18
        imgInside.clipsToBounds = true
        indicatorImg.image = intro.indicator

        let actionPink = UIColor(hexString: "FF5D8F")
        btnNext.backgroundColor = actionPink
        btnNext2.backgroundColor = actionPink
        btnNext.setTitleColor(.white, for: .normal)
        btnNext2.setTitleColor(.white, for: .normal)
    }
    
    func changeButtonNext(_ title: String) {
        self.btnNext.setTitle(title, for: .normal)
        self.btnNext2.setTitle(title, for: .normal)
    }
    
    @IBAction func buttonNextOnTouch(_ sender: UIButton) {
        onNext?()
    }
}
