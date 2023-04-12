//
//  PileCapDimension.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class PileCapDimension: NonPersistableRequestBody {
    var length: Float = 0
    var width: Float = 0
    var depth: Float = 0
    
    enum ResponseKeys: String {
        case length = "length"
        case width = "width"
        case depth  = "depth"
    }
    
    override func mapping(map: Map) {
        length <- map[ResponseKeys.length.rawValue]
        width <- map[ResponseKeys.width.rawValue]
        depth <- map[ResponseKeys.depth.rawValue]
    }
}
