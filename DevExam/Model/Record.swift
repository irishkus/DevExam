//
//  Record.swift
//  DevExam
//
//  Created by Ирина Соловьева on 13/08/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class Record: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var sort: Int = 0
    @objc dynamic var date: String = ""
    
    convenience init(json: JSON)  {
        self.init()
        self.title = json["title"].stringValue
        self.text = json["text"].stringValue
        self.image = json["image"].stringValue
        self.id = json["id"].intValue
        self.sort = json["sort"].intValue
        self.date = json["date"].stringValue
    }
    
    override static func primaryKey() -> String {
        return "id"
    }
}
