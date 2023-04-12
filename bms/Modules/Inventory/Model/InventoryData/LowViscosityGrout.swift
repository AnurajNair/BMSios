//
//  InventoryData.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class LowViscosityGrout: RequestBody {
    @objc dynamic var mainGirder: MainGirder?
    
    enum ResponseKeys: String {
        case mainGirder = "maingrinders"
    }

    override func mapping(map: Map) {
        mainGirder <- map[ResponseKeys.mainGirder.rawValue]
    }
}

extension LowViscosityGrout {
    class MainGirders: GroutingCommon {
        @objc dynamic var volume: Float = 0
        @objc dynamic var specificGravity: Float = 0
        @objc dynamic var totalVolumeInLtr: Float = 0

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
