//
//  userInfo.swift
//  praticeDelegate
//
//  Created by 서민영 on 2023/09/06.
//

import Foundation
import RealmSwift

class Person:Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var age: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var phone: String = ""

    // id 가 고유 값입니다.
        override static func primaryKey() -> String? {
          return "id"
        }
    convenience init(firstName : String, userId : Int){
        self.init()
        self.name = name
        self.id = id
    }
}

