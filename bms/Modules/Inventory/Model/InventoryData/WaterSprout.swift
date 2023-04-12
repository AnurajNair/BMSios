//
//  WaterSprout.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class WaterSprout: NonPersistableRequestBody {
    var inSpan: Float = 0
    var totalNo: Float = 0
    
    enum ResponseKeys: String {
        case inSpan = "inspan"
        case totalNo = "totalno"
    }
    
    override func mapping(map: Map) {
        inSpan <- map[ResponseKeys.inSpan.rawValue]
        totalNo <- map[ResponseKeys.totalNo.rawValue]
    }
}
