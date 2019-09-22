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

    var dataList = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
  
    fileprivate func loadData() {
    
        var params = Parameters()
        params["offset"] = 14 // 2008
        params["limit"] = 44 // 2018
        params["resource_id"] = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
        
        SwiftSpinner.show(String())
        Request.getDataList(parameters: params) { (response, error) in
            SwiftSpinner.hide()
            if let success = response?["success"].bool, success {
                
                guard let result = response?["result"].dictionary,
                    let records = result["records"]?.array else {
                    return
                }
                var yearName = String()
                var yearData = SwiftDictionary()
                var quarterData = [JSON]()
                
                for (_,item) in records.enumerated() {
                    if let quarter = item["quarter"].string {
                        if quarter.prefix(4) == yearName || yearName.isEmpty {
                            yearName = String(quarter.prefix(4))
                            quarterData.append(item)
                            yearData["year"] = yearName
                            yearData["data"] = quarterData
                        } else {
                            quarterData.removeAll()
                            yearName = String(quarter.prefix(4))
                            quarterData.append(item)
                        }
                    }
                    if quarterData.count == 4 {
                        self.dataList.append(JSON(yearData))
                    }
                }
                print("DATA LIST: \(self.dataList)")
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
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
