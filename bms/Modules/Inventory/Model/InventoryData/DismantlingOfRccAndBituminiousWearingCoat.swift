//
//  DismantlingOfRccAndBituminiousWearingCoat.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//

import Foundation
import ObjectMapper

class DismantlingOfRccAndBituminiousWearingCoat: RequestBody {
    @objc dynamic var area: Float = 0
    @objc dynamic var totalArea: Float = 0

    enum ResponseKeys: String {
        case area = "area"
        case totalArea = "totalarea"
    }

    override func mapping(map: Map) {
        area <- map[ResponseKeys.area.rawValue]
        totalArea <- map[ResponseKeys.totalArea.rawValue]
    }
}
