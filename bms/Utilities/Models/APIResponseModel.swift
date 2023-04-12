//
//  APIResponseModel.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//
import ObjectMapper

class APIResponseModel: RequestBody {
    @objc dynamic var status: Int  = 0
    @objc dynamic var message: String?
    @objc dynamic var response : String?

    enum ResponseKeys : String {
        case status = "ResponseCode"
        case  message = "ResponseDesc"
        case response  = "ResponseData"
    }
     
     override func mapping(map: ObjectMapper.Map) {
         self.status             <- map[ResponseKeys.status.rawValue]
         self.message            <- map[ResponseKeys.message.rawValue]
         self.response            <- map[ResponseKeys.response.rawValue]
     }
}
