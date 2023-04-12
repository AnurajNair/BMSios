//
//  PolymerModifiedCementGrout.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class PolymerModifiedCementGrout: RequestBody {
    @objc dynamic var totalVolumeOfGrout: Float = 0
    @objc dynamic var volumeOf1CementBag: Float = 0
    @objc dynamic var totalPmcGroutByWeight: Float = 0
    @objc dynamic var crossGirders: CrossGirder?
    @objc dynamic var topSlabInterior: TopSlabInterior?
    @objc dynamic var topSlabCantilever: TopSlabCantilever?
    @objc dynamic var pierCap: PierCap?


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
        @objc dynamic var volumeOfACrossGirder: Float = 0
        
        enum ResponseKeys: String {
            case volumeOfACrossGirder = "volumeofacrossgirder"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfACrossGirder <- map[ResponseKeys.volumeOfACrossGirder.rawValue]
        }
    }

    class TopSlabInterior: GroutingCommon {
        @objc dynamic var volumeOfTopSlab: Float = 0
        
        enum ResponseKeys: String {
            case volumeOfTopSlab = "volumeoftopslab"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfTopSlab <- map[ResponseKeys.volumeOfTopSlab.rawValue]
        }
    }

    class TopSlabCantilever: GroutingCommon {
        @objc dynamic var volumeOfTopSlab: Float = 0
        
        enum ResponseKeys: String {
            case volumeOfTopSlab = "volumeoftopslab"
        }
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            volumeOfTopSlab <- map[ResponseKeys.volumeOfTopSlab.rawValue]
        }
    }

    class PierCap: GroutingCommon {
        @objc dynamic var volumeOfPierCap: Float = 0
        @objc dynamic var noOfPierCap: Int = 0
        @objc dynamic var noOfPierCapToBeGrouted: Int = 0
        @objc dynamic var totalVolOfPierCap: Int = 0

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
