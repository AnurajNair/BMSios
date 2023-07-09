//
//  DashboardData.swift
//  bms
//
//  Created by Sahil Ratnani on 11/06/23.
//

import Foundation
import ObjectMapper

class DashboardData: APIRequestBody {
    @objc dynamic var inspectionData : InspectionStatsModel?
    @objc dynamic var reviewData : InspectionStatsModel?
    enum ResponseKeys :String{
        case inspectionData  = "myinsepectiondata"
        case reviewData  = "myreviewdata"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.inspectionData              <- map[ResponseKeys.inspectionData.rawValue]
        self.reviewData              <- map[ResponseKeys.reviewData.rawValue]
    }
}
