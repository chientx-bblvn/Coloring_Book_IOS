//
//  HomeService.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 08/04/2024.
//  
//

import Foundation
import Moya

enum HomeService {
    case list
}
extension HomeService: TargetType {
    
    public var baseURL: URL {
        return URL(string: apiBaseUrl)!
    }
    
    public var path: String {
        switch self {
        case .list:
            return "/data_dollcoloring/doll_v4.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var task: Task {
        switch self {
            
        case .list:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var headers: [String: String]? {
        switch self {
        case .list:
            return [
                "Content-type": "application/json"
            ]
        }
    }
}

class HomeManager: BaseManager<HomeService> {}
