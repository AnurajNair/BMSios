//
//  DismantlingOfRccAndBituminiousWearingCoat.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//

import Foundation
import ObjectMapper

class DismantlingOfRccAndBituminiousWearingCoat: NonPersistableRequestBody {
    var area: Float = 0
    var totalArea: Float = 0

    enum ResponseKeys: String {
        case area = "area"
        case totalArea = "totalarea"
    }

    override func mapping(map: Map) {
        area <- map[ResponseKeys.area.rawValue]
        totalArea <- map[ResponseKeys.totalArea.rawValue]
    }
}

extension DismantlingOfRccAndBituminiousWearingCoat {
    func setArea(lengthOfSpan: Float, widthOfSpan: Float) {
        area = lengthOfSpan*widthOfSpan
    }

    func setTotalArea(lengthOfSpan: Float) {
        totalArea = area*lengthOfSpan
    }
}
