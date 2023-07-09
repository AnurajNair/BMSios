//
//  PolymerModifiedCementGrout.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class PolymerModifiedCementGrout: NonPersistableRequestBody {
    var totalVolumeOfGrout: Float = 0
    var volumeOf1CementBag: Float = 0
    var totalPmcGroutByWeight: Float = 0
     var crossGirders: CrossGirder? = CrossGirder()
    var topSlabInterior: TopSlabInterior? = TopSlabInterior()
    var topSlabCantilever: TopSlabCantilever?  = TopSlabCantilever()
    var pierCap: PierCap? = PierCap()


    enum ResponseKeys: String {
        case crossGirders = "crossgirders"
        case topSlabInterior = "topslabinterior"
        case topSlabCantilever = "topslabcantilever"
        case pierCap = "piercap"
        case totalVolumeOfGrout = "totalvolumeofgrout"
        case volumeOf1CementBag = "volumeof1cementbag"
        case totalPmcGroutByWeight = "totalPmcGroutByWeight"

    }

    override func mapping(map: Map) {
        crossGirders <- map[ResponseKeys.crossGirders.rawValue]
        topSlabInterior <- map[ResponseKeys.topSlabInterior.rawValue]
        topSlabCantilever <- map[ResponseKeys.topSlabCantilever.rawValue]
        pierCap <- map[ResponseKeys.pierCap.rawValue]
        totalVolumeOfGrout <- map[ResponseKeys.totalVolumeOfGrout.rawValue]
        volumeOf1CementBag <- map[ResponseKeys.topSlabCantilever.rawValue]
        totalPmcGroutByWeight <- map[ResponseKeys.totalPmcGroutByWeight.rawValue]
    }
}

extension PolymerModifiedCementGrout {
    class CrossGirder: GroutingCommon {
        var volumeOfACrossGirder: Float = 0
        
        enum ResponseKeys: String {
            case volumeOfACrossGirder = "volumeofacrossgirder"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfACrossGirder <- map[ResponseKeys.volumeOfACrossGirder.rawValue]
        }
    }

    class TopSlabInterior: GroutingCommon {
        var volumeOfTopSlab: Float = 0
        
        enum ResponseKeys: String {
            case volumeOfTopSlab = "volumeoftopslab"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfTopSlab <- map[ResponseKeys.volumeOfTopSlab.rawValue]
        }
    }

    class TopSlabCantilever: GroutingCommon {
        var volumeOfTopSlab: Float = 0
        
        enum ResponseKeys: String {
            case volumeOfTopSlab = "volumeoftopslab"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfTopSlab <- map[ResponseKeys.volumeOfTopSlab.rawValue]
        }
    }

    class PierCap: GroutingCommon {
        var volumeOfPierCap: Float = 0
        var noOfPierCap: Int = 0
        var noOfPierCapToBeGrouted: Int = 0
        var totalVolOfPierCap: Int = 0

        enum ResponseKeys: String {
            case volumeOfPierCap = "volumeofpiercap"
            case noOfPierCap = "noofpiercap"
            case noOfPierCapToBeGrouted = "noofpiercaptobegrouted"
            case totalVolOfPierCap = "totalvolofpiercap"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfPierCap <- map[ResponseKeys.volumeOfPierCap.rawValue]
            noOfPierCap <- map[ResponseKeys.noOfPierCap.rawValue]
            noOfPierCapToBeGrouted <- map[ResponseKeys.noOfPierCapToBeGrouted.rawValue]
            totalVolOfPierCap <- map[ResponseKeys.totalVolOfPierCap.rawValue]
        }
    }
}
