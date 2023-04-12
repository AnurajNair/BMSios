//
//  ExpansionJoint.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class ExpansionJoint: RequestBody {
    @objc dynamic var noOfJoints: Float = 0
    @objc dynamic var length: Float = 0
    @objc dynamic var totalLength: Float = 0

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
