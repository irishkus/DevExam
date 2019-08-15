//
//  DevExamTableViewCell.swift
//  DevExam
//
//  Created by Ирина Соловьева on 13/08/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import SnapKit

class DevExamTableViewCell: UITableViewCell {
    let photo = UIImageView()
    let title = UILabel()
    let detailedText = UILabel()
    let date = UILabel()
    let commonView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonView.addSubview(photo)
        commonView.addSubview(title)
        commonView.addSubview(detailedText)
        commonView.addSubview(date)
        addSubview(commonView)
        commonView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        commonView.layer.borderWidth = 2
        commonView.layer.borderColor = UIColor.black.cgColor
        commonView.layer.masksToBounds = true
        commonView.layer.cornerRadius = 25
        settingsSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func settingsSubview() {
        photo.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(20)
            make.bottom.lessThanOrEqualToSuperview().offset(-15)
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
        title.font = UIFont.boldSystemFont(ofSize: 16.0)
        title.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(photo.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        detailedText.font = UIFont.systemFont(ofSize: 14.0)
        detailedText.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.leading.equalTo(photo.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        date.font = UIFont.systemFont(ofSize: 14.0)
        date.snp.makeConstraints { (make) in
            make.top.equalTo(detailedText.snp.bottom).offset(10)
            make.leading.equalTo(photo.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
        detailedText.numberOfLines = 0
        title.numberOfLines = 0
    }
    
}
