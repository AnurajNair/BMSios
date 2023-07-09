//
//  Bridge.swift
//  bms
//
//  Created by Sahil Ratnani on 17/04/23.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm


class Bridge : RequestBody {
    @objc dynamic var id : Int = 0
    @objc dynamic var buid : String?
    @objc dynamic var name : String?
       
    enum ResponseKeys :String{
        case id     = "id"
        case name = "name"
        case buid = "buid"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.id         <- map[ResponseKeys.id.rawValue]
        self.name       <- map[ResponseKeys.name.rawValue]
        self.buid     <- map[ResponseKeys.buid.rawValue]
    }
}

