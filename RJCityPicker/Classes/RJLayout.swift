//
//  RJLayout.swift
//  YiChunSports
//
//  Created by RJ on 2018/10/10.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit

/// 屏幕尺寸
public let kScreenW = CGFloat(UIScreen.main.bounds.width)
public let kScreenH = CGFloat(UIScreen.main.bounds.height)



let kDevice_Is_iPhone4s    = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 960), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhone5     = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 640, height: 1136), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhone6     = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 750, height: 1334), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhone6Plus = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242, height: 2208), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhoneX     = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhoneXS    = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhoneXSMAX = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242, height: 2688), (UIScreen.main.currentMode?.size)!) : false
let kDevice_Is_iPhoneXR    = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 828, height: 1792), (UIScreen.main.currentMode?.size)!) : false




/// 刘海屏
let isBangScreen = (kDevice_Is_iPhoneX || kDevice_Is_iPhoneXS || kDevice_Is_iPhoneXSMAX || kDevice_Is_iPhoneXR)

let kNavBarHeight :CGFloat = UINavigationController().navigationBar.bounds.height + UIApplication.shared.statusBarFrame.height
let kStaBarHeight :CGFloat = UIApplication.shared.statusBarFrame.height
let kTabBarHeight :CGFloat = UITabBarController().tabBar.bounds.height
let kTrailHeight  :CGFloat = isBangScreen ? 34 : 0
/// 纯代码适配等比例拉伸(以iPhone6为标准)
let kSCREEN_WIDTH_RATIO  = kScreenW / 375.0
let kSCREEN_HEIGHT_RATIO = isBangScreen ? (kScreenH - 78)/667.0 : (kScreenH < 500 ? 1 : kScreenH / 667.0) //5/5s一下不做适配


///全部等比 等屏幕

/// 自动适配宽度
///
/// - Parameter width: 基础宽度 以iPhone6为基础
/// - Returns: 适配后的宽度
public func kAutoWid(_ width:CGFloat) -> CGFloat {
    return width * kSCREEN_WIDTH_RATIO
}
/// 自动适配高度
///
/// - Parameter height: 基础高度 以iPhone6为基础
/// - Returns: 适配后的高度
public func kAutoHei(_ height:CGFloat) -> CGFloat {
    return height * kSCREEN_HEIGHT_RATIO
}


@IBDesignable
extension NSLayoutConstraint {
    @IBInspectable var adapterScreen :Bool  {
        set{
//            switch firstAttribute {
//            case .left,.right,.leading,.trailing,.width,.leftMargin,.rightMargin,.leadingMargin,.trailingMargin,.centerX,.centerXWithinMargins:
//                constant = constant * kSCREEN_WIDTH_RATIO
//            default:
//                 constant = constant * kSCREEN_HEIGHT_RATIO
//            }
            constant = constant * kSCREEN_WIDTH_RATIO
        }
        get{
            return true
        }
    }
    
}


public extension UIView{
    /// x坐标
    public var x : CGFloat{
        get{
            return frame.origin.x
        }
        set(x){
            frame.origin = CGPoint(x: x, y: frame.origin.y)
        }
    }
    
    /// Y坐标
    public var y : CGFloat{
        get{
            return frame.origin.y
        }
        set(y){
            frame.origin = CGPoint(x: frame.origin.x, y: y)
        }
    }
    
    /// 宽
    public var width : CGFloat{
        get{
            return frame.size.width
        }
        set(width){
            frame.size = CGSize(width: width, height: frame.size.height)
        }
    }
    
    /// 高
    public var height : CGFloat{
        get{
            return frame.size.height
        }
        set(height){
            frame.size = CGSize(width: frame.size.width, height: height)
        }
    }
    
    /// 尺寸
    public var size   : CGSize {
        get{
            return frame.size
        }
        set(size){
            frame.size = size
        }
    }
    
    /// 坐标
    public var origin   : CGPoint {
        get{
            return frame.origin
        }
        set(origin){
            frame.origin = origin
        }
    }
    
    /// 中心点 X坐标
    public var centerX   : CGFloat {
        get{
            return self.center.x
        }
        set(centerX){
            self.center.x = centerX
        }
    }
    
    /// 中心点 Y坐标
    public var centerY   : CGFloat {
        get{
            return self.center.y
        }
        set(centerY){
            self.center.y = centerY
            
        }
        
    }
}
