//
//  PmcMortarTreatment.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class PmcMortarTreatment: NonPersistableRequestBody {
    var totalAreaForPmcMortarTreatment: Float = 0
    var bottomOfMainGirder: BottomOfMainGirder?
    var sideOfMainGirder: SideOfMainGirder?
    var crossGirder: CrossGirder?
    var topSlabInterior: TopSlabInterior?
    var topSlabCantilever: TopSlabCantilever?


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
    func setTotalAreaForPmcMortarTreatment() {
        guard let bottomTotalArea = bottomOfMainGirder?.totalArea,
              let sideDamagedArea = sideOfMainGirder?.damagedArea,
              let crossGirderDamagedArea = crossGirder?.damagedArea,
              let topSlabIDamagedArea = topSlabInterior?.damagedArea,
              let topSlabCDamagedArea = topSlabCantilever?.damagedArea else {
            return
        }
        totalAreaForPmcMortarTreatment = bottomTotalArea+sideDamagedArea+crossGirderDamagedArea+topSlabIDamagedArea+topSlabCDamagedArea
    }
}
extension PmcMortarTreatment {
    class BottomOfMainGirder: NonPersistableRequestBody {
        var areaOfBottom: Float = 0
        var totalArea: Float = 0

        enum ResponseKeys: String {
            case areaOfBottom = "areaofbottom"
            case totalArea = "totalarea"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            areaOfBottom <- map[ResponseKeys.areaOfBottom.rawValue]
            totalArea <- map[ResponseKeys.totalArea.rawValue]
        }

        func setAreaOfBottom(area: Float) {
            areaOfBottom = area
            
        }

        func setTotalArea(noOfSpan: Int, noOfMainGirderInSpan: Int) {
            totalArea = areaOfBottom*Float(noOfSpan*noOfMainGirderInSpan)
        }
    }

    class SideOfMainGirder: GirderCommon {
        func setTotalArea(areaOfSideGrider: Float, noOfSpan: Int, noOfMainGirderInSpan: Int) {
            totalArea = areaOfSideGrider*Float(noOfSpan*noOfMainGirderInSpan)*2
        }
    }

    class CrossGirder: GirderCommon {
        func setTotalArea(crossGirderAreaOfSide: Float, noOfCrossGirderInBridge: Int) {
            totalArea = crossGirderAreaOfSide*Float(noOfCrossGirderInBridge)*2
        }
    }

    class TopSlabInterior: GirderCommon {
        func setTotalArea(width: Float, lengthOfSpan: Float, noOfPortions: Int, noOfSpan: Int) {
            totalArea = width*lengthOfSpan*Float(noOfPortions*noOfSpan)
        }
    }

    class TopSlabCantilever: GirderCommon {
        func setTotalArea(areaOfTopSlabCantilever: Float, lengthOfSpan: Float, noOfSpan: Int) {
            totalArea = (areaOfTopSlabCantilever+0.4*lengthOfSpan)*Float(noOfSpan)
        }
    }
}
