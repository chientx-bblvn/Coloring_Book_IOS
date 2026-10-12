//
//  PreviewColoringService.swift
//  Doll-Coloring
//
//  Created by Việt Anh Nguyễn on 10/04/2024.
//  
//

import Foundation
import Moya

enum PreviewColoringService {
    case list
}
extension PreviewColoringService: TargetType {
    
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

class PreviewColoringManager: BaseManager<PreviewColoringService> {}
