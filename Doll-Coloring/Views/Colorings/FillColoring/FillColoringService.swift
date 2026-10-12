//
//  FillColoringService.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 22/4/24.
//  
//

import Foundation
import Moya

enum FillColoringService {
    case list
}
extension FillColoringService: TargetType {
    
    public var baseURL: URL {
        return URL(string: newApiBaseURL)!
    }
    
    public var path: String {
        switch self {
        case .list:
            return ""
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
        return [
            "AccessKey": apiAccessKey,
            "Content-type": "application/json"
        ]
    }
}

class FillColoringManager: BaseManager<FillColoringService> {}
