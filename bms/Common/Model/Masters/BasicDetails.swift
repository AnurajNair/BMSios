//
//  BasicDetails.swift
//  bms
//
//  Created by Sahil Ratnani on 09/05/23.
//

import Foundation
import ObjectMapper

class BasicDetails: RequestBody {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String?
    @objc dynamic var desc: String?
    @objc dynamic var status: String?

    enum ResponseKeys :String {
        case id     = "id"
        case name = "name"
        case desc = "description"
        case status = "status"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        id         <- map[ResponseKeys.id.rawValue]
        name         <- map[ResponseKeys.name.rawValue]
        desc         <- map[ResponseKeys.desc.rawValue]
        status         <- map[ResponseKeys.status.rawValue]
    }
}
