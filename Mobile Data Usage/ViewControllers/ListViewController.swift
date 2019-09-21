//
//  ListViewController.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 21/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner


class ListViewController: UIViewController {

    var data = [JSON]()
    var offset: Int = 14
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
  
    fileprivate func loadData() {
    
        var params = Parameters()
        params["limit"] = 10
        params["resource_id"] = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        params["offset"] = offset
        
        SwiftSpinner.show(String())
        Request.getDataList(parameters: params) { (response, error) in
            SwiftSpinner.hide()
            if let success = response?["success"].bool, success {
                print("DATA RESPONSE: \(String(describing: response))")
            } else {
                if let err = error {
                    GeneralHelper.showAlert(message: err.asErrorMessage(), vc: self)
                }
            }
        }
    }

}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
