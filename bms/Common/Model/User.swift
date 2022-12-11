//
//  User.swift
//  bms
//
//  Created by Naveed on 17/10/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm


class User : RequestBody {
    @objc dynamic var userId : Int = 0

    @objc dynamic var firstName : String?
    @objc dynamic var lastName : String?
    @objc dynamic var emailId : String?
    @objc dynamic var employeeId : String?
    @objc dynamic var defualtRole : Int = 0
    @objc dynamic var authId : String?
   
    var selected : Bool = false
    var isIn : Bool?
    
    enum ResponseKeys :String{
        case userId     = "userid"
      case firstName = "firstname"
        case lastName = "lastname"
        case emailId = "useremialid"
        case employeeId = "employeeid"
        case defaultRole = "defaultrole"
        case authId = "authid"
        
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.userId         <- map[ResponseKeys.userId.rawValue]
        self.firstName          <- map[ResponseKeys.firstName.rawValue]
        self.lastName     <- map[ResponseKeys.lastName.rawValue]
        self.emailId   <- map[ResponseKeys.emailId.rawValue]
        self.employeeId <- map[ResponseKeys.employeeId.rawValue]
        self.authId   <- map[ResponseKeys.authId.rawValue]
        self.defualtRole   <- map[ResponseKeys.defaultRole.rawValue]
        
    }
}
