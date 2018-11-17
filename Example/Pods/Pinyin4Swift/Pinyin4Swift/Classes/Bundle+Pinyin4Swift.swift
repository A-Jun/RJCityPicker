//
//  Bundle+Pinyin4Swift.swift
//  Pinyin4Swift
//
//  Created by 翟现旗 on 2017/11/15.
//

import Foundation

extension Bundle {
    class func myBundle() -> Bundle? {
        
        let bundle = Bundle(for: PinyinHelper.self)
        if let path = bundle.path(forResource: "Pinyin4Swift", ofType: "bundle") {
            return Bundle(path: path)
        } else {
            return nil
        }
    }
}
