//
//  RJCityPickerHeaderView.swift
//  citypick
//
//  Created by RJ on 2018/11/14.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit
let KScreenH = UIScreen.main.bounds.size.height
let KScreenW = UIScreen.main.bounds.size.width

/// 每行item最大个数
let maxItemInLine = 3
/// collectView layour 行间距
let kLayoutMinimumLineSpacing            :CGFloat = 15
/// collectView layour 竖间距
let kLayoutMinimumInteritemSpacing       :CGFloat = 15
class RJCityPickerCityHeaderView: UIView {
    //MARK: - 属性
    
    /// collectionView 左间距
    private let leftMargin  :CGFloat = 15
    /// collectionView 右间距
    private let rightMargin :CGFloat = 15
    /// collectionView 右间距
    private let titleHeight :CGFloat = 44
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = UIColor.black
        title.text = "定位城市"
        title.sizeToFit()
        title.frame.origin.x    = leftMargin
        title.center.y          = titleHeight / 2.0
        return title
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemW  = (KScreenW - leftMargin - rightMargin - kLayoutMinimumInteritemSpacing * CGFloat(maxItemInLine - 1) )/CGFloat(maxItemInLine)
        layout.itemSize = CGSize(width: itemW, height: kCellHeight)
        layout.minimumLineSpacing = kLayoutMinimumLineSpacing
        layout.minimumInteritemSpacing = kLayoutMinimumInteritemSpacing
        
        let collectionView = UICollectionView(frame: CGRect(x: leftMargin, y: titleHeight, width:KScreenW - kLayoutMinimumInteritemSpacing * CGFloat(maxItemInLine - 1) , height: self.frame.height - kCellHeight), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RJCityPickerHeaderViewCollectionViewCell.self, forCellWithReuseIdentifier: kRJCityPickerHeaderViewCollectionViewCellReuseIdentifier)
        collectionView.backgroundColor = .tableViewBackgroundColor
        return collectionView
    }()
    
    /// cell 点击后的回调
    var cellCityHandler : RJCityPickerCellClickHandelr?
    public var dataSource = [String](){
        didSet{
            var rect = collectionView.frame
            rect.size.height = collectionViewHeightWithCityNumber(dataSource.count)
            collectionView.frame = rect
            collectionView.reloadData()
        }
    }
    //MARK: - 初始化
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }
    //MARK: - 私有方法
    private func configureUI() -> Void {
        addSubview(title)
        addSubview(collectionView)
        self.backgroundColor = .tableViewBackgroundColor
    }
    /// 计算高度
    private func collectionViewHeightWithCityNumber(_ number:Int) -> CGFloat {
        let remainder = Double(number ) / Double(maxItemInLine)
        let integer  = CGFloat(ceil(remainder))
        return integer * kCellHeight + kLayoutMinimumLineSpacing
    }
    //MARK: - 公有方法
    func configureViewWithTitle(_ title:String , dataSource:[String]) -> Void {
        self.title.text = title
        self.title.sizeToFit()
        self.dataSource = dataSource
    }
    
}
extension RJCityPickerCityHeaderView:UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRJCityPickerHeaderViewCollectionViewCellReuseIdentifier, for: indexPath) as? RJCityPickerHeaderViewCollectionViewCell
        if cell == nil {
            cell = RJCityPickerHeaderViewCollectionViewCell()
        }
        cell?.configureCell(title: dataSource[indexPath.row])
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellCityHandler = cellCityHandler else { return  }
        let text = dataSource[indexPath.row]
        cellCityHandler(text)
    }
}
