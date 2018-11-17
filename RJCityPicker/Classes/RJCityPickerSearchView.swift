
//
//  RJCityPickerSearchView.swift
//  YiChunSports
//
//  Created by RJ on 2018/10/30.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit
class RJCityPickerSearchView: UIView {
   
    //MARK: - 属性
    /// 点击view取消第一响应者
    private lazy var tapView: UIView = {
        let tapView  = UIView()
        tapView.backgroundColor = .clear
        tapView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(viewTaped))
        tapView.addGestureRecognizer(tap)
        return tapView
    }()
    
    /// 显示搜索到的城市
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self;
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: self.bounds)
        searchBar.delegate = self
        
        return searchBar
    }()
    /// 搜索到的城市
    private var cities = [String]()

    /// cell 点击后的回调
    var cellCityHandler : RJCityPickerCellClickHandelr?
    //MARK: - 生命周期
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    private func initUI() -> Void {
        backgroundColor = .tableViewBackgroundColor
        isUserInteractionEnabled = true
        
        addSubview(searchBar)
    }
    
    
    @objc private func viewTaped() -> Void {
        tapView.removeFromSuperview()
        searchBar.resignFirstResponder()
    }
}

extension RJCityPickerSearchView:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if tapView.superview == nil {
            addTapView()
        }
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        if searchText.count == 0 {
            self.cities = [String]()
            self.tableView.reloadData()
            return
        }
        RJAreaManager.manager.searchCityWithKey(searchText) { (city:[String]) in
            print(city)
            self.cities = city
            if self.tableView.superview == nil {
                guard let window = UIApplication.shared.keyWindow else { return  }
                let oringY = self.frame.maxY + kStaBarHeight + (self.viewController?.navigationController?.navigationBar.frame.height ?? 0)
                self.tableView.frame = CGRect(x: 0, y: oringY, width: KScreenW, height: KScreenH - oringY)
                window.addSubview(self.tableView)
            }
            self.tableView.reloadData()
        }
    }
    private func addTapView() -> Void {
        guard let window = UIApplication.shared.keyWindow else { return  }
        tapView.frame = window.bounds
        window.addSubview(tapView)
    }
}
extension RJCityPickerSearchView:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellCityHandler = cellCityHandler else { return  }
        let text = cities[indexPath.row]
        cellCityHandler(text)
        tableView.removeFromSuperview()
    }
}
