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
    
    func getCategoryColoring(complection: @escaping () -> Void) {
        SVProgressHUD.show()
        serviceManager.requestAPI(.list, type: [ImageColoring].self) {[weak self] isSuccess, response in
            SVProgressHUD.dismiss()
            self?.categoryColoring = response
            complection()
        } onFailed: { error in
            complection()
            SVProgressHUD.dismiss()
        }
    }
    
    func getImageColorings(complection: @escaping () -> Void) {
        SVProgressHUD.show()
        serviceManager.requestAPI(.list, type: [ImageColoring].self) {[weak self] isSuccess, response in
            SVProgressHUD.dismiss()
            self?.categoryColoring = response
            complection()
        } onFailed: { error in
            complection()
            SVProgressHUD.dismiss()
        }
    }
}

extension HomeVM {

}
