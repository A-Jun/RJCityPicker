//
//  RJCityPickerInitialsHeaderView.swift
//  citypick
//
//  Created by RJ on 2018/11/15.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit

class RJCityPickerInitialsHeaderView: UIView {
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
        title.text = "A"
        title.sizeToFit()
        title.frame.origin.x    = leftMargin
        title.center.y          = titleHeight / 2
        return title
    }()
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
        self.backgroundColor = .tableViewBackgroundColor
    }
    //MARK: - 公有方法
    func configureViewWithTitle(_ title:String) -> Void {
        self.title.text = title
        self.title.sizeToFit()
    }
}
