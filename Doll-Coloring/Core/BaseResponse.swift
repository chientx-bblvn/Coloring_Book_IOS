//
//  BaseResponse.swift
//  BBLabs.
//
//  Created by BBLabs on 4/29/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import Foundation

//   "signal": int,
//   "message": "SUCCESS",
//   "code": int // success 200, error 400
//   "data": Any

// swiftlint:disable identifier_name
let REQUEST_SUCCESS = 1
let UNAUTHORIZED = 401
// swiftlint:enable identifier_name
/**
{
     "signal" : 1 (success) otherwise
     "message" : String
     "errorCode" : String
     "code" : xxx (Int)
     "error" : {
        "code": Int?
        "status": String?
        "message": String?
     }
     "pagination" : {
        "currentPage": Int?
        "prevPage": String?
        "nextPage": String?
        "pageSize": Int?
        "totalPage": Int?
        "totalCount": Int?
     }
     "data" : AnyType?
}
 */

struct BaseError: Codable {
    var code: Int?
    var status: String?
    var message: String?
}

class BaseResponse<D>: Codable where D: Codable {
    
    var signal: Int? = 0
    var message: String?
    var errorCode: String?
    var code: Int? = 0
    var error: BaseError?
    var pagination: Pagination?
    var data: D?
}

extension BaseResponse {
    
    func getTitle() -> String {
        return error?.status?.localizedString(tableName: Constants.errorCodeTable, defaultValue: "") ?? ""
    }
    
    func getMessage() -> String {
        return "\(error?.status ?? "")_description".localizedString(tableName: Constants.errorCodeTable, defaultValue: ErrorUtils.default_error())
    }
    
    func isRequestSuccess() -> Bool {
        return error == nil
    }
    
    func isRequestLogin() -> Bool {
        let errCode = (self.errorCode ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if errCode.isEmpty {
            return false
        }
        return listExpireLogin().contains(errCode)
    }
    
    func isNotExistAccount() -> Bool {
        let errCode = (self.errorCode ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if errCode.isEmpty {
            return false
        }
        return listNotExistAccount().contains(errCode)
    }
    
    private func listNotExistAccount() -> [String] {
        return []
    }
    
    func isExistAccount() -> Bool {
        let errCode = (self.errorCode ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if errCode.isEmpty {
            return false
        }
        return listExistAccount().contains(errCode)
    }
    
    private func listExistAccount() -> [String] {
        return []
    }
    
    private func listExpireLogin() -> [String] {
        return [
        ]
    }
}

class BaseModel: BaseResponse<String> {
}

struct APIError: Error {
    var messageId: Int = 0
    var title: String = ""
    var message: String = ""
    var buttonTitle: String?
}

struct Pagination: Codable {
    var currentPage: Int?
    var prevPage: String?
    var nextPage: String?
    var pageSize: Int?
    var totalPage: Int?
    var totalCount: Int?
}
