//
//  Request.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Alamofire

class Request: Service {
    
    class func getDataList(parameters: Parameters, completion: @escaping CompletionBlock) {
        perform(task: .dataList(parameters)) { (response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                completion(response,nil)
            }
        }
    }
    
}
