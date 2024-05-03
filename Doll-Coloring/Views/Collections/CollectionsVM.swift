//
//  CollectionsVM.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import RxSwift
import UIKit

class CollectionsVM {
    private var disposeBag = DisposeBag()
    private let serviceManager = CollectionsManager()
    
    init() {
    }

    func requestAPI(callback apiCallback: @escaping (CollectionsModel?) -> Void) {
        serviceManager.provider.request(CollectionsService.list) { result in
            switch result {
            case let .success(moyaResponse):
                do {
                    let response = try JSONDecoder().decode(CollectionsModel.self, from: moyaResponse.data)
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

extension CollectionsVM {

}
