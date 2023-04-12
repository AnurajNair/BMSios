//
//  MainGirder.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class MainGirder: RequestBody {
    @objc dynamic var width: Float = 0
    @objc dynamic var depth: Float = 0
    @objc dynamic var areaBottom: Float = 0
    @objc dynamic var areaSide: Float = 0
    @objc dynamic var volume: Float = 0

    enum ResponseKeys: String {
        case width = "width"
        case depth  = "depth"
        case areaBottom = "areabottom"
        case areaSide = "areaside"
        case volume = "volume"

    }
    
    override func mapping(map: Map) {
        width <- map[ResponseKeys.width.rawValue]
        depth <- map[ResponseKeys.depth.rawValue]
        areaBottom <- map[ResponseKeys.areaBottom.rawValue]
        areaSide <- map[ResponseKeys.areaSide.rawValue]
        volume <- map[ResponseKeys.volume.rawValue]

    }
}
