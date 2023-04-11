//
//  InventoryList.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

import Foundation
class InventoryList: RequestBody {
    var inventoryList = List<InventoryModel>()
    
    enum ResponseKeys :String{
        case inventoryList  = "inventorylist"
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.inventoryList              <- (map[ResponseKeys.inventoryList.rawValue], ListTransform<InventoryModel>())
    }
}
