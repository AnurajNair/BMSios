//
//  InventoryData.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class InventoryData: NonPersistableRequestBody {
    var typeOfFoundation: Int = 0
    var typeOfSubstructure: Int = 0
    var typeOfSuperstructure: Int = 0
    var typeOfBearing: Int = 0
    var typeOfExpansionJoint = 0
    var typeOfWearingCoars = 0
    var typeOfRailing = 0
    var noOfSpan = 0
    var lengthOfSpan: Float = 0
    var widthOfSpan: Float = 0
    var noOfMainGirderInASpan = 0
    var noOfBearingInSpan = 0
    var noOfPile = 0
    var diaOfPile = 0
    var pileCapDimension: PileCapDimension?
    var pierDimension: PierDimension?
    var mainGirder: MainGirder?
    var topSlabInterior: TopSlabInterior?
    var topSlabCantilever: TopSlabCantilever?
    var crossGirder: CrossGirder?
    var lowViscosityGrout: LowViscosityGrout?
    var polymerModifiedCementGrout: PolymerModifiedCementGrout?
    var pmcMortarTreatment: PmcMortarTreatment?
    var waterSprout: WaterSprout?
    var railingAndKerbBeam: RailingAndKerbBeam?
    var expansionJoint: ExpansionJoint?
    var dismantlingOfRccAndBituminiousWearingCoat: DismantlingOfRccAndBituminiousWearingCoat?
    var wrapping: Wrapping?


    
    enum ResponseKeys: String {
        case typeOfFoundation = "typeoffoundation"
        case typeOfSubstructure = "typeofsubstructure"
        case typeOfSuperstructure  = "typeofsuperstructure"
        case typeOfBearing = "typeofbearing"
        case typeOfExpansionJoint = "typeofexpansionjoint"
        case typeOfWearingCoars = "typeofwearingcoars"
        case typeOfRailing = "typeofrailing"
        case noOfSpan = "noofspan"
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
        noOfSpan <- map[ResponseKeys.noOfSpan.rawValue]
        lengthOfSpan <- map[ResponseKeys.lengthOfSpan.rawValue]
        widthOfSpan <- map[ResponseKeys.widthOfSpan.rawValue]
        noOfMainGirderInASpan <- map[ResponseKeys.noOfMainGirderInASpan.rawValue]
        noOfBearingInSpan <- map[ResponseKeys.noOfBearingInSpan.rawValue]
        diaOfPile <- map[ResponseKeys.diaOfPile.rawValue]
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

//MARK: Main Girder Functions
extension InventoryData {
    func setMainGirderAreaOfBottom() {
        mainGirder?.setAreaOfBottom(lengthOfSpan: lengthOfSpan)
        setPMCMortarAreaOfBottomOfMainGirder()
        setWrappingBottomAreaOfMainGirder()
    }

    func setMainGirderAreaOfSide() {
        mainGirder?.setAreaOfSide(lengthOfSpan: lengthOfSpan)
        setWrappingSideAreaOfMainGirder()
    }
}

//MARK: Top Slab (Interiror) Functions
extension InventoryData {
    func setTopSlabInteriorArea() {
        topSlabInterior?.setArea(lengthOfSpan: lengthOfSpan)
        setPMCMortarTotalAreaOfTopSlabInterior()
    }
}

//MARK: Top Slab (Cantilever) Functions
extension InventoryData {
    func setTopSlabCantileverArea() {
        topSlabCantilever?.setArea(lengthOfSpan: lengthOfSpan)
        setPMCMortarTotalAreaOfTopSlabCantilever()
    }
}

//MARK: PMC MORTAR Functions
extension InventoryData {
    func setPMCMortarAreaOfBottomOfMainGirder() {
        guard let area = mainGirder?.areaBottom else { return }
        pmcMortarTreatment?.bottomOfMainGirder?.setAreaOfBottom(area: area)
        setPMCMortarTotalAreaOfBottomOfMainGirder()
    }

    func setPMCMortarTotalAreaOfBottomOfMainGirder() {
        pmcMortarTreatment?.bottomOfMainGirder?.setTotalArea(noOfSpan: noOfSpan,
                                                             noOfMainGirderInSpan: noOfMainGirderInASpan)
        setTotalAreaForPmcMortarTreatment()
    }

    func setPMCMortarTotalAreaOfSideOfMainGirder() {
        guard let areaOfSideOfMainGirder = mainGirder?.areaSide else { return }
        pmcMortarTreatment?.sideOfMainGirder?.setTotalArea(areaOfSideGrider: areaOfSideOfMainGirder,
                                                           noOfSpan: noOfSpan,
                                                           noOfMainGirderInSpan: noOfMainGirderInASpan)
        setPMCMortarSideDamagedArea()
    }

    func setPMCMortarTotalAreaOfCrossGirder() {
        guard let areaOfSideOfCrossGirder = crossGirder?.areaOfSide,
              let noOfCrossGirder = crossGirder?.noOfCrossGirders else { return }
        pmcMortarTreatment?.crossGirder?.setTotalArea(crossGirderAreaOfSide: areaOfSideOfCrossGirder,
                                                      noOfCrossGirderInBridge: noOfCrossGirder)
        setPMCMortarCrossDamagedArea()
    }

    func setPMCMortarTotalAreaOfTopSlabInterior() {
        guard let width = topSlabInterior?.width,let noOfPortions = topSlabInterior?.noOfPortions else { return }
        pmcMortarTreatment?.topSlabInterior?.setTotalArea(width: width,
                                                          lengthOfSpan: lengthOfSpan,
                                                          noOfPortions: noOfPortions,
                                                          noOfSpan: noOfSpan)
        setPMCMortarTopSlabIDamagedArea()
    }

    func setPMCMortarTotalAreaOfTopSlabCantilever() {
        guard let area = topSlabCantilever?.area else { return }
        pmcMortarTreatment?.topSlabCantilever?.setTotalArea(areaOfTopSlabCantilever: area,
                                                            lengthOfSpan: lengthOfSpan,
                                                            noOfSpan: noOfSpan)
       setPMCMortarTopSlabCDamagedArea()
    }

    func setPMCMortarSideDamagedArea() {
        pmcMortarTreatment?.sideOfMainGirder?.setDamagedArea()
        setTotalAreaForPmcMortarTreatment()
    }

    func setPMCMortarCrossDamagedArea() {
        pmcMortarTreatment?.crossGirder?.setDamagedArea()
        setTotalAreaForPmcMortarTreatment()
    }
    func setPMCMortarTopSlabIDamagedArea() {
        pmcMortarTreatment?.topSlabInterior?.setDamagedArea()
        setTotalAreaForPmcMortarTreatment()
    }
    func setPMCMortarTopSlabCDamagedArea() {
        pmcMortarTreatment?.topSlabCantilever?.setDamagedArea()
        setTotalAreaForPmcMortarTreatment()
    }
    func setTotalAreaForPmcMortarTreatment() {
        pmcMortarTreatment?.setTotalAreaForPmcMortarTreatment()
    }
}

//MARK: Water Sprout Functions
extension InventoryData {
    func setTotalNoOfWaterSprout() {
        waterSprout?.setTotalNoOfWaterSprout(noOfSpan: noOfSpan)
    }
}

//MARK: Dismantling of RCC and Bituminous Wearing Coat Functions
extension InventoryData {
    func setAreaOfDismantlingOfRcc() {
        dismantlingOfRccAndBituminiousWearingCoat?.setArea(lengthOfSpan: lengthOfSpan, widthOfSpan: widthOfSpan)
        setTotalAreaOfDismantlingOfRCC()
    }

    func setTotalAreaOfDismantlingOfRCC() {
        dismantlingOfRccAndBituminiousWearingCoat?.setTotalArea(lengthOfSpan: lengthOfSpan)
    }
}

extension InventoryData {
    func setWrappingBottomAreaOfMainGirder() {
        guard let areaOfBottom = mainGirder?.areaBottom else { return }
        wrapping?.mainGirder?.setBottomArea(area: areaOfBottom)
    }

    func setWrappingSideAreaOfMainGirder() {
        guard let sideArea = mainGirder?.areaSide else { return }
        wrapping?.mainGirder?.setSideArea(mainGirderSideArea: sideArea)
    }
}
