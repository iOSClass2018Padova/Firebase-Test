//
//  User.swift
//  Firebase Test
//
//  Created by stefano vecchiati on 30/10/2018.
//Copyright © 2018 com.stefanovecchiati. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class User: Object, Codable {
    
    dynamic var id : String!
    dynamic var name : String?
    dynamic var surname : String?
    dynamic var email : String!
    dynamic var imageURL : String?
    dynamic var age : Int!
    dynamic var gender : Int!
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func getObject(in realm: Realm = try! Realm(configuration: RealmUtils.config), withId id : String) -> User? {
        return realm.object(ofType: User.self, forPrimaryKey: id)
    }
    
    func save(in realm: Realm = try! Realm(configuration: RealmUtils.config)) {
        do {
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {}
    }
}
