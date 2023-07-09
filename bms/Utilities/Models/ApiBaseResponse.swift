//
//  ApiBaseResponse.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class ApiBaseResponse : RequestBody{
   @objc dynamic var status: Int  = 0
   @objc dynamic var message: String?
    
    enum ResponseKeys : String{
        case status = "ResponseCode"
       case  message = "ResponseDesc"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.status             <- map[ResponseKeys.status.rawValue]
        self.message            <- map[ResponseKeys.message.rawValue]
    }
    
}
