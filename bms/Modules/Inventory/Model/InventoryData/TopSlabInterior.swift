//
//  TopSlabInterior.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class TopSlabInterior: RequestBody {
    @objc dynamic var width: Float = 0
    @objc dynamic var noOfPortions: Float = 0
    @objc dynamic var thickness: Float = 0
    @objc dynamic var area: Float = 0
    @objc dynamic var volume: Float = 0

    enum ResponseKeys: String {
        case width = "width"
        case noOfPortions  = "noofportions"
        case thickness = "thickness"
        case area = "area"
        case volume = "volume"
    }

    override func mapping(map: Map) {
        width <- map[ResponseKeys.width.rawValue]
        noOfPortions <- map[ResponseKeys.noOfPortions.rawValue]
        thickness <- map[ResponseKeys.thickness.rawValue]
        area <- map[ResponseKeys.area.rawValue]
        volume <- map[ResponseKeys.volume.rawValue]
    }
}
