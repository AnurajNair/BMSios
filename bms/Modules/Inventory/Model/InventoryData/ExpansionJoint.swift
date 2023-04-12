//
//  ExpansionJoint.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class ExpansionJoint: NonPersistableRequestBody {
    var noOfJoints: Float = 0
    var length: Float = 0
    var totalLength: Float = 0

    enum ResponseKeys: String {
        case noOfJoints = "noofjoints"
        case length = "length"
        case totalLength = "totallength"
    }
    
    override func mapping(map: Map) {
        noOfJoints <- map[ResponseKeys.noOfJoints.rawValue]
        length <- map[ResponseKeys.length.rawValue]
        totalLength <- map[ResponseKeys.totalLength.rawValue]
    }
}
