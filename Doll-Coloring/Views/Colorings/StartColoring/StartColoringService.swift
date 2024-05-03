//
//  StartColoringService.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import Moya

enum StartColoringService {
    case list
}
extension StartColoringService: TargetType {
    
    public var baseURL: URL {
        return URL(string: apiBaseUrl)!
    }
    
    public var path: String {
        switch self {
        case .list:
            return "/list"
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

class StartColoringManager: BaseManager<StartColoringService> {}
