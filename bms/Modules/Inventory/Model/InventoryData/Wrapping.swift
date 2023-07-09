//
//  Wrapping.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class Wrapping: NonPersistableRequestBody {
    var mainGirder: MainGirder? = MainGirder()


    enum ResponseKeys: String {
        case mainGirder = "maingirder"
    }

    override func mapping(map: Map) {
        mainGirder  <- map[ResponseKeys.mainGirder.rawValue]
    }
}

extension Wrapping {
    class MainGirder: NonPersistableRequestBody {
        var noOfGirders: Int = 0 {
            didSet {
                setTotalArea()
            }
        }
        var bottomArea: Float = 0 {
            didSet {
                setTotalArea()
            }
        }
        var sideArea: Float = 0 {
            didSet {
                setTotalArea()
            }
        }
        var totalArea: Float = 0

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

        func setBottomArea(area: Float) {
            self.bottomArea = area
        }

        func setSideArea(mainGirderSideArea: Float) {
            self.sideArea = mainGirderSideArea*2
        }

        func setTotalArea() {
            totalArea = (sideArea+bottomArea)*Float(noOfGirders)
        }
    }
}
