//
//  Service.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum Task {
    case dataList(Parameters)
}

public typealias SwiftDictionary = [String:Any]
typealias SuccessBlock = (_ response: Any) -> Void
typealias FailureBlock = (_ error: NSError) -> Void
typealias CompletionBlock = (_ response: JSON?, _ error: NSError?) -> Void


class Service {
    
    static let sessionManager = SessionManager()
    static var alertDisplayed = false

    @discardableResult
    final class func performRequest(with url: URLRequestConvertible,
                                    authenticate: Bool = true,
                                    completion: @escaping (_ response: JSON?, _ error: NSError?) -> Void) -> URLRequest? {

        
        return sessionManager.request(url).responseJSON(completionHandler: { (response) in

            if let error = response.error {
                completion(nil, error.localizedDescription.asError())
                return
            }
            
            guard let response = response.result.value else {
                completion(nil, BBError.Message.unknownError.asError())
                return
            }
            
            let responseJSON = JSON(response)
            if let error = mapError(from: responseJSON) {
                completion(nil, error)
            } else {
                let results = responseJSON
                if results != JSON.null {
                    completion(results, nil)
                } else {
                    completion(nil, BBError.Message.emptyResponse.asError())
                }
            }
        }).request
    }
    
    //MARK: - Error Mapping
    fileprivate class func mapError(from response: JSON) -> NSError? {
        let errorInfo = response["error"]
        return errorInfo != JSON.null ? errorInfo.asError() : nil
    }
}

extension Service {
    
    class func perform(task: Task, isTokenRequired: Bool = true, completion: @escaping CompletionBlock) {
        self.invoke(task: task, completion: completion)
    }
    
    private class func invoke(task: Task, completion: @escaping CompletionBlock) {
        let bbTask: BBTask = {
        
            switch task {
            case let .dataList(parameters):
                return Client.shared.dataList(with: parameters)
            }
            
        }()
        
        bbTask.perform({ (response) in
            let responseJSON = JSON(response)
            if let error = mapError(from: responseJSON) {
                completion(nil, error)
            } else {
                let results = responseJSON
                if results != JSON.null {
                    completion(results, nil)
                } else {
                    let error = BBError.Message.emptyResponse.asError()
                    completion(nil, error)
                }
            }
        }) { (error) in
            completion(nil, error)
        }
    }
}

//MARK: - JSON Extension
extension JSON {
    func asError() -> NSError {
        var errorCode = BBError.Code.unknownError
        if let code = self["code"].int {
            errorCode = code
        }
        
        var errorDescription = BBError.Message.unknownError
        if let message = self["message"].string {
            errorDescription = message
        }
        
        var errorReason = errorDescription
        if let message = self["message"]["fault"]["detail"]["errorMessage"].string {
            errorReason = message
        }
        
        return NSError(domain: BBError.domain,
                       code: errorCode,
                       userInfo: [NSLocalizedDescriptionKey: errorDescription,
                                  NSLocalizedFailureReasonErrorKey: errorReason])
    }
}

// MARK: - String Extension
extension String {
    func asErrorCode() -> Int {
        switch self {
        case BBError.Message.emptyResponse:
            return BBError.Code.emptyResponse
        case BBError.Message.requestTimedOut:
            return BBError.Code.requestTimedOut
        case BBError.Message.networkError:
            return BBError.Code.networkError
        default:
            return BBError.Code.unknownError
        }
    }
    
    func asError() -> NSError {
        return NSError(domain: BBError.domain,
                       code: self.asErrorCode(),
                       userInfo: [NSLocalizedDescriptionKey: self])
    }
}

// MARK: - Error Extension
extension NSError {
    func asErrorMessage() -> String {
        switch self.code {
        case BBError.Code.requestTimedOut:
            return kRequestTimedOut
        case BBError.Code.networkError:
            return kNetworkError
        default:
            return kUnknownErrorTryAgain
        }
    }
}
