//
//  APIResponseModel.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//
import ObjectMapper

class APIResponseModel: RequestBody {
    var status: Int {
        Int(statusString ?? "-1") ?? -1
    }
    @objc dynamic var statusString: String?
    @objc dynamic var message: String?
    @objc dynamic var response : String?

    enum ResponseKeys : String {
        case statusString = "ResponseCode"
        case  message = "ResponseDesc"
        case response  = "ResponseData"
    }
     
     override func mapping(map: ObjectMapper.Map) {
         self.statusString             <- map[ResponseKeys.statusString.rawValue]
         self.message            <- map[ResponseKeys.message.rawValue]
         self.response            <- map[ResponseKeys.response.rawValue]
     }
}
