//
//  DetailViewController.swift
//  DevExam
//
//  Created by Ирина Соловьева on 14/08/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    var selectedRecord = Record()
    private let imageRecord = UIImageView()
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationItem.title = selectedRecord.title
        navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        settingsUI()
    }
    
    private func settingsUI() {
        view.addSubview(imageRecord)
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        imageRecord.kf.setImage(with: URL(string: "http://dev-exam.l-tech.ru" + selectedRecord.image))
        titleLabel.text = selectedRecord.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        detailLabel.font = UIFont.systemFont(ofSize: 14.0)
        detailLabel.numberOfLines = 0
        detailLabel.text = selectedRecord.text
        settingsConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.topItem?.title = "Dev Exam"
    }

    private func settingsConstraints() {
    let guide = view.safeAreaLayoutGuide
        imageRecord.snp.makeConstraints { (make) in
            make.top.equalTo(guide).offset(20)
            make.centerX.equalTo(guide)
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageRecord.snp.bottom).offset(20)
            make.leading.equalTo(guide).offset(10)
            make.trailing.equalTo(guide).offset(-10)
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(guide).offset(10)
            make.trailing.equalTo(guide).offset(-10)
        }
    }
    
}
