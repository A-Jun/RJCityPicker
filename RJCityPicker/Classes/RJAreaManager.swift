//
//  AreaModel.swift
//  citypick
//
//  Created by RJ on 2018/11/14.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit
import FMDB
typealias CitiesHandler = (_ cities:[String]) -> Void
class RJAreaManager: NSObject {
    //MARK: - 属性
    /// 数据库
    private var db = FMDatabase()
    /// 单例
    static let manager = RJAreaManager()
    
    //MARK: - 初始化
    override init() {
        super.init()
        self.areaSqliteDBData()
    }
    /// 初始化数据库
    private func areaSqliteDBData() -> Void {
        let fileManager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString
        let filePath = path.appendingPathComponent("shop_area.sqlite")
        if !fileManager.fileExists(atPath: filePath){
            print("数据库不存在")
            
            guard let str = Bundle.current?.path(forResource: "shop_area.sqlite", ofType: nil) else {return}
            try? fileManager.copyItem(atPath: str, toPath: filePath)
        }
        let newPath = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString).appendingPathComponent("shop_area.sqlite")
        let db = FMDatabase.init(path: newPath)
        self.db = db
        if db.open()
        {   print("创建数据库成功")
            let sqlStr = "CREATE TABLE IF NOT EXISTS shop_area (area_number INTEGER ,area_name TEXT ,city_number INTEGER ,city_name TEXT ,province_number INTEGER ,province_name TEXT);"
            if db.executeStatements(sqlStr)
            {
                print("创建表成功")
            }else
            {
                print("创建表失败")
                db.close()
            }
        }else
        {
            print("创建数据库失败")
        }
    }
    //MARK: - 公有方法
    /// 搜索所有的城市
    func cityData(_ handler:CitiesHandler?) -> Void {
        guard let handler = handler else { return }
        var cities = [String]()
        guard let result = try? self.db.executeQuery("SELECT DISTINCT city_name FROM shop_area;", values: nil) else
        {
            handler(cities)
            return
        }
        while result.next()
        {
            guard let st = result.string(forColumn: "city_name") else {continue}
            cities.append(st)
        }
        handler(cities)
    }
    func searchCityWithKey(_ key:String ,handler:CitiesHandler?) -> Void {
        guard let handler = handler else { return }
        var cities = [String]()
        guard let areaResult = try? self.db.executeQuery(String(format: "SELECT DISTINCT area_name,city_name,city_number FROM shop_area WHERE area_name LIKE '%%%@%%';",key), values: nil) else
        {
            handler(cities)
            return
        }
        while areaResult.next()
        {
            guard let st = areaResult.string(forColumn: "area_name") else {continue}
            cities.append(st)
        }
        guard let cityResult = try? self.db.executeQuery(String(format: "SELECT DISTINCT city_name,city_number,province_name FROM shop_area WHERE city_name LIKE '%%%@%%';",key), values: nil) else
        {
            handler(cities)
            return
        }
        while cityResult.next()
        {
            guard let st = cityResult.string(forColumn: "city_name") else {continue}
            cities.append(st)
        }
        guard let provinceResult = try? self.db.executeQuery(String(format: "SELECT DISTINCT province_name,city_name,city_number FROM shop_area WHERE province_name LIKE '%%%@%%';",key), values: nil) else
        {
            handler(cities)
            return
        }
        while provinceResult.next()
        {
            guard let st = provinceResult.string(forColumn: "province_name") else {continue}
            cities.append(st)
        }
        handler(cities)
    }
}
