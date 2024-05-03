//
//  StartColoringVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import RxSwift
import UIKit

class StartColoringVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = StartColoringManager()
    var coloringLocal: ColoringHistoryModel
    var history: HistoryModel?
    var isCollection: Bool
    init(coloringLocal: ColoringHistoryModel, history: HistoryModel?, isCollection: Bool) {
        self.coloringLocal = coloringLocal
        self.history = history
        self.isCollection = isCollection
    }
}

extension StartColoringVM {

}
