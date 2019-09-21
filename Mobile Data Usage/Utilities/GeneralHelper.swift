//
//  GeneralHelper.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import Alamofire

public class GeneralHelper {
    
    class func isNetworkReachable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    class func constructError(code:Int, msg:String) -> NSError {
        let userInfo = ["message":msg]
        return NSError(domain: AppErrorDomain, code: code, userInfo: userInfo)
    }
    
    class func showAlert(_ title:String = kOops, message:String, vc:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
