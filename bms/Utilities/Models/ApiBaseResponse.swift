//
//  ApiBaseResponse.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import ObjectMapper

class ApiBaseResponse : RequestBody{
    var status: Int?
    var message: String = ""
    
    enum ResponseKeys : String{
        case status = "ResponseCode"
       case  message = "ResponseDesc"
    }
    
    override func mapping(map: Map) {
        self.status             <- map[ResponseKeys.status.rawValue]
        self.message            <- map[ResponseKeys.message.rawValue]
    }
    
}
