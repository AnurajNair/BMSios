//
//  PierDimension.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class PierDimension: NonPersistableRequestBody {
    var height: Float = 0
    var width: Float = 0
    var thickness: Float = 0
    
    enum ResponseKeys: String {
        case height = "height"
        case width = "width"
        case thickness  = "thickness"
    }
    
    override func mapping(map: Map) {
        height <- map[ResponseKeys.height.rawValue]
        width <- map[ResponseKeys.width.rawValue]
        thickness <- map[ResponseKeys.thickness.rawValue]
    }
}
