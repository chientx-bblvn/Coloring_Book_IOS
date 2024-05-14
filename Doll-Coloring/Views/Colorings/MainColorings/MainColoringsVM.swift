//
//  MainColoringsVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import RxSwift
import UIKit
import SVProgressHUD

class MainColoringsVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = MainColoringsManager()
    
    var colorings: [ColoringModel] = []
    
    init() {
    }
    
    func getColorings(complection: @escaping () -> Void) {
        SVProgressHUD.show()
        serviceManager.requestAPI(.list, type: [ColoringModel].self) {[weak self] isSuccess, response in
            SVProgressHUD.dismiss()
            var data = response
            data.removeFirst()
            self?.colorings = data
            complection()
        } onFailed: { error in
            complection()
            SVProgressHUD.dismiss()
        }

    }

}

extension MainColoringsVM {

}
