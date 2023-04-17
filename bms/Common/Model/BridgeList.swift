//
//  BridgeList.swift
//  bms
//
//  Created by Sahil Ratnani on 16/04/23.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

import Foundation
class BridgeList: RequestBody {
    var bridgeList = List<Bridge>()
    
    enum ResponseKeys :String{
        case bridgeList  = "bridgelist"
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.bridgeList              <- (map[ResponseKeys.bridgeList.rawValue], ListTransform<Bridge>())
    }
}
