//
//  Step7Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step7Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1

    let sections = [(sectionName: "Cross Girder", fields: ["Volume of a Cross Girder",
                                                           "Porosity", "Porous Volume",
                                                           "% of porous volume filled by grouting",
                                                           "Net volume to be filled in a girder by grout",
                                                           "Total volume to be filled in all girder in the bridge by grout"]),
                    (sectionName: "Top Slab (Interior)", fields: ["Volume of a Top Slab",
                                                                  "Porosity", "Porous Volume",
                                                                  "% of porous volume filled by grouting",
                                                                  "Net volume to be filled in a girder by grout",
                                                                  "Total volume to be filled in all girder in the bridge by grout"]),
                    (sectionName: "Top Slab (Cantilever)", fields: ["Volume of a Top Slab",
                                                                    "Porosity", "Porous Volume",
                                                                    "% of porous volume filled by grouting",
                                                                    "Net volume to be filled in a girder by grout",
                                                                    "Total volume to be filled in all girder in the bridge by grout"])]

    var collectionView: UICollectionView?
    let inventory: Inventory

    private var crossGirder: PolymerModifiedCementGrout.CrossGirder? {
        inventory.data?.polymerModifiedCementGrout?.crossGirders
    }
    private var topSlabInterior: PolymerModifiedCementGrout.TopSlabInterior? {
        inventory.data?.polymerModifiedCementGrout?.topSlabInterior
    }
    private var topSlabCantilever: PolymerModifiedCementGrout.TopSlabCantilever? {
        inventory.data?.polymerModifiedCementGrout?.topSlabCantilever
    }

    init(inventory: Inventory) {
        self.inventory = inventory
        
    }

    func populate(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Step7Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableCollectionHeaderView.identifier, for: indexPath) as? ReusableCollectionHeaderView else {
            return UICollectionReusableView(frame: .zero)
        }
        
        headerView.titleLbl.text = sections[indexPath.section].sectionName
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].fields.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        let fieldTitle = sections[indexPath.section].fields[fieldNo]
        let fieldValue: String?
        let isFieldEditable = fieldNo == 0 || fieldNo == 1 ||  fieldNo == 3
        switch indexPath.section {
        case 0:
            fieldValue = fieldValueForSection0(row: fieldNo)
        case 1:
            fieldValue = fieldValueForSection1(row: fieldNo)
        case 2:
            fieldValue = fieldValueForSection2(row: fieldNo)
        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: indexPath, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)

        cell.collectionFormElement.delegate = self
        return cell
    }

    func fieldValueForSection0(row: Int) -> String? {
        switch row {
        case 0:
            return crossGirder?.volumeOfACrossGirder.description
        case 1:
            return crossGirder?.porosity.description
        case 2:
            return crossGirder?.porousVolume.description
        case 3:
            return crossGirder?.pcOfPorousVolFilled.description
        case 4:
            return crossGirder?.netVolumeToBeFilled.description
        case 5:
            return crossGirder?.totalVolToBeFilled.description

        default:
            return nil
        }
    }

    func fieldValueForSection1(row: Int) -> String? {
        switch row {
        case 0:
            return topSlabInterior?.volumeOfTopSlab.description
        case 1:
            return topSlabInterior?.porosity.description
        case 2:
            return topSlabInterior?.porousVolume.description
        case 3:
            return topSlabInterior?.pcOfPorousVolFilled.description
        case 4:
            return topSlabInterior?.netVolumeToBeFilled.description
        case 5:
            return topSlabInterior?.totalVolToBeFilled.description

        default:
            return nil
        }
    }

    func fieldValueForSection2(row: Int) -> String? {
        switch row {
        case 0:
            return topSlabCantilever?.volumeOfTopSlab.description
        case 1:
            return topSlabCantilever?.porosity.description
        case 2:
            return topSlabCantilever?.porousVolume.description
        case 3:
            return topSlabCantilever?.pcOfPorousVolFilled.description
        case 4:
            return topSlabCantilever?.netVolumeToBeFilled.description
        case 5:
            return topSlabCantilever?.totalVolToBeFilled.description

        default:
            return nil
        }
    }
}

extension Step7Form: UICollectionViewDelegate {
}

extension Step7Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

extension Step7Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        guard let index = index as? IndexPath else { return }
        switch index.section {
        case 0:
            setValuesForSectin0(row: index.row, item: item)
        case 1:
            setValuesForSectin1(row: index.row, item: item)
            
        case 2:
            setValuesForSectin2(row: index.row, item: item)
            
        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }
}

