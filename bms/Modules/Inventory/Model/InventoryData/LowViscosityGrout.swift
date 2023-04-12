//
//  InventoryData.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class LowViscosityGrout: NonPersistableRequestBody {
    var mainGirder: MainGirder?
    
    enum ResponseKeys: String {
        case mainGirder = "maingrinders"
    }

    override func mapping(map: Map) {
        mainGirder <- map[ResponseKeys.mainGirder.rawValue]
    }
}

extension LowViscosityGrout {
    class MainGirders: NonPersistableRequestBody {
        var volume: Float = 0
        var specificGravity: Float = 0
        var totalVolumeInLtr: Float = 0

        enum ResponseKeys: String {
            case volume = "volume"
            case specificGravity = "specificgravity"
            case totalVolumeInLtr = "totalvolumeinltr"
        }

        override func mapping(map: Map) {
            super.mapping(map: map)
            volume <- map[ResponseKeys.volume.rawValue]
            specificGravity <- map[ResponseKeys.specificGravity.rawValue]
            totalVolumeInLtr <- map[ResponseKeys.totalVolumeInLtr.rawValue]
        }
    }
}
