//
//  InspectionApiModels.swift
//  bms
//
//  Created by Sahil Ratnani on 29/04/23.
//

import Foundation
import ObjectMapper

class InspectionListRequestModel: APIRequestBody {
    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var inspectionStatus: String?

    enum ResponseKeys :String{
        case authId  = "authid"
        case inspectionStatus = "inspectionstatus"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.inspectionStatus <- map[ResponseKeys.inspectionStatus.rawValue]
    }
}

class InspectionByIdRequestModel: APIRequestBody {
    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var inspectionId: Int?

    enum ResponseKeys :String{
        case authId  = "authid"
        case inspectionId = "inspectionid"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.inspectionId <- map[ResponseKeys.inspectionId.rawValue]
    }
}
