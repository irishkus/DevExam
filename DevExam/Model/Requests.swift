//
//  Requests.swift
//  DevExam
//
//  Created by Ирина Соловьева on 13/08/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import SwiftyJSON

class Requests {
    static func getMask(completion:  @escaping (String) -> ()) {
        let baseUrl = "http://dev-exam.l-tech.ru"
        let path = "/api/v1/phone_masks"
        let url = baseUrl+path
        
        AF.request(url, method: .get).responseData { response in
            guard let data = response.value else {
                completion("")
                return
            }
            do {
                let mask = try JSONDecoder().decode(MaskPhone.self, from: data)
                completion(mask.phoneMask)
            } catch {
                completion("")
                print(error)
            }
        }
    }
    
    static func postPhoneAndPass(phone: String, password: String, completion:  @escaping (Bool) -> ()) {
        let baseUrl = "http://dev-exam.l-tech.ru"
        let path = "/api/v1/auth"
        let url = baseUrl+path
        let headers: HTTPHeaders = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = [
            "phone": phone,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let answer = json["success"].boolValue
                completion(answer)
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    static func getRecords(completion:  @escaping ([Record]) -> ()) {
        let baseUrl = "http://dev-exam.l-tech.ru"
        let path = "/api/v1/posts"
        let url = baseUrl+path
        
        AF.request(url, method: .get).responseJSON { response in
          //  print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
               // print(json)
                let records = json.arrayValue.map { Record(json: $0)
                }
                completion(records)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
