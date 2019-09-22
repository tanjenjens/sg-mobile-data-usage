//
//  Router.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Alamofire
import SwiftyJSON

enum Router {

    case dataList(Parameters)
    
    struct Endpoint {
        static let dataList = "/api/action/datastore_search"
    }
    
    var method: HTTPMethod {
        return .get
    }
}

extension Router: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        
        let result: (path: String, parameters: Parameters?) = {
            switch self {
            case let .dataList(parameters):
                return (Router.Endpoint.dataList, parameters)
            }
        }()
        
        let url = BASE_URL + "\(result.path)"
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 60
        return try URLEncoding.default.encode(urlRequest, with: result.parameters)
    }
    
}
