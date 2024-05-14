//
//  HistoryColoringVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import RxSwift
import UIKit

class HistoryColoringVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = HistoryColoringManager()
    var coloring: ColoringHistoryModel
    var coloringAPI: ColoringImage
    var typeScreen: BackToScreenType
    init(coloring: ColoringHistoryModel, typeScreen: BackToScreenType, coloringAPI: ColoringImage) {
        self.coloring = coloring
        self.typeScreen = typeScreen
        self.coloringAPI = coloringAPI
    }
}

extension HistoryColoringVM {

}
