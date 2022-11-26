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
    @objc dynamic var userId : String?
    @objc dynamic var phone : String?
    @objc dynamic var fullName : String?
    @objc dynamic var emailId : String?
    @objc dynamic var birthDate : String?
    @objc dynamic var gender : String?
    @objc dynamic var picUrl : String?
    @objc dynamic var bio : String?
    @objc dynamic var favPlace : String?
    @objc dynamic var isActive : Bool = false
    @objc dynamic var privacyFlag : Int = 0
    @objc dynamic var picPrivacyFlag : Int = 0
    var selected : Bool = false
    var isIn : Bool?
    
    enum ResponseKeys :String{
        case userId     = "user_id"
        case phone      = "phone_number"
        case fullName   = "full_name"
        case emailId    = "email_id"
        case birthDate  = "birth_date"
        case gender     = "gender"
        case picUrl     = "pic_url"
        case bio        = "bio"
        case favPlace   = "fav_place"
        case isActive   = "is_active"
        case privacyFlag = "privacy_flag"
        case picPrivacyFlag = "pic_privacy_flag"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.userId         <- map[ResponseKeys.userId.rawValue]
        self.phone          <- map[ResponseKeys.phone.rawValue]
        self.fullName       <- map[ResponseKeys.fullName.rawValue]
        self.emailId        <- map[ResponseKeys.emailId.rawValue]
        self.birthDate      <- map[ResponseKeys.birthDate.rawValue]
        self.gender         <- map[ResponseKeys.gender.rawValue]
        self.picUrl         <- map[ResponseKeys.picUrl.rawValue]
        self.bio            <- map[ResponseKeys.bio.rawValue]
        self.favPlace       <- map[ResponseKeys.favPlace.rawValue]
       // self.isActive       <- (map[ResponseKeys.isActive.rawValue],BoolTransform())
        self.favPlace       <- map[ResponseKeys.favPlace.rawValue]
        self.privacyFlag    <- map[ResponseKeys.privacyFlag.rawValue]
        self.picPrivacyFlag <- map[ResponseKeys.picPrivacyFlag.rawValue]
    }
}
