//
//  UIKitExtension.swift
//  Mobile Data Usage
//
//  Created by Jeniean Las Pobres on 22/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult func customTextWithColor(text: String, size: CGFloat = 14.0, fontName:String, _ color:UIColor = UIColor.black) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: size)!, .foregroundColor:color]
        let string = NSMutableAttributedString(string:text, attributes: attrs)
        append(string)
        return self
    }
}
