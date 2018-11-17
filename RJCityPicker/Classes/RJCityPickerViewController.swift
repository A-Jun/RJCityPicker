//
//  ViewController.swift
//  citypick
//
//  Created by RJ on 2018/11/14.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit

private let kSearchViewHeight :CGFloat = 44
let         kCellHeight       :CGFloat = 44
typealias RJCityPickerCellClickHandelr = (_ city:String)->Void


public class RJCityPickerViewController: UIViewController {
    //MARK: - 属性
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self;
        tableView.bounces    = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    /// 总数据源
    private var totalDataSource    : [String:Any]{
        get{
            var totalDataSource = [String : Any]()
            totalDataSource["location"] = [String]()
            return totalDataSource
        }
    }
    /// 定位城市数据源
    private var locationCities = ["定位中..."]
    /// 最近访问城市数据源
    private var recentlCities  = [String]()
    private let maxRecentlCities = 6
    /// 热门城市数据源
    private var hotCities      = ["深圳市","上海市","北京市","广东市"]
    /// 城市
    private var allCities         =  [([String:Any])](){
        didSet{
            self.tableView.reloadData()
        }
    }
    /// 选择的城市
    private var selectedCityHandler : ((_ city:String)->Void)?
    
    private var cellCityHandler : RJCityPickerCellClickHandelr?
    
    //MARK: - 生命周期方法
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureHandler()
        self.view.addSubview(tableView)
        initRecentlCities()
        initAllCities()
        RJLocationManager.manager.location { (city:String?, error:Error?) in
            if error == nil {
                guard let city = city else {return}
                self.locationCities.removeAll()
                self.locationCities.append(city)
                self.tableView.reloadData()
            }
            else{
                print("定位错误")
            }
        }
    }
    private func initRecentlCities() -> Void {
        guard let recentlCities = UserDefaults.standard.stringArray(forKey: "RJCityPickerRecentlCities") else{return}
        self.recentlCities = recentlCities
    }
    //MARK: - 私有方法
    private func configureHandler() -> Void {
        cellCityHandler = { [weak self] (city:String)in
            self?.addRecentlCities(city)
        }
    }
    /// 请求城市数
    private func initAllCities() -> Void {
        var path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString).appendingPathComponent("cities.plist")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path)
        {
            guard let newPath = Bundle.current?.path(forResource: "cities.plist", ofType: nil) else { return  }
            print(newPath)
            path = newPath
        }
        let allCities = NSArray.init(contentsOfFile: path) as? [([String:Any])]
        if allCities == nil
        {
            RJAreaManager.manager.cityData
                {  (cities:[String]) in
                    DispatchQueue.global().async {
                        let array1 = cities.sortCityByPinyin().sortByInitials()
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(array1, forKey: "RJCityPickerAllCities")
                            let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! as NSString).appendingPathComponent("cities.plist")
                            print("\(path)")
                            (array1 as NSArray).write(toFile: path, atomically: true)
                            self.allCities = array1
                        }
                    }
                    
            }
            return
        }
        self.allCities = allCities!
    }
    /// 添加最近访问的城市
    private func addRecentlCities(_ city:String) -> Void {
        if recentlCities.contains(city) {
            var removeIndex = -1
            for index in 0..<recentlCities.count{
                if recentlCities[index] == city {
                    removeIndex = index
                }
            }
            if removeIndex == -1 {return}
            recentlCities.remove(at: removeIndex)
        }
        if recentlCities.count >= maxRecentlCities {
            recentlCities.remove(at: 0)
        }
        recentlCities.append(city)
        tableView.reloadData()
        UserDefaults.standard.set(recentlCities, forKey: "RJCityPickerRecentlCities")
        UserDefaults.standard.synchronize()
        if selectedCityHandler != nil {
            selectedCityHandler!(city)
        }
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - 公有方法
    public func city(_ cityHanler:((_ city:String)->Void)?) {
        guard let cityHanler = cityHanler else { return  }
        selectedCityHandler = cityHanler
    }
}
extension RJCityPickerViewController:UITableViewDelegate,UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + allCities.count
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        case 0...3:
            return 0
        default:
           return (allCities[section - 4]["array"] as! [String]).count
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (allCities[indexPath.section - 4]["array"] as! [String])[indexPath.row]
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return kCellHeight + kLayoutMinimumLineSpacing
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = RJCityPickerSearchView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: kSearchViewHeight))
            headerView.cellCityHandler = cellCityHandler
            return headerView
        case 1:
            let headerView = RJCityPickerCityHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 100))
            headerView.configureViewWithTitle("定位城市", dataSource: locationCities)
            headerView.cellCityHandler = cellCityHandler
            return headerView
        case 2:
            let headerView = RJCityPickerCityHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 100))
            headerView.configureViewWithTitle("最近访问城市", dataSource: recentlCities)
            headerView.cellCityHandler = cellCityHandler
            return headerView
        case 3:
            let headerView = RJCityPickerCityHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 100))
            headerView.configureViewWithTitle("热门城市", dataSource: hotCities)
            headerView.cellCityHandler = cellCityHandler
            return headerView
        default:
            let headerView = RJCityPickerInitialsHeaderView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: 100))
            headerView.configureViewWithTitle((allCities[section - 4]["initials"] as! String))
            return headerView
        }
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return headerViewHeightWithCityNumber(locationCities.count)
        case 2:
            return headerViewHeightWithCityNumber(recentlCities.count)
        case 3:
            return headerViewHeightWithCityNumber(hotCities.count)
        default:
            return kCellHeight
        }
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let city = (cell?.textLabel?.text)!
        addRecentlCities(city)
    }
    
    private func headerViewHeightWithCityNumber(_ number:Int) -> CGFloat {
        let height :CGFloat = kCellHeight
        let remainder = Double(number) / Double(maxItemInLine)
        let integer  = CGFloat(ceil(remainder))
        return height + integer * kCellHeight + kLayoutMinimumLineSpacing
    }
    
}
