//
//  ListTableViewCell.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 22/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit
import SwiftyJSON

@objc protocol ListTableViewCellDelegate {
    func didTapCell(_ index:Int)
}

class ListTableViewCell: UITableViewCell {

    var delegate : ListTableViewCellDelegate?
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var decreaseImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCell(_:)))
        decreaseImageView.addGestureRecognizer(tap)
        decreaseImageView.isHidden = true
    }

    func configureCell(data:JSON, index:Int) {
        
        decreaseImageView.tag = index
        var previousVolume = Double()
        var totalVolume = Double()
        
        if let quarterData = data["data"].array {
            for item in quarterData {
                if let value = item["volume_of_mobile_data"].string, let newVolume = Double(value) {
                    if newVolume < previousVolume {
                        decreaseImageView.isHidden = false
                    }
                    previousVolume = newVolume
                    totalVolume += newVolume
                }
            }
        }
        
        if let year = data["year"].string {
            infoLabel.text = "Year: \(year)\n\nData Consumption: \(String(totalVolume))"
            infoLabel.sizeToFit()
        }
        
    }
   
    @objc func didTapCell (_ sender: UITapGestureRecognizer) {
        delegate?.didTapCell(decreaseImageView.tag)
    }
}
