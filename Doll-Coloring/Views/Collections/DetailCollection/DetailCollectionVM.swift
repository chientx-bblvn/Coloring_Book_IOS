//
//  DetailCollectionVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 6/5/24.
//  
//

import RxSwift
import UIKit

class DetailCollectionVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = DetailCollectionManager()
    
    var coloringLocal: ColoringHistoryModel
    var history: HistoryModel?
    var isCollection: Bool
    
    init(coloringLocal: ColoringHistoryModel, history: HistoryModel, isCollection: Bool) {
        self.coloringLocal = coloringLocal
        self.history = history
        self.isCollection = isCollection
    }
}

extension DetailCollectionVM {

}
