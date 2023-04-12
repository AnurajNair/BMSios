//
//  Wrapping.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class Wrapping: RequestBody {
    @objc dynamic var mainGirder: MainGirder?


    enum ResponseKeys: String {
        case mainGirder = "maingirder"
    }

    override func mapping(map: Map) {
        mainGirder  <- map[ResponseKeys.mainGirder.rawValue]
    }
}

extension Wrapping {
    class MainGirder: RequestBody {
        @objc dynamic var noOfGirders: Float = 0
        @objc dynamic var bottomArea: Float = 0
        @objc dynamic var sideArea: Float = 0
        @objc dynamic var totalArea: Float = 0

        enum ResponseKeys: String {
            case noOfGirders = "noofgriders"
            case bottomArea = "bottomarea"
            case sideArea = "sidearea"
            case totalArea = "totalarea"
        }
        
        override func mapping(map: Map) {
            noOfGirders <- map[ResponseKeys.noOfGirders.rawValue]
            bottomArea <- map[ResponseKeys.bottomArea.rawValue]
            sideArea <- map[ResponseKeys.sideArea.rawValue]
            totalArea <- map[ResponseKeys.totalArea.rawValue]
        }
    }
}
