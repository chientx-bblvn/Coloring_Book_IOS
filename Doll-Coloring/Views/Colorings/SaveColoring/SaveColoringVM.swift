//
//  SaveColoringVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import RxSwift
import UIKit

class SaveColoringVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = SaveColoringManager()
    var coloringLocal: ColoringHistoryModel
    var history: HistoryModel?
    var typeScreen: BackToScreenType
    var imageColoring: UIImage
    
    init(imageColoring: UIImage, coloringLocal: ColoringHistoryModel, history: HistoryModel?, typeScreen: BackToScreenType) {
        self.coloringLocal = coloringLocal
        self.history = history
        self.typeScreen = typeScreen
        self.imageColoring = imageColoring
    }
}

extension SaveColoringVM {

}
