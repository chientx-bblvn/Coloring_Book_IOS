//
//  HomeVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import RxSwift
import UIKit

class HomeVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = HomeManager()
    
    init() {
    }

    func requestAPI(callback apiCallback: @escaping (HomeModel?) -> Void) {
        serviceManager.provider.request(HomeService.list) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try JSONDecoder().decode(HomeModel.self, from: moyaResponse.data)
                    apiCallback(response)
                } catch {
                    apiCallback(nil)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension HomeVM {

}
