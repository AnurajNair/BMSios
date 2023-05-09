//
//  BridgePropertiesMaster.swift
//  bms
//
//  Created by Sahil Ratnani on 08/05/23.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class BridgePropertiesMaster: RequestBody {
    var typeOfBearing = List<BearingType>()
    var typeOfBridge = List<BridgeType>()
    var typeOfExpansionJoint = List<ExpansionJointType>()
    var typeOfFoundation = List<FoundationType>()
    var typeOfRailing = List<RailingType>()
    var typeOfSubStructure = List<SubStructureType>()
    var typeOfSuperStructure = List<SuperStructureType>()
    var typeOfWearingCoarse = List<WearingCoarseType>()

    enum ResponseKeys :String{
        case typeOfBearing  = "typeofbearing"
        case typeOfBridge = "typeofbridge"
        case typeOfExpansionJoint = "typeofexpansionjoint"
        case typeOfFoundation = "typeoffoundation"
        case typeOfRailing = "typeofrailing"
        case typeOfSubStructure = "typeofsubstructure"
        case typeOfSuperStructure = "typeofsuperstructure"
        case typeOfWearingCoarse = "typeofwearingcoarse"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.typeOfBearing  <- (map[ResponseKeys.typeOfBearing.rawValue], ListTransform<BearingType>())
        self.typeOfBridge   <- (map[ResponseKeys.typeOfBridge.rawValue], ListTransform<BridgeType>())
        self.typeOfExpansionJoint   <- (map[ResponseKeys.typeOfExpansionJoint.rawValue], ListTransform<ExpansionJointType>())
        self.typeOfFoundation   <- (map[ResponseKeys.typeOfFoundation.rawValue], ListTransform<FoundationType>())
        self.typeOfRailing  <- (map[ResponseKeys.typeOfRailing.rawValue], ListTransform<RailingType>())
        self.typeOfSubStructure <- (map[ResponseKeys.typeOfSubStructure.rawValue], ListTransform<SubStructureType>())
        self.typeOfSuperStructure   <- (map[ResponseKeys.typeOfSuperStructure.rawValue], ListTransform<SuperStructureType>())
        self.typeOfWearingCoarse    <- (map[ResponseKeys.typeOfWearingCoarse.rawValue], ListTransform<WearingCoarseType>())

    }
}
