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
    case category
    case detailCategory(path: String)
    case newList
}
extension HomeService: TargetType {
    
    public var baseURL: URL {
        switch self {
        case .list:
            return URL(string: apiBaseUrl)!
        case .category:
            return URL(string: newApiBaseURL)!
        case .detailCategory:
            return URL(string: baseURLImage)!
        case .newList:
            return URL(string: newApiBaseURL)!
        }
        
    }
    
    public var path: String {
        switch self {
        case .list:
            return "/data_dollcoloring/doll_v4.json"
        case .category:
            return ""
        case let .detailCategory(path):
            return "\(path)/"
        case .newList:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .list:
            return .get
        case .category:
            return .get
        case .detailCategory:
            return .get
        case .newList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
            
        case .list:
            return .requestPlain
        case .category:
            return .requestPlain
        case .detailCategory:
            return .requestPlain
        case .newList:
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
        case .category, .detailCategory, .newList:
            return [
                "AccessKey": apiAccessKey,
                "Content-type": "application/json"
            ]
        }
    }
}

class HomeManager: BaseManager<HomeService> {}
