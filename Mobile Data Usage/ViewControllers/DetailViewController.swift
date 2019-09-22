//
//  DetailViewController.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 22/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    var data = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataDisplay()
    }
    
    func setDataDisplay() {
        
        if let year = data["year"].string {
            navigationItem.title = year
        }
        
        let formattedString = NSMutableAttributedString()
        var previousVolume = Double()
        
        if let quarterData = data["data"].array {
            for item in quarterData {
                if let quarter = item["quarter"].string,
                    let value = item["volume_of_mobile_data"].string,
                    let newVolume = Double(value) {
                    
                    let valueText = previousVolume == 0 ? "\(quarter): \(String(newVolume))" : "\n\n\(quarter): \(String(newVolume))"
                    if newVolume < previousVolume {
                        formattedString
                            .customTextWithColor(text: valueText , size: 18.0, fontName: "Helvetica",  .red)
                    } else {
                        formattedString
                            .customTextWithColor(text: valueText , size: 18.0, fontName: "Helvetica",  .black)
                    }
                    previousVolume = newVolume
                }
            }
        }
        
        dataLabel.attributedText = formattedString
        dataLabel.textAlignment = .left
    }
}