//MARK: Section 0 - Cross Girder
extension Step7Form {
    func setValuesForSectin0(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            crossGirder?.volumeOfACrossGirder = floatValue
            setCrossGirderPorousVolume()
        case 1:
            crossGirder?.porosity = floatValue
            setCrossGirderPorousVolume()
        case 2:
            crossGirder?.porousVolume = floatValue
            setCrossGirderNetVolume()
        case 3:
            crossGirder?.pcOfPorousVolFilled = floatValue
            setCrossGirderNetVolume()
            
        case 4:
            topSlabInterior?.netVolumeToBeFilled = floatValue
            setCrossGirderTotalVolumeToBeFilled()
            
        case 5:
            topSlabInterior?.totalVolToBeFilled = floatValue
        default:
            break
        }
        
    }
    
    func setCrossGirderPorousVolume() {
        guard let crossGirderVolume = crossGirder?.volumeOfACrossGirder, let porosity = crossGirder?.porosity else {
            return
        }
        let volume = crossGirderVolume*porosity
        crossGirder?.porousVolume = volume
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 0)])
        setCrossGirderNetVolume()
    }
    
    func setCrossGirderNetVolume() {
        guard let porousVolume = crossGirder?.porousVolume, let porousVolFilled = crossGirder?.pcOfPorousVolFilled else {
            return
        }
        let netVoulme = porousVolume*porousVolFilled
        crossGirder?.netVolumeToBeFilled = netVoulme
        collectionView?.reloadItems(at: [IndexPath(item: 4, section: 0)])
        setCrossGirderTotalVolumeToBeFilled()
    }
    
    func setCrossGirderTotalVolumeToBeFilled() {
        guard let netVolume = crossGirder?.netVolumeToBeFilled,
              let noOfGirders = inventory.data?.crossGirder?.noOfCrossGirders else {
            return
        }
        let totalVolume = netVolume*Float(noOfGirders)
        crossGirder?.totalVolToBeFilled = totalVolume
        collectionView?.reloadItems(at: [IndexPath(item: 5, section: 0)])
    }
}

//MARK: Section 1 - Top Slab (Interior)
extension Step7Form {
    func setValuesForSectin1(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            topSlabInterior?.volumeOfTopSlab = floatValue
            setTopSlabPorousVolume()
        case 1:
            topSlabInterior?.porosity = floatValue
            setTopSlabPorousVolume()
        case 2:
            topSlabInterior?.porousVolume = floatValue
            setTopSlabNetVolume()
        case 3:
            topSlabInterior?.pcOfPorousVolFilled = floatValue
            setTopSlabNetVolume()
            
        case 4:
            topSlabInterior?.netVolumeToBeFilled = floatValue
            setTopSlabTotalVolumeToBeFilled()
            
        case 5:
            topSlabInterior?.totalVolToBeFilled = floatValue
        default:
            break
        }
        
    }
    
    func setTopSlabPorousVolume() {
        guard let volume = topSlabInterior?.volumeOfTopSlab, let porosity = topSlabInterior?.porosity else {
            return
        }
        let porousVolume = volume*porosity
        topSlabInterior?.porousVolume = porousVolume
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 1)])
        setTopSlabNetVolume()
    }
    
    func setTopSlabNetVolume() {
        guard let porousVolume = topSlabInterior?.porousVolume, let porousVolFilled = topSlabInterior?.pcOfPorousVolFilled else {
            return
        }
        let netVoulme = porousVolume*porousVolFilled
        topSlabInterior?.netVolumeToBeFilled = netVoulme
        collectionView?.reloadItems(at: [IndexPath(item: 4, section: 1)])
        setTopSlabTotalVolumeToBeFilled()
    }
    
    func setTopSlabTotalVolumeToBeFilled() {
        guard let netVolume = topSlabInterior?.netVolumeToBeFilled,
              let noOfSpan = inventory.data?.noOfSpan else {
            return
        }
        let totalVolume = netVolume*Float(noOfSpan)
        topSlabInterior?.totalVolToBeFilled = totalVolume
        collectionView?.reloadItems(at: [IndexPath(item: 5, section: 1)])
    }
}

//MARK: Section 2 - Top Slab (Cantilever)
extension Step7Form {
    func setValuesForSectin2(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            topSlabCantilever?.volumeOfTopSlab = floatValue
            setTopSlabCPorousVolume()
        case 1:
            topSlabCantilever?.porosity = floatValue
            setTopSlabCPorousVolume()
        case 2:
            topSlabCantilever?.porousVolume = floatValue
            setTopSlabCNetVolume()
        case 3:
            topSlabCantilever?.pcOfPorousVolFilled = floatValue
            setTopSlabCNetVolume()
            
        case 4:
            topSlabCantilever?.netVolumeToBeFilled = floatValue
            setTopSlabCTotalVolumeToBeFilled()
            
        case 5:
            topSlabCantilever?.totalVolToBeFilled = floatValue
        default:
            break
        }
        
    }
    
    func setTopSlabCPorousVolume() {
        guard let volume = topSlabCantilever?.volumeOfTopSlab, let porosity = topSlabCantilever?.porosity else {
            return
        }
        let porousVolume = volume*porosity
        topSlabCantilever?.porousVolume = porousVolume
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 2)])
        setTopSlabCNetVolume()
    }
    
    func setTopSlabCNetVolume() {
        guard let porousVolume = topSlabCantilever?.porousVolume, let porousVolFilled = topSlabCantilever?.pcOfPorousVolFilled else {
            return
        }
        let netVoulme = porousVolume*porousVolFilled
        topSlabCantilever?.netVolumeToBeFilled = netVoulme
        collectionView?.reloadItems(at: [IndexPath(item: 4, section: 2)])
        setTopSlabCTotalVolumeToBeFilled()
    }
    
    func setTopSlabCTotalVolumeToBeFilled() {
        guard let netVolume = topSlabCantilever?.netVolumeToBeFilled,
              let noOfSpan = inventory.data?.noOfSpan else {
            return
        }
        let totalVolume = netVolume*Float(noOfSpan)
        topSlabCantilever?.totalVolToBeFilled = totalVolume
        collectionView?.reloadItems(at: [IndexPath(item: 5, section: 2)])
    }
}
