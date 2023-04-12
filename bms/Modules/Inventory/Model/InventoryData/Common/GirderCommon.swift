//
//  GirderCommon.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//

import Foundation
import ObjectMapper

class GirderCommon: RequestBody {
    @objc dynamic var totalArea: Float = 0
    @objc dynamic var estimatedPcOfDamagedArea: Float = 0
    @objc dynamic var damagedArea: Float = 0

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
