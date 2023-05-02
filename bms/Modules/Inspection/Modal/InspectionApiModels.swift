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

class SaveInspectionRequestModel: APIRequestBody {
    typealias Response = [String: Any]

    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var inspectionAssignId: Int?
    var inspectionStatus: String?
    var response: [Response] = []

    enum ResponseKeys :String{
        case authId  = "authid"
        case inspectionAssignId = "inspectionassignid"
        case inspectionStatus = "inspectionstatus"
        case response = "response"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.inspectionAssignId <- map[ResponseKeys.inspectionAssignId.rawValue]
        self.inspectionStatus <- map[ResponseKeys.inspectionStatus.rawValue]
        self.response <- map[ResponseKeys.response.rawValue]
    }
}

class SaveReviewRequestModel: APIRequestBody {
    typealias Review = [String: Any]

    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var inspectionAssignId: Int?
    var inspectionStatus: String?
    var reviews: [Review] = []

    enum ResponseKeys :String{
        case authId  = "authid"
        case inspectionAssignId = "inspectionassignid"
        case inspectionStatus = "inspectionstatus"
        case reviews = "reviews"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.inspectionAssignId <- map[ResponseKeys.inspectionAssignId.rawValue]
        self.inspectionStatus <- map[ResponseKeys.inspectionStatus.rawValue]
        self.reviews <- map[ResponseKeys.reviews.rawValue]
    }
}
