//
//  DetailColoringVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 7/5/24.
//  
//

import RxSwift
import UIKit

class DetailColoringVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = DetailColoringManager()
    var coloring: ColoringModel
    init(coloring: ColoringModel) {
        self.coloring = coloring
    }
}

extension DetailColoringVM {

}
