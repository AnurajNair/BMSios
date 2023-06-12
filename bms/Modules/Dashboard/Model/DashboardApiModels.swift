//
//  DashboardApiModels.swift
//  bms
//
//  Created by Sahil Ratnani on 11/06/23.
//

import Foundation
import ObjectMapper

class DashboardDataRequestModel: APIRequestBody {
    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId

    enum ResponseKeys :String{
        case authId  = "authid"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
    }
}

class ActivityReadRequestModel: APIRequestBody {
    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var activityId: Int?

    enum ResponseKeys :String{
        case authId  = "authid"
        case activityId = "activityid"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.activityId              <- map[ResponseKeys.activityId.rawValue]
    }
}
