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
