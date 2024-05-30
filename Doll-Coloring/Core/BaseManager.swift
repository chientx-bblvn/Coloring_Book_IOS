//
//  ServiceManager.swift
//  BBLabs
//
//  Created by BBLabs.
//  Copyright ©2024 BBLabs. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import RxCocoa
import RxSwift

/**
 Public protocol that defines the minimum API that a ServiceManager should expose.
 
 The ServiceManager is the component in charge of handling al network request for
 an specific TargetType.
 
 Basic behaviour implemented using RxSwift is provided by the BaseManager class.
 */
public protocol ServiceManager {
    /// The associated TargetType of the Manager.
    associatedtype ProviderType: TargetType
    /// The MoyaProvider instance used to make the network requests.
    var provider: MoyaProvider<ProviderType> { get }
    /// The JSON decoding strategy used for JSON Responses.
    var jsonDecoder: JSONDecoder { get }
}

/**
 Base Manager class that implements generic behaviour to
 be extendended and used by subclassing it.
 
 The base manager has an associated TargetType, this means
 that you should have **one and only one** manager for each TargetType.
 
 This base implementation provides helpers to make requests using RxSwift
 with automatic encoding if you provide a propper model as the expected result type.
 */
open class BaseManager<T>: ServiceManager where T: TargetType {
    public typealias ProviderType = T
    
    private var sharedProvider: MoyaProvider<T>!
    
    public required init() {}
    
    /**
     Default provider implementation as a singleton. It provides networking
     loggin out of the box and you can override it if you want to add more middleware.
     */
    open var provider: MoyaProvider<T> {
        guard let provider = sharedProvider else {
#if canImport(netfox)
            self.sharedProvider = MoyaProvider<T>(
//                requestClosure: { endpoint, closure in
//                    if var request = try? endpoint.urlRequest() { // Feel free to embed proper error handling
//                        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
//                        closure(.success(request))
//                    }
//                },
                plugins: [
                    NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { (_, array) in
                        if let log = array.first {
                            debugPrint(log)
                        }
                    }, logOptions: .formatRequestAscURL)),
                    CachePolicyPlugin()
                ]
            )
#else
            self.sharedProvider = MoyaProvider<T>(
                plugins: [
                    NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { (_, array) in
                        if let log = array.first {
                            debugPrint(log)
                        }
                    }, logOptions: .formatRequestAscURL))
                ]
            )
