//
//  PreviewColoringVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import RxSwift
import UIKit

class PreviewColoringVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = PreviewColoringManager()
    
    var coloring: ColoringImage?
    var coloringLocal: ColoringHistoryModel?
    var history: HistoryModel?
    var isCollection: Bool
    
    init(coloring: ColoringImage?, coloringLocal: ColoringHistoryModel?, history: HistoryModel?, isCollection: Bool) {
        self.coloring = coloring
        self.coloringLocal = coloringLocal
        self.history = history
        self.isCollection = isCollection
    }

}

extension PreviewColoringVM {

}
