//
//  Project.swift
//  bms
//
//  Created by Sahil Ratnani on 16/04/23.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm


class Project : RequestBody {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String?
    @objc dynamic var desc : String?
    @objc dynamic var status : String?
       
    enum ResponseKeys :String{
        case id     = "id"
        case name = "name"
        case desc = "description"
        case status = "status"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.id         <- map[ResponseKeys.id.rawValue]
        self.name       <- map[ResponseKeys.name.rawValue]
        self.desc     <- map[ResponseKeys.desc.rawValue]
        self.status   <- map[ResponseKeys.status.rawValue]
    }
}

