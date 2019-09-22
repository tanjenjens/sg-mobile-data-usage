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


class ListViewController: UIViewController, ListTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    let cellID = "ListTableViewCell"
    var dataList = [JSON]()
    var selectedIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
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
                self.tableView.reloadData()
            } else {
                if let err = error {
                    GeneralHelper.showAlert(message: err.asErrorMessage(), vc: self)
                }
            }
        }
    }

    // MARK: - ListTableViewCellDelegate
    func didTapCell(_ index: Int) {
        selectedIndex = index
        performSegue(withIdentifier: "DetailViewControllerSegue", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailViewController {
            vc.data = dataList[selectedIndex]
        }
    }
}


extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configureCell(data:dataList[indexPath.row], index:indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

