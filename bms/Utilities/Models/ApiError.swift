//
//  ApiError.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import ObjectMapper

class ApiError : APIRequestBody{
    var code: String?
    var httpCode: String?
    var cause: String?
    var status: String?
    var title : String?
    var message: String?

    enum ResponseKeys : String{
        case code = "code"
        case httpCode = "httpCode"
        case cause = "cause"
        case status = "status"
        case title = "title"
        case message = "message"
    }
    
    override func mapping(map: Map) {
        self.code           <- map[ResponseKeys.code.rawValue]
        self.httpCode       <- map[ResponseKeys.httpCode.rawValue]
        self.cause          <- map[ResponseKeys.cause.rawValue]
        self.status         <- map[ResponseKeys.status.rawValue]
        self.title          <- map[ResponseKeys.title.rawValue]
        self.message        <- map[ResponseKeys.message.rawValue]
    }
}
