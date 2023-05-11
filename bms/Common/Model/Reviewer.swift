//
//  Reviewer.swift
//  bms
//
//  Created by Sahil Ratnani on 11/05/23.
//

import Foundation
import ObjectMapper
class Reviewer : RequestBody {
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String?
    @objc dynamic var employeeId : String?
    @objc dynamic var company : String?
       
    enum ResponseKeys :String {
        case id     = "id"
        case name = "name"
        case employeeId = "employeeid"
        case company = "company"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.id         <- map[ResponseKeys.id.rawValue]
        self.name          <- map[ResponseKeys.name.rawValue]
        self.employeeId     <- map[ResponseKeys.employeeId.rawValue]
        self.company   <- map[ResponseKeys.company.rawValue]
    }
}
