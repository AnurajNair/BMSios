//
//  ForgotPasswordModel.swift
//  bms
//
//  Created by Naveed on 11/12/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm


class ForgotPasswordRequest:APIRequestBody{
    
    var email:String?
   
    
    enum ResponseKeys :String{
        case email  = "email"
      
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.email              <- map[ResponseKeys.email.rawValue]
       
    }
}

class ForgotPasswordResponse:ApiBaseResponse{
    @objc dynamic var response : String?
    
      
      
      enum ResponseKeys :String{
          case response  = "ResponseData"
       
      }
      
      override func mapping(map: ObjectMapper.Map) {
          super.mapping(map: map)
          self.response  <- map["ResponseData"]
      }
}
