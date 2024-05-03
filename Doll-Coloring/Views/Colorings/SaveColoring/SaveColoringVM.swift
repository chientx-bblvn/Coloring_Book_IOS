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
    var isCollection: Bool
    var imageColoring: UIImage
    
    init(imageColoring: UIImage, coloringLocal: ColoringHistoryModel, history: HistoryModel?, isCollection: Bool) {
        self.coloringLocal = coloringLocal
        self.history = history
        self.isCollection = isCollection
        self.imageColoring = imageColoring
    }
}

extension SaveColoringVM {

}
