//
//  LoginUserResponse.swift
//  bms
//
//  Created by Naveed on 24/11/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class LoginUserResponse : ApiBaseResponse {
    var response : LoginUserReponseKeys?
    
    enum ResponseKeys :String{
        case response  = "Response"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        super.mapping(map: map)
        self.response  <- map[ResponseKeys.response.rawValue]
    }
}

class LoginUserReponseKeys : RequestBody {
    var ResponseData : String?
 
  
    
    enum ResponseKeys :String{
        case ResponseData              = "ResponseData"
      
        
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.ResponseData              <- map[ResponseKeys.ResponseData.rawValue]
       
    }
}


class Login :APIRequestBody{
    

    var username:String?
    var password:String?
    
    enum ResponseKeys :String{
        case username  = "loginid"
      case password    = "userpwd"
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.username              <- map[ResponseKeys.username.rawValue]
        self.password              <- map[ResponseKeys.password.rawValue]
    }
    
  
}
