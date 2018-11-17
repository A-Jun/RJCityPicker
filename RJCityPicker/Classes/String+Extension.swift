//
//  String+Extension.swift
//  citypick
//
//  Created by RJ on 2018/11/15.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit
import Pinyin4Swift
public extension String {
    
    /// 字符串是否为包含中文
    public var hasChinese:Bool
    {
        get
        {
            for index in 0 ..< self.count
            {
                let char = (self as NSString).character(at: index)
                return (char > 0x4300 && char < 0x9fff) ? true : false
            }
            return false
        }
    }
    /// 汉字转拼音
    public var pinYin:String
    {
        get
        {   //  不包含中文
            if !self.hasChinese {
                return self
            }
            let pinyin = PinyinHelper.getPinyinStringWithString(self, outputFormat: OutputFormat.init(vCharType: .uUnicode, caseType: .lower, toneType: .noTone))
            return pinyin
        }
    }
}
public extension Array where Array.Element == String  {
    /// 根据首字母分类数组
    ///
    /// - Parameter array: 字符串数组
    /// - Returns: 返回数组字典 dictionry["initials"]:首字母 dictionry["array"]:数组
    public func sortByInitials() -> [([String:Any])]
    {
        //分类后的数组字典
        var newArray = [([String:Any])]()
        
        for index in 0..<self.count
        {   let st = self[index].pinYin
            let initials = String(st.prefix(1)).uppercased()
            
            var dictionry = [String:Any]()
            
            var isSoted = false
            for row in 0..<newArray.count
            {
                var dict = newArray[row]
                guard let initialsValue = dict["initials"] as? String else {continue}
                if initialsValue == initials
                {
                    guard var arrayValue = dict["array"] as? [String] else {continue}
                    arrayValue.append(self[index])
                    dict["array"] = arrayValue
                    newArray[row] = dict
                    isSoted = true
                    break
                }
            }
            if !isSoted{
                dictionry["initials"] = initials
                dictionry["array"]    = [self[index]]
                newArray.append(dictionry)
            }
        }
        
        
        return newArray
    }
    /// 根据拼音排序城市
    public func sortCityByPinyin() -> [String]
    {
        var newArray = [String]()
        for index in 0..<self.count
        {
            newArray.append(self[index])
        }
        for index in 0..<newArray.count
        {
            for next  in index..<newArray.count
            {
                let str1 = newArray[index]
                let str2 = newArray[next]
                //判断是不是包含汉字
                let str1IsCN = str1.hasChinese
                let str2IsCN = str2.hasChinese
                
                //          两个字符串 不是同一种类型 一种汉字 一种字母
                // st1包含汉字  str2不包含汉字
                if str1IsCN && !str2IsCN
                {
                    newArray[index] = str2
                    newArray[next]  = str1
                    continue
                }
                // st1包含汉字  str2不包含汉字
                if !str1IsCN && str2IsCN
                {
                    continue
                }
                //          两个字符串 同一种类型 汉字 或 字母
                let cyles = str1.count > str2.count ? str2.count : str1.count
                for row in 0...cyles{
                    let indexChar = (str1.pinYin as NSString).character(at: row)
                    let nextChar  = (str2.pinYin as NSString).character(at: row)
                    // st1 st2 都包含汉字
                    if indexChar > nextChar
                    {
                        newArray[index] = str2
                        newArray[next]  = str1
                        break
                    }else if indexChar < nextChar {
                        break
                    }
                }
            }
        }
        return newArray
    }
}
