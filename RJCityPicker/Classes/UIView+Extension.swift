//
//  UIView+Extension.swift
//  YiChunSports
//
//  Created by RJ on 2018/10/17.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit

extension UIView {
    /// 设置部分圆角(绝对布局)
    ///
    /// - Parameters:
    ///   - corners: 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
    ///   - radii: 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
    public func addRoundedCorners(_ corners:UIRectCorner , radii:CGSize) -> Void {
        let runded = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radii)
        let  shape = CAShapeLayer()
        shape.path = runded.cgPath
        layer.mask = shape
    }
    /// 设置部分圆角(相对布局)
    ///
    /// - Parameters:
    ///   - corners: 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
    ///   - radii: 需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
    public func addRoundedCorners(_ corners:UIRectCorner , radii:CGSize,viewRect:CGRect) -> Void {
        let runded = UIBezierPath.init(roundedRect: viewRect, byRoundingCorners: corners, cornerRadii: radii)
        let  shape = CAShapeLayer()
        shape.path = runded.cgPath
        layer.mask = shape
    }
    /// 获取view 所在的控制器
    public var viewController: UIViewController? {
        get{
            var nextResponder: UIResponder? = self
            
            repeat {
                nextResponder = nextResponder?.next
                
                if let viewController = nextResponder as? UIViewController {
                    return viewController
                }
                
            } while nextResponder != nil
            
            return nil
        }
    }
    
}
extension Bundle{
    static var current :Bundle?{
        let bundle = Bundle(for: RJCityPickerViewController.self)
        if let path = bundle.path(forResource: "RJCityPicker", ofType: "bundle") {
            return Bundle(path: path)
        } else {
            return nil
        }
    }
}
