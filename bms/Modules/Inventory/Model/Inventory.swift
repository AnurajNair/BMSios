//
//  Inventory.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class Inventory: RequestBody {
    @objc dynamic var projectId: Int = 0
    @objc dynamic var buid: Int = 0
    @objc dynamic var saveStatus: String?
    @objc dynamic var status: String?

    enum ResponseKeys: String {
       case projectId = "projectid"
        case buid = "buid"
        case saveStatus  = "savestatus"
        case status = "status"
        
    }

    override func mapping(map: Map) {
        projectId <- map[ResponseKeys.projectId.rawValue]
    }
}
