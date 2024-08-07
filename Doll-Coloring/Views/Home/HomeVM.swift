//
//  HomeVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import RxSwift
import UIKit
import SVProgressHUD

class HomeVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = HomeManager()
    
    var colorings: [ColoringModel] = []
    
    var itemColoring: [ColoringImage] = []
    var categoryColoring: [ImageColoring] = []
    var itemDaly: [ColoringImage] = []
    
    init() {
    }
    
    func getColorings(complection: @escaping () -> Void) {
        SVProgressHUD.show()
        serviceManager.requestAPI(.list, type: [ColoringModel].self) {[weak self] isSuccess, response in
            SVProgressHUD.dismiss()
            self?.colorings = response
            self?.itemColoring = response.first?.imageUrls ?? []
            complection()
        } onFailed: { error in
            complection()
            SVProgressHUD.dismiss()
        }
    }
    
    func getNewColorings(complection: @escaping () -> Void) {
        SVProgressHUD.show()
        serviceManager.requestAPI(.newList, type: [ColoringModel].self) {[weak self] isSuccess, response in
            SVProgressHUD.dismiss()
            self?.colorings = response
            self?.itemColoring = response.first?.imageUrls ?? []
            self?.itemDaly = response.first(where: {$0.categoryName?.contains("Daily") ?? false})?.imageUrls ?? []
            complection()
        } onFailed: { error in
            complection()
            SVProgressHUD.dismiss()
        }
    }
    
    
}

extension HomeVM {

}
