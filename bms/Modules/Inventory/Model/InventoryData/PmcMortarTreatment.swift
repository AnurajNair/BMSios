//
//  PmcMortarTreatment.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class PmcMortarTreatment: RequestBody {
    @objc dynamic var totalAreaForPmcMortarTreatment: Float = 0
    @objc dynamic var bottomOfMainGirder: BottomOfMainGirder?
    @objc dynamic var sideOfMainGirder: SideOfMainGirder?
    @objc dynamic var crossGirder: CrossGirder?
    @objc dynamic var topSlabInterior: TopSlabInterior?
    @objc dynamic var topSlabCantilever: TopSlabCantilever?


    enum ResponseKeys: String {
        case totalAreaForPmcMortarTreatment = "totalareaforpmcmortartreatment"
        case bottomOfMainGirder = "bottomofmaingirder"
        case sideOfMainGirder = "sideofmaingirder"
        case crossGirder = "crossgirder"
        case topSlabInterior = "topslabinterior"
        case topSlabCantilever = "topslabcantilever"
    }

    override func mapping(map: Map) {
        totalAreaForPmcMortarTreatment  <- map[ResponseKeys.totalAreaForPmcMortarTreatment.rawValue]
        bottomOfMainGirder <- map[ResponseKeys.bottomOfMainGirder.rawValue]
        sideOfMainGirder <- map[ResponseKeys.sideOfMainGirder.rawValue]
        crossGirder <- map[ResponseKeys.crossGirder.rawValue]
        topSlabInterior <- map[ResponseKeys.topSlabInterior.rawValue]
        topSlabCantilever <- map[ResponseKeys.topSlabCantilever.rawValue]
    }
}

extension PmcMortarTreatment {
    class BottomOfMainGirder: RequestBody {
        @objc dynamic var areaOfBottom: Float = 0
        @objc dynamic var totalArea: Float = 0

        enum ResponseKeys: String {
            case areaOfBottom = "areaofbottom"
            case totalArea = "totalarea"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            areaOfBottom <- map[ResponseKeys.areaOfBottom.rawValue]
            totalArea <- map[ResponseKeys.totalArea.rawValue]
        }
    }

    class SideOfMainGirder: GirderCommon {

    }

    class CrossGirder: GirderCommon {
        
    }

    class TopSlabInterior: GirderCommon {
        
    }

    class TopSlabCantilever: GirderCommon {
        
    }
}
