//
//  RJCityPickerHeaderViewCollectionViewCell.swift
//  citypick
//
//  Created by RJ on 2018/11/14.
//  Copyright © 2018 coollang. All rights reserved.
//

import UIKit
let kRJCityPickerHeaderViewCollectionViewCellReuseIdentifier = "RJCityPickerHeaderViewCollectionViewCell"
class RJCityPickerHeaderViewCollectionViewCell: UICollectionViewCell {
    //MARK: - 属性
    private lazy var title: UILabel = {
        let title = UILabel(frame: self.bounds)
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = UIColor.darkGray
        title.textAlignment = .center
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
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderColor   = UIColor.lightGray.cgColor
        self.layer.borderWidth   = 1
        self.backgroundColor     = .white
        addSubview(title)
    }
    //MARK: - 公有方法
    func configureCell(title:String) -> Void {
        self.title.text = title
    }
}
