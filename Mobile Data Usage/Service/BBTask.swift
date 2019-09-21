//
//  BBTask.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Alamofire
import SwiftyJSON

class BBTask {
    
    private(set) var shouldShowError: Bool!
    private(set) var urlRequest: URLRequestConvertible!
    private static let sessionManager = SessionManager()
    
    convenience init(urlRequest: URLRequestConvertible, shouldShowError: Bool = true) {
        self.init()
        self.urlRequest = urlRequest
        self.shouldShowError = shouldShowError
    }
    
    @discardableResult
    final func perform(_ success: @escaping SuccessBlock, failure: @escaping FailureBlock) -> URLRequest? {
        return BBTask.sessionManager.request(urlRequest).responseJSON(completionHandler: { (response) in
            
            if let error = response.error {
                failure(self.makeError(with: error.localizedDescription))
                return
            }
            
            if let response = response.result.value {
                success(response)
            } else {
                failure(self.makeError(with: BBError.Message.unknownError))
            }
        }).request
    }
    
    //MARK: - Error Mapping
    private func mapError(from response: JSON) -> NSError? {
        if let reason = response["error"].string {
            return makeError(with: reason)
        }
        return nil
    }
    
    private func makeError(with reason: String? = nil) -> NSError {
        
        var code = BBError.Code.unknownError
        let reason = reason ?? BBError.Message.unknownError
        
        switch reason {
        case BBError.Message.emptyResponse:
            code = BBError.Code.emptyResponse
        case BBError.Message.requestTimedOut:
            code = BBError.Code.requestTimedOut
        case BBError.Message.networkError:
            code = BBError.Code.networkError
        default:
            code = BBError.Code.unknownError
        }
        
        return NSError(domain: BBError.domain,
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: reason])
    }
    
}
