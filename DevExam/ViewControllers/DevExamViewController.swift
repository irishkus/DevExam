//
//  DevExamViewController.swift
//  DevExam
//
//  Created by Ирина Соловьева on 13/08/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class DevExamViewController: UIViewController {
    private let sortSegment = UISegmentedControl(items : ["Server sort", "By date sort"])
    private let recordsTableView = UITableView()
    var records: Results<Record>?
    var notificationToken: NotificationToken?
    private let cellId = "cellId"
    var selectedRecord = Record()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(recordsTableView)
        view.backgroundColor = .white
        createUI()
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(DevExamViewController.refreshButtonTapped(button:)))
        navigationController?.navigationBar.topItem?.title = "Dev Exam"
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [refreshButton]
        records = RealmProvider.get(Record.self)?.sorted(byKeyPath: "sort")
        recordsTableView.dataSource = self
        recordsTableView.delegate = self
        recordsTableView.separatorStyle = .none
        notificationToken = records?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.recordsTableView.reloadData()
            case .update(_, _, _, _):
                self.recordsTableView.reloadData()
            case .error(let error):
                fatalError("\(error)")
            }
        }
        Requests.getRecords { records in
            RealmProvider.save(items: records)
        }
        recordsTableView.register(DevExamTableViewCell.self, forCellReuseIdentifier: cellId)
        Timer.scheduledTimer(timeInterval: 200.0,
                                         target: self,
                                         selector: #selector(DevExamViewController.refreshButtonTapped(button:)),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    
    private func createUI() {
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.addSubview(sortSegment)
        sortSegment.layer.shadowColor = UIColor.black.cgColor
        sortSegment.layer.shadowOffset = CGSize(width: 2, height: 2)
        sortSegment.layer.shadowRadius = 2
        sortSegment.layer.shadowOpacity = 1.0
        sortSegment.layer.borderWidth = 1
        sortSegment.layer.borderColor = UIColor.black.cgColor
        sortSegment.selectedSegmentIndex = 0
        sortSegment.backgroundColor = .white
        sortSegment.tintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        sortSegment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2156862745, green: 0.137254902, blue: 0.2862745098, alpha: 1)
            ], for: .normal)
        sortSegment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            ], for: .selected)
        sortSegment.addTarget(self, action: #selector(DevExamViewController.indexChanged(_:)), for: .valueChanged)
        recordsTableView.rowHeight = UITableView.automaticDimension
        settingsConstraints()
    }
    
    //настройка констрейнтов между элементами UI
    private func settingsConstraints() {
        let guide = view.safeAreaLayoutGuide
        sortSegment.snp.makeConstraints { (make) in
            make.top.equalTo(guide).offset(20)
            make.centerX.equalTo(guide)
            make.left.equalTo(guide).offset(40)
        }
        recordsTableView.snp.makeConstraints { (make) in
            make.top.equalTo(sortSegment.snp.bottom).offset(20)
            make.centerX.equalTo(guide)
            make.left.equalTo(guide).offset(20)
            make.bottom.equalTo(guide).offset(-40)
        }
    }
    
    //обновление таблицы в базе
    @objc private func refreshButtonTapped(button: UIButton) {
        Requests.getRecords { records in
            RealmProvider.save(items: records)
        }
    }
    
    //переключение между видами сортировки
    @objc private func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            print("---")
            records = RealmProvider.get(Record.self)?.sorted(byKeyPath: "sort", ascending: true)
            recordsTableView.reloadData()
        case 1:
            print("+++")
            records = RealmProvider.get(Record.self)?.sorted(byKeyPath: "date", ascending: false)
           // records = sortDate()
            recordsTableView.reloadData()
        default:
            break
        }
    }
    
}

//заполнение таблицы
extension DevExamViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DevExamTableViewCell
        guard let records = records else {return cell}
        cell.title.text = records[indexPath.row].title
        cell.detailedText.text = records[indexPath.row].text
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") 
        guard let date = dateFormatter.date(from: records[indexPath.row].date) else {return cell}
        let dateFormaterString = DateFormatter()
        dateFormaterString.dateFormat = "dd.MM.yyyy, HH:mm"
        cell.date.text = dateFormaterString.string(from: date)
        cell.photo.kf.setImage(with: URL(string: "http://dev-exam.l-tech.ru" + records[indexPath.row].image))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let records = records else {return}
        selectedRecord = records[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.selectedRecord = selectedRecord
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}
