//
//  InspectionStatsModel.swift
//  bms
//
//  Created by Sahil Ratnani on 11/06/23.
//

import Foundation
import ObjectMapper

class InspectionStatsModel: APIRequestBody {
    @objc dynamic var pendingForInspection: Int = 0
    @objc dynamic var pendingForReview: Int = 0
    @objc dynamic var completed: Int = 0
    @objc dynamic var total: Int = 0

    enum ResponseKeys :String {
        case pendingForInspection  = "pendingforinspection"
        case pendingForReview  = "pendingforreview"
        case completed  = "Completed"
        case total  = "total"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.pendingForInspection              <- map[ResponseKeys.pendingForInspection.rawValue]
        self.pendingForReview              <- map[ResponseKeys.pendingForReview.rawValue]
        self.completed              <- map[ResponseKeys.completed.rawValue]
        self.total              <- map[ResponseKeys.total.rawValue]
    }
}
