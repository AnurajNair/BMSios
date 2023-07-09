//
//  InspectionBridgeList.swift
//  bms
//
//  Created by Naveed on 02/11/22.
//

import Foundation
import ObjectMapper

struct InspectionBridgeListModel {
    var id: String
    var project_name:String
    var project_code:String
    var location:String
}

class Inspection: RequestBody {
    @objc dynamic var id: Int = 0
    @objc dynamic var inspectionId: Int = 0
    @objc dynamic var inspectionName: String?
    @objc dynamic var bridgeId: Int = 0
    @objc dynamic var bridgeName: String?
    @objc dynamic var buid: String?
    @objc dynamic var startDateAsString: String?
    @objc dynamic var endDateAsString: String?
    @objc dynamic var nextReviewDateAsString: String?
    @objc dynamic var inspectionStatusName: String?
    @objc dynamic var inspectionStatus: String?
    var inspectionStatusEnum: InspectionStatus? {
        guard let inspectionStatus = inspectionStatus else { return nil }
        return InspectionStatus(rawValue: inspectionStatus)
    }

    enum ResponseKeys: String {
        case id = "id"
        case inspectionId = "inspectionid"
        case inspectionName = "inspectionname"
        case bridgeId = "bridgeid"
        case bridgeName  = "bridgename"
        case buid = "buid"
        case startDateAsString = "startdate"
        case endDateAsString = "enddate"
        case nextReviewDateAsString = "nextreviewdate"
        case inspectionStatusName = "inspectionstatusname"
        case inspectionStatus = "inspectionstatus"
    }

    override func mapping(map: Map) {
        id <- map[ResponseKeys.id.rawValue]
        inspectionId <- map[ResponseKeys.inspectionId.rawValue]
        inspectionName <- map[ResponseKeys.inspectionName.rawValue]
        bridgeId <- map[ResponseKeys.bridgeId.rawValue]
        bridgeName <- map[ResponseKeys.bridgeName.rawValue]
        buid <- map[ResponseKeys.buid.rawValue]
        startDateAsString <- map[ResponseKeys.startDateAsString.rawValue]
        endDateAsString <- map[ResponseKeys.endDateAsString.rawValue]
        nextReviewDateAsString <- map[ResponseKeys.nextReviewDateAsString.rawValue]
        inspectionStatusName <- map[ResponseKeys.inspectionStatusName.rawValue]
        inspectionStatus <- map[ResponseKeys.inspectionStatus.rawValue]
    }
}

