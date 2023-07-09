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
    var authId:String? = SessionDetails.getInstance().currentUser?.profile?.authId
    var mode: String?
    var id: Int?
    var status: String?

    enum ResponseKeys :String{
        case authId  = "authid"
        case mode = "mode"
        case id = "id"
        case status = "status"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.mode              <- map[ResponseKeys.mode.rawValue]
        self.id              <- map[ResponseKeys.id.rawValue]
        self.status              <- map[ResponseKeys.status.rawValue]
    }
}

class InventoryCRUDRequestModel {
    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var mode: String?
    let inventory: Inventory

    enum ResponseKeys :String{
        case authId  = "authid"
        case mode = "mode"
    }

    init(inventory: Inventory, mode: Mode) {
        self.inventory = inventory
        self.mode = mode.rawValue
    }

    func getJson() -> [String: Any] {
        var inventoryJson = Mapper().toJSON(inventory)
        inventoryJson[ResponseKeys.authId.rawValue] = authId
        inventoryJson[ResponseKeys.mode.rawValue] = mode
        return inventoryJson
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
