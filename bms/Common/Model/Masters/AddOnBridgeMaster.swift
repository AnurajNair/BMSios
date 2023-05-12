//
//  AddOnBridgeMaster.swift
//  bms
//
//  Created by Sahil Ratnani on 08/05/23.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class AddOnBridgeMaster: RequestBody {
    var projects = List<Project>()
    var typeOfBridge = List<BridgeType>()
    var typeOfCarriageWayFirstDigit = List<TypeOfCarriageWayFirstDigit>()
    var typeOfFoundation = List<FoundationType>()
    var typeOfCarriageWaySecondDigit = List<TypeOfCarriageWaySecondDigit>()
    var typeOfSuperStructure = List<SuperStructureType>()
    var typeOfStructure = List<SubStructureType>()
    var alternativeRoute = List<AlternativeRoute>()

    enum ResponseKeys :String{
        case projects  = "project"
        case typeOfBridge = "typeofbridge"
        case typeOfCarriageWayFirstDigit = "typeofcarriagewayfirstdigit"
        case typeOfFoundation = "typeoffoundation"
        case typeOfCarriageWaySecondDigit = "typeofcarriagewayseconddigit"
        case typeOfSuperStructure = "typeofsuperstructure"
        case typeOfStructure = "mypeofstructure"
        case alternativeRoute = "typeofalternativeroute"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.projects  <- (map[ResponseKeys.projects.rawValue], ListTransform<Project>())
        self.typeOfBridge   <- (map[ResponseKeys.typeOfBridge.rawValue], ListTransform<BridgeType>())
        self.typeOfCarriageWayFirstDigit   <- (map[ResponseKeys.typeOfCarriageWayFirstDigit.rawValue], ListTransform<TypeOfCarriageWayFirstDigit>())
        self.typeOfFoundation   <- (map[ResponseKeys.typeOfFoundation.rawValue], ListTransform<FoundationType>())
        self.typeOfCarriageWaySecondDigit  <- (map[ResponseKeys.typeOfCarriageWaySecondDigit.rawValue], ListTransform<TypeOfCarriageWaySecondDigit>())
        self.typeOfSuperStructure   <- (map[ResponseKeys.typeOfSuperStructure.rawValue], ListTransform<SuperStructureType>())
        self.typeOfStructure    <- (map[ResponseKeys.typeOfStructure.rawValue], ListTransform<SubStructureType>())
        self.alternativeRoute    <- (map[ResponseKeys.alternativeRoute.rawValue], ListTransform<AlternativeRoute>())
    }
}
