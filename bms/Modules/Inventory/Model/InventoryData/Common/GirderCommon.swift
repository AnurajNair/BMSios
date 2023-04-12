//
//  GirderCommon.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//

import Foundation
import ObjectMapper

class GirderCommon: NonPersistableRequestBody {
    var totalArea: Float = 0
    var estimatedPcOfDamagedArea: Float = 0
    var damagedArea: Float = 0

    enum ResponseKeys: String {
        case totalArea = "totalarea"
        case estimatedPcOfDamagedArea = "estimatedpcofdamagedarea"
        case damagedArea = "damagedarea"
    }

    override func mapping(map: Map) {
        totalArea <- map[ResponseKeys.totalArea.rawValue]
        estimatedPcOfDamagedArea <- map[ResponseKeys.estimatedPcOfDamagedArea.rawValue]
        damagedArea <- map[ResponseKeys.damagedArea.rawValue]
    }
}