#endif
            return sharedProvider
        }
        return provider
    }
    
    /**
     Default JSON decoder setup, uses the most common case of keyDecoding,
     converting from camel_case to snakeCase before attempting to match
     override this var if you need to customize your JSON decoder.
     */
    open var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
    
    /**
     Makes a request to the provided target and tries to decode its response
     using the provided keyPath and return type and returning it as an Observable.
     - Parameters:
     - target: The TargetType used to make the request.
     - keyPath: The keypath used to decode from JSON (if passed nil, it will try to decode from the root).
     */
    @discardableResult
    open func request(_ target: T,
                      callbackQueue: DispatchQueue? = .none,
                      progress: ProgressBlock? = .none,
                      completion: @escaping Completion) -> Cancellable? {
        if !isNetworkConnected() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                completion(.failure(MoyaError.objectMapping(APIError(messageId: 500,
                                                                     title: ErrorUtils.default_error(),
                                                                     message: ErrorUtils.err_NO_INTERNET(),
                                                                     buttonTitle: LocalizableUtils.commonOK()),
                                                            Response(statusCode: 500, data: Data())) ))
            })
            return nil
        }
        return provider.request(target, callbackQueue: callbackQueue, progress: progress, completion: completion)
    }
    
    /**
     Makes a request to the provided target and tries to decode its response
     using the provided keyPath and return type and returning it as an Observable.
     - Parameters:
     - target: The TargetType used to make the request.
     - keyPath: The keypath used to decode from JSON (if passed nil, it will try to decode from the root).
     */
    open func request<T>(_ target: ProviderType, 
                         at keyPath: String? = nil,
                         filter: Bool = false) -> Observable<T> where T: Codable {
        if !isNetworkConnected() {
            return Observable.error(APIError(messageId: 500,
                                             title: ErrorUtils.default_error(),
                                             message: ErrorUtils.err_NO_INTERNET(),
                                             buttonTitle: LocalizableUtils.commonOK()))
        }
        if !filter {
            return provider.rx.request(target)
                .map(T.self, atKeyPath: keyPath, using: jsonDecoder)
                .asObservable()
        }
        return provider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .map(T.self, atKeyPath: keyPath, using: jsonDecoder)
            .asObservable()
    }
    
    /// Helper to use as middleware to pretty print the JSON response.
    private func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    }
    
    func requestAPIAF<RMD>(_ target: T,
                           type: RMD.Type,
                           onSuccess: @escaping ((_ isSuccess: Bool, _ response: RMD) -> Void),
                           onFailed: @escaping ((_ error: Error) -> Void)) where RMD: Codable {
        var parameterVal: [String: Any] = [:]
        var encodingVal: ParameterEncoding = URLEncoding.default
        switch target.task {
        case let .requestParameters(parameters, encoding):
            parameterVal = parameters
            encodingVal = encoding
        default: break
        }
        if let url = URL(string: "\(target.baseURL.absoluteString)\(target.path)") {
            AF.request(url,
                       method: target.method,
                       parameters: parameterVal,
                       encoding: encodingVal,
                       headers: HTTPHeaders(target.headers ?? [:]))
            .responseDecodable(of: type, completionHandler: { [weak self] dataResponse in
                guard let `self` = self else { return }
                let isSuccess = self.isSuccess(statusCode: dataResponse.response?.statusCode)
                if let result = dataResponse.value {
                    onSuccess(isSuccess, result)
                } else {
                    if let err = dataResponse.error {
                        print("\(#function) - \(err)")
                        onFailed(err)
                    }
                }
            })
        }
    }
    
    @discardableResult
    func requestAPI<RMD>(_ target: T,
                         type: RMD.Type,
                         onSuccess: @escaping ((_ isSuccess: Bool, _ response: RMD) -> Void),
                         onFailed: @escaping ((_ error: Error) -> Void)) -> Cancellable? where RMD: Codable {
        return request(target) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case let .success(moyaResponse):
//                print("Data request: \n\((try? moyaResponse.mapString()) ?? "")")
                if moyaResponse.statusCode >= 500 {
                    onFailed(APIError(messageId: moyaResponse.statusCode, title: ErrorUtils.default_error(),
                                      message: ErrorUtils.err_NO_INTERNET(),
                                      buttonTitle: LocalizableUtils.commonOK()))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(type, from: moyaResponse.data)
                    let isSuccess = self.isSuccess(statusCode: moyaResponse.statusCode)
                    onSuccess(isSuccess, result)
                } catch let err {
                    print("\(#function) - \(err)")
                    onFailed(err)
                }
            case let .failure(error):
                print(error)
                onFailed(error)
            }
        }
    }
    
    @discardableResult
    func requestAPI(_ target: T,
                    onSuccess: @escaping ((_ isSuccess: Bool) -> Void),
                    onFailed: @escaping ((_ error: Error) -> Void)) -> Cancellable? {
        return request(target) { [weak self] response in
            guard let `self` = self else { return }
            switch response {
            case let .success(moyaResponse):
                let isSuccess = self.isSuccess(statusCode: moyaResponse.statusCode)
                onSuccess(isSuccess)
            case let .failure(error):
                print(error)
                onFailed(error)
            }
        }
    }
    
    func requestAPI<RMD>(_ target: T,
                         type: RMD.Type) -> Observable<RMD> where RMD: Codable {
        return request(target)
    }
    
    private func isSuccess(statusCode: Int?) -> Bool {
        guard let code = statusCode else {
            return false
        }
        return code / 100 == 2
    }
    
}
