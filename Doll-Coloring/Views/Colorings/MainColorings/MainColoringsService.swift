//
//  MainColoringsService.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import Moya

enum MainColoringsService {
    case list
}
extension MainColoringsService: TargetType {
    
    public var baseURL: URL {
        return URL(string: apiBaseUrl)!
    }
    
    public var path: String {
        switch self {
        case .list:
            return "/doll-coloring/doll.json"
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

class MainColoringsManager: BaseManager<MainColoringsService> {}
