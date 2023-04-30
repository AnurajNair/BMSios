//
//  InspectionApiModels.swift
//  bms
//
//  Created by Sahil Ratnani on 29/04/23.
//

import Foundation
import ObjectMapper

class InspectionListRequestModel: APIRequestBody {
    var authId:String?
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
