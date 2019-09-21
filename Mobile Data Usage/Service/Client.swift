//
//  Client.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Alamofire

class Client {

    static let shared = Client()
    
    func dataList(with parameters: Parameters) -> BBTask {
        return BBTask(urlRequest: Router.dataList(parameters))
    }
    
}
