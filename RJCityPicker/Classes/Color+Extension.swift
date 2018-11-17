//
//  Color+Extension.swift
//  YiChunSports
//
//  Created by RJ on 2018/10/10.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit

//let tableViewBackgroundColor =
public extension UIColor{
    static var tableViewBackgroundColor = UIColor(0xf8f8f8)
    convenience public init(_ hex:NSInteger , _ alpha:CGFloat){
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat((hex & 0xFF) ) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    convenience public init(_ hex:NSInteger){
        self.init(hex, 1)
    }
}
