//
//  RequestBody.swift
//  bms
//
//  Created by Naveed on 14/10/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RequestBody: Object,Mappable{
    
    required convenience init?(map: ObjectMapper.Map) {
           self.init()
       }

    func mapping(map: ObjectMapper.Map) {
          
       }
    
   
}

class APIRequestBody: NSObject, Mappable {
    required init?(map: ObjectMapper.Map) {
        
    }
    override init() {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        
    }
}
