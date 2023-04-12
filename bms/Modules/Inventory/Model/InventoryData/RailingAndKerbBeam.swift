//
//  RailingAndKerbBeam.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class RailingAndKerbBeam: RequestBody {
    @objc dynamic var length: Float = 0
    @objc dynamic var noOfSpan: Float = 0
    @objc dynamic var totalLength: Float = 0

    enum ResponseKeys: String {
        case length = "length"
        case noOfSpan = "noofspan"
        case totalLength = "totallength"
    }
    
    override func mapping(map: Map) {
        length <- map[ResponseKeys.length.rawValue]
        noOfSpan <- map[ResponseKeys.noOfSpan.rawValue]
        totalLength <- map[ResponseKeys.totalLength.rawValue]
    }
}
