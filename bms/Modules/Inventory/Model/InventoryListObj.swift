//
//  InventoryListObj.swift
//  bms
//
//  Created by Sahil Ratnani on 08/04/23.
//

import Foundation
import ObjectMapper
import RealmSwift

class InventoryListObj: RequestBody {
    @objc dynamic var id: Int = 0
    @objc dynamic var projectId:Int = 0
    @objc dynamic var projectName:String?
    @objc dynamic var bridgeId = 0
    @objc dynamic var bridgeName: String?
    @objc dynamic var buid:String?
    @objc dynamic var bridgeFullName: String?
    @objc dynamic var saveStatus:String?
    @objc dynamic var status:String?


    enum ResponseKeys :String {
        case id     = "id"
        case projectId = "projectid"
        case projectName = "projectname"
        case bridgeId = "bridgeid"
        case bridgeName = "bridgenme"
        case buid = "buid"
        case bridgeFullName = "bridgefullname"
        case saveStatus = "savestatus"
        case status = "status"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.id         <- map[ResponseKeys.id.rawValue]
        self.projectId          <- map[ResponseKeys.projectId.rawValue]
        self.projectName     <- map[ResponseKeys.projectName.rawValue]
        self.bridgeId <- map[ResponseKeys.bridgeId.rawValue]
        self.bridgeName <- map[ResponseKeys.bridgeName.rawValue]
        self.buid   <- map[ResponseKeys.buid.rawValue]
        self.bridgeFullName <- map[ResponseKeys.bridgeFullName.rawValue]
        self.saveStatus <- map[ResponseKeys.saveStatus.rawValue]
        self.status   <- map[ResponseKeys.status.rawValue]
    }
}
