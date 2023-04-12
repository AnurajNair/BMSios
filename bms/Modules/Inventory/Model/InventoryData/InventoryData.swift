//
//  InventoryData.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class InventoryData: RequestBody {
    @objc dynamic var typeOfFoundation: Int = 0
    @objc dynamic var typeOfSubstructure: Int = 0
    @objc dynamic var typeOfSuperstructure: String?
    @objc dynamic var typeOfBearing: Int = 0
    @objc dynamic var typeOfExpansionJoint = 0
    @objc dynamic var typeOfWearingCoars = 0
    @objc dynamic var typeOfRailing = 0
    @objc dynamic var lengthOfSpan = 0
    @objc dynamic var widthOfSpan = 0
    @objc dynamic var noOfMainGirderInASpan = 0
    @objc dynamic var noOfBearingInSpan = 0
    @objc dynamic var noOfPile = 0
    @objc dynamic var diaOfPile = 0
    @objc dynamic var pileCapDimension: PileCapDimension?
    @objc dynamic var pierDimension: PierDimension?
    @objc dynamic var mainGirder: MainGirder?
    @objc dynamic var topSlabInterior: TopSlabInterior?
    @objc dynamic var topSlabCantilever: TopSlabCantilever?
    @objc dynamic var crossGirder: CrossGirder?
    @objc dynamic var lowViscosityGrout: LowViscosityGrout?
    @objc dynamic var polymerModifiedCementGrout: PolymerModifiedCementGrout?
    @objc dynamic var pmcMortarTreatment: PmcMortarTreatment?
    @objc dynamic var waterSprout: WaterSprout?
    @objc dynamic var railingAndKerbBeam: RailingAndKerbBeam?
    @objc dynamic var expansionJoint: ExpansionJoint?
    @objc dynamic var dismantlingOfRccAndBituminiousWearingCoat: DismantlingOfRccAndBituminiousWearingCoat?
    @objc dynamic var wrapping: Wrapping?


    
    enum ResponseKeys: String {
        case typeOfFoundation = "typeoffoundation"
        case typeOfSubstructure = "typeofsubstructure"
        case typeOfSuperstructure  = "typeofsuperstructure"
        case typeOfBearing = "typeofbearing"
        case typeOfExpansionJoint = "typeofexpansionjoint"
        case typeOfWearingCoars = "typeofwearingcoars"
        case typeOfRailing = "typeofrailing"
        case lengthOfSpan = "lengthofspan"
        case widthOfSpan = "widthofspan"
        case noOfMainGirderInASpan = "noofmaingirderinaspan"
        case noOfBearingInSpan = "noofbearinginspan"
        case noOfPile = "noofpile"
        case diaOfPile = "diaofpile"
        case pileCapDimension = "pilecapdimension"
        case mainGirder = "maingirder"
        case pierDimension = "pierdimension"
        case topSlabInterior = "topslabinterior"
        case topSlabCantilever = "topslabcantilever"
        case crossGirder = "crossgirder"
        case lowViscosityGrout = "lowviscositygrout"
        case polymerModifiedCementGrout = "polymermodifiedcementgrout"
        case pmcMortarTreatment = "pmcmortartreatment"
        case waterSprout = "watersprout"
        case railingAndKerbBeam = "railingandkerbbeam"
        case expansionJoint = "expansionjoint"
        case dismantlingOfRccAndBituminiousWearingCoat = "dismantlingofrccandbituminiouswearingcoat"
        case wrapping = "wrapping"

    }

    override func mapping(map: Map) {
        typeOfFoundation <- map[ResponseKeys.typeOfFoundation.rawValue]
        typeOfSubstructure <- map[ResponseKeys.typeOfSubstructure.rawValue]
        typeOfSuperstructure <- map[ResponseKeys.typeOfSuperstructure.rawValue]
        typeOfBearing <- map[ResponseKeys.typeOfBearing.rawValue]
        typeOfExpansionJoint <- map[ResponseKeys.typeOfExpansionJoint.rawValue]
        typeOfWearingCoars <- map[ResponseKeys.typeOfWearingCoars.rawValue]
        typeOfRailing <- map[ResponseKeys.typeOfRailing.rawValue]
        lengthOfSpan <- map[ResponseKeys.lengthOfSpan.rawValue]
        widthOfSpan <- map[ResponseKeys.widthOfSpan.rawValue]
        noOfMainGirderInASpan <- map[ResponseKeys.noOfMainGirderInASpan.rawValue]
        noOfBearingInSpan <- map[ResponseKeys.noOfBearingInSpan.rawValue]
        noOfBearingInSpan <- map[ResponseKeys.noOfBearingInSpan.rawValue]
        noOfPile <- map[ResponseKeys.noOfPile.rawValue]
        pileCapDimension <- map[ResponseKeys.pileCapDimension.rawValue]
        pierDimension <- map[ResponseKeys.pierDimension.rawValue]
        mainGirder <- map[ResponseKeys.mainGirder.rawValue]
        topSlabInterior <- map[ResponseKeys.topSlabInterior.rawValue]
        topSlabCantilever <- map[ResponseKeys.topSlabCantilever.rawValue]
        crossGirder <- map[ResponseKeys.crossGirder.rawValue]
        lowViscosityGrout <- map[ResponseKeys.lowViscosityGrout.rawValue]
        polymerModifiedCementGrout <- map[ResponseKeys.polymerModifiedCementGrout.rawValue]
        pmcMortarTreatment <- map[ResponseKeys.pmcMortarTreatment.rawValue]
        waterSprout <- map[ResponseKeys.waterSprout.rawValue]
        railingAndKerbBeam <- map[ResponseKeys.railingAndKerbBeam.rawValue]
        expansionJoint <- map[ResponseKeys.expansionJoint.rawValue]
        dismantlingOfRccAndBituminiousWearingCoat <- map[ResponseKeys.dismantlingOfRccAndBituminiousWearingCoat.rawValue]
        wrapping <- map[ResponseKeys.wrapping.rawValue]
    }
}
