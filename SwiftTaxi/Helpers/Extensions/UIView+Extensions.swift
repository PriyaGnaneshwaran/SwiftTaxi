//
//  TextField.swift
//  SwiftTaxi
//
//  Created by Priya Gnaneshwaran on 18/04/25.
//

import Foundation
import UIKit

extension UIView {
    
    var width:  CGFloat { return self.frame.size.width }
    var height: CGFloat { return self.frame.size.height }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        } set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.init(cgColor: layer.borderColor!)
        } set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
}
