//
//  CrossGirder.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class CrossGirder: RequestBody {
    @objc dynamic var width: Float = 0
    @objc dynamic var depth: Float = 0
    @objc dynamic var length: Float = 0
    @objc dynamic var areaOfBottom: Float = 0
    @objc dynamic var areaOfSide: Float = 0
    @objc dynamic var volume: Float = 0
    @objc dynamic var noOfCrossGirders: Int = 0

    enum ResponseKeys: String {
        case width = "width"
        case depth  = "depth"
        case length  = "length"
        case areaOfBottom = "areaofbottom"
        case areaOfSide = "areaofside"
        case volume = "volume"

    }
    
    override func mapping(map: Map) {
        width <- map[ResponseKeys.width.rawValue]
        depth <- map[ResponseKeys.depth.rawValue]
        length <- map[ResponseKeys.length.rawValue]
        areaOfBottom <- map[ResponseKeys.areaOfBottom.rawValue]
        areaOfSide <- map[ResponseKeys.areaOfSide.rawValue]
        volume <- map[ResponseKeys.volume.rawValue]
    }
}
