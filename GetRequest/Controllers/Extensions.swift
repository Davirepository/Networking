//
//  Extensions.swift
//  GetRequest
//
//  Created by Давид on 16/05/2019.
//  Copyright © 2019 Давид. All rights reserved.
//

import UIKit

extension UIView {
    
    // градиент для фона(заливка view при авторизации)
    func addVerticalGradientLayer(topColor:UIColor, bottomColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}


// задание цвета в 16ричном формате
extension UIColor {
    convenience init? (hexValue: String, alpha: CGFloat) {
        if hexValue.hasPrefix("#") {
            let scanner = Scanner(string: hexValue)
            scanner.scanLocation = 1
            
            var hexInt32: UInt32 = 0
            if hexValue.count == 7 {
                if scanner.scanHexInt32(&hexInt32) {
                    let red = CGFloat((hexInt32 & 0xFF0000) >> 16) / 255
                    let green = CGFloat((hexInt32 & 0x00FF00) >> 8) / 255
                    let blue = CGFloat(hexInt32 & 0x0000FF) / 255
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
}
