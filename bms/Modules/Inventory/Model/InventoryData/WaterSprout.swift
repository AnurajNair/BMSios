//
//  WaterSprout.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class WaterSprout: NonPersistableRequestBody {
    var inSpan: Int = 0
    var totalNo: Int = 0
    
    enum ResponseKeys: String {
        case inSpan = "inspan"
        case totalNo = "totalno"
    }
    
    override func mapping(map: Map) {
        inSpan <- map[ResponseKeys.inSpan.rawValue]
        totalNo <- map[ResponseKeys.totalNo.rawValue]
    }
}

extension WaterSprout {
    func setTotalNoOfWaterSprout(noOfSpan: Int) {
        totalNo = noOfSpan*inSpan
    }
}
