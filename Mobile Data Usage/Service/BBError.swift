
//
//  BBError.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

struct BBError {
    
    static let domain = "com.personal.Mobile-Data-Usage.ErrorDomain"
    
    struct Code {
        //Generic
        static let unknownError = -7000
        static let emptyResponse = -7001
        static let networkError = -7002
        static let requestTimedOut = -7003
    }
    
    struct Message {
        static let unknownError = kUnknownError
        static let emptyResponse = kEmptyResponse
        static let requestTimedOut = kRequestTimedOut
        static let networkError = kNetworkError
    }
    
}
