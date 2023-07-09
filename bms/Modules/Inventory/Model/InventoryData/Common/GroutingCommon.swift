//
//  GroutingCommon.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//

import Foundation
import ObjectMapper

class GroutingCommon: NonPersistableRequestBody {
    var porosity: Float = 0
    var porousVolume: Float = 0
    var pcOfPorousVolFilled: Float = 0
    var netVolumeToBeFilled: Float = 0
    var groutingToBeDonePc: Float = 0
    var totalVolToBeFilled: Float = 0
    
    enum ResponseKeys: String {
        case porosity = "porosity"
        case porousVolume = "porousvolume"
        case pcOfPorousVolFilled  = "pcofporousvolfilled"
        case netVolumeToBeFilled = "netvolumetobefilled"
        case groutingToBeDonePc = "groutingtobedonepc"
        case totalVolToBeFilled = "totalvoltobefilled"
    }
    
    override func mapping(map: Map) {
        porosity <- map[ResponseKeys.porosity.rawValue]
        porousVolume <- map[ResponseKeys.porousVolume.rawValue]
        pcOfPorousVolFilled <- map[ResponseKeys.pcOfPorousVolFilled.rawValue]
        netVolumeToBeFilled <- map[ResponseKeys.netVolumeToBeFilled.rawValue]
        groutingToBeDonePc <- map[ResponseKeys.groutingToBeDonePc.rawValue]
        totalVolToBeFilled <- map[ResponseKeys.totalVolToBeFilled.rawValue]
    }
}
