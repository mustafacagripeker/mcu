//
//  Extension.swift
//  MCUProject
//
//  Created by Mustafa Çağrı Peker on 15.01.2022.
//

import Foundation
import UIKit

extension UIView{
    func addTapGesture(action : @escaping ()->Void ){
           let tap = MyTapGestureRecognizer(target: self , action: #selector(self.handleTap2(_:)))
           tap.action = action
           tap.numberOfTapsRequired = 1
           
           self.addGestureRecognizer(tap)
           self.isUserInteractionEnabled = true
           
       }
       
       @objc func handleTap2(_ sender: MyTapGestureRecognizer) {
           sender.action!()
       }
       
       class MyTapGestureRecognizer: UITapGestureRecognizer {
           var action : (()->Void)? = nil
       }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIView {
    
    @IBInspectable
    var roundedTopCorners: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    func animateToSenderPostion(_ sender: UIControl) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState , animations: {
            self.frame.origin.x = sender.frame.minX
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addDashedBorder(start p0: CGPoint, end p1: CGPoint, lineColor: UIColor) {
        self.layoutIfNeeded()
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [3, 3]
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderViewColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = shadowRadius
            layer.cornerRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
}
