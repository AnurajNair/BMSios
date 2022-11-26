//
//  ApiSuccess.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import ObjectMapper

class ApiSuccess : ApiBaseResponse{

    var response : ResponseMessage?
    
    enum ResponseKeys : String{
        case response = "response"
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.response <- map[ResponseKeys.response.rawValue]
    }
    
}

class ResponseMessage : APIRequestBody {
    var message: String = ""
    var planId : String = ""
    
    enum ResponseKeys : String{
        case
        message = "message",
        planId = "plan_id"
    }
    
    override func mapping(map: Map) {
        self.message  <- map[ResponseKeys.message.rawValue]
        self.planId  <- map[ResponseKeys.planId.rawValue]
    }
}
