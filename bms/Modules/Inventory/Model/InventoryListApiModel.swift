//
//  InventoryListRequestModel.swift
//  bms
//
//  Created by Sahil Ratnani on 10/04/23.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class InventoryListRequestModel: APIRequestBody {
    var authId:String?
    
    enum ResponseKeys :String{
        case authId  = "authid"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
    }
}

class InventoryDataRequestModel: APIRequestBody {
    var authId:String?
    var mode: String?
    var id: Int?

    enum ResponseKeys :String{
        case authId  = "authid"
        case mode = "mode"
        case id = "id"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.mode              <- map[ResponseKeys.mode.rawValue]
        self.id              <- map[ResponseKeys.id.rawValue]

    }
}

class InventoryListResponseModel : ApiBaseResponse {
  @objc dynamic var response : String?
    
    
    enum ResponseKeys :String{
        case response  = "ResponseData"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        super.mapping(map: map)
        self.response  <- map["ResponseData"]
    }
}
