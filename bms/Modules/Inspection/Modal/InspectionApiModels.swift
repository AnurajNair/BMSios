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

class AddOnBridgeRequestModel: APIRequestBody {
    typealias Review = [String: Any]

    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var projectId: Int?
    var name: String?
    var chainagekm: Int?
    var chainagemet: Int?
    var carriageWayFirstDigit: Int?
    var carriageWaySecondDigit: Int?
    var bridgeType: Int?
    var foundation: Int?
    var superStructure: Int?
    var structure: Int?
    var alternateRoute: Int?

    enum ResponseKeys :String{
        case authId  = "authid"
        case projectId = "projectid"
        case name = "name"
        case chainagekm = "chainagekm"
        case chainagemet = "chainagemet"
        case carriageWayFirstDigit = "carriagewayfirstdigit"
        case carriageWaySecondDigit = "carriagewayseconddigit"
        case bridgeType = "bridgetype"
        case foundation = "foundation"
        case superStructure = "superstructure"
        case structure = "structure"
        case alternateRoute = "alternateroute"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.projectId <- map[ResponseKeys.projectId.rawValue]
        self.name <- map[ResponseKeys.name.rawValue]
        self.chainagekm <- map[ResponseKeys.chainagekm.rawValue]
        self.chainagemet <- map[ResponseKeys.chainagemet.rawValue]
        self.carriageWayFirstDigit <- map[ResponseKeys.carriageWayFirstDigit.rawValue]
        self.carriageWaySecondDigit <- map[ResponseKeys.carriageWaySecondDigit.rawValue]
        self.bridgeType <- map[ResponseKeys.bridgeType.rawValue]
        self.foundation <- map[ResponseKeys.foundation.rawValue]
        self.superStructure <- map[ResponseKeys.superStructure.rawValue]
        self.structure <- map[ResponseKeys.structure.rawValue]
        self.alternateRoute <- map[ResponseKeys.alternateRoute.rawValue]
    }
}

class AssignInspectionRequestModel: APIRequestBody {
    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var mode: String?
    var id: Int = 0
    var inspectionId: Int = 0
    var bridgeId: Int = 0
    var startDateAsString: String? = ""
    var endDateAsString: String? = ""
    var nextReviewDateAsString: String? = ""
    var inspector: [Int] = []
    var reviewer: [Int] = []
    var desc: String?

    enum ResponseKeys: String {
        case authId  = "authid"
        case id = "id"
        case inspectionId = "inspectionid"
        case mode = "mode"
        case bridgeId = "bridgeid"
        case startDateAsString = "startdate"
        case endDateAsString = "enddate"
        case nextReviewDateAsString = "nextreviewdate"
        case inspector = "inspectorid"
        case reviewer = "reviewerid"
        case desc = "description"
    }

    override func mapping(map: Map) {
        authId  <- map[ResponseKeys.authId.rawValue]
        id <- map[ResponseKeys.id.rawValue]
        inspectionId <- map[ResponseKeys.inspectionId.rawValue]
        mode <- map[ResponseKeys.mode.rawValue]
        bridgeId <- map[ResponseKeys.bridgeId.rawValue]
        startDateAsString <- map[ResponseKeys.startDateAsString.rawValue]
        endDateAsString <- map[ResponseKeys.endDateAsString.rawValue]
        nextReviewDateAsString <- map[ResponseKeys.nextReviewDateAsString.rawValue]
        inspector <- map[ResponseKeys.inspector.rawValue]
        reviewer <- map[ResponseKeys.reviewer.rawValue]
        desc <- map[ResponseKeys.desc.rawValue]
    }
}
