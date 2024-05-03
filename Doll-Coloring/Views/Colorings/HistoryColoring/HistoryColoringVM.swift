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
    init(coloring: ColoringHistoryModel) {
        self.coloring = coloring
    }
}

extension HistoryColoringVM {

}
