//
//  FillColoringVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 22/4/24.
//  
//

import RxSwift
import UIKit

class FillColoringVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = StartColoringManager()
    var coloringLocal: ColoringLocalModel
    var coloringImage: String
    init(coloringLocal: ColoringLocalModel, coloringImage: String) {
        self.coloringLocal = coloringLocal
        self.coloringImage = coloringImage
    }
}

extension FillColoringVM {

}
