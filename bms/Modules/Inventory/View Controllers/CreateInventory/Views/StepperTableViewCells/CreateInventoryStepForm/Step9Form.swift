//
//  Step9Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step9Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1

    let sections = [(sectionName: "Bottom of Main Girder", fields: ["Area of bottom of main girder",
                                                                  "Total area of botton of main giders in the bridge"]),
                  (sectionName:"Side of Main Girder", fields: ["Total side area of all main girders in the bridge",
                                                       "Estimated % of damageed area",
                                                       "Damageed area"]),
                  (sectionName: "Cross Girder", fields: ["Total area of all side girders in the bridge",
                                                         "Estimated % of damageed area",
                                                         "Damageed area"]),
                  (sectionName: "Top Slab (Interior)", fields: ["Total area of top slab in the bridge",
                                                                "Estimated % of damageed area",
                                                                "Damageed area"]),
                  (sectionName: "Top Slab (Cantilever)", fields: ["Total area of top slab in the bridge",
                                                                  "Estimated % of damageed area",
                                                                  "Damageed area",
                                                                  "Total area of PMC mortar treatment"])]
    var collectionView: UICollectionView?
    let inventory: Inventory

    private var bottomOfMainGirder: PmcMortarTreatment.BottomOfMainGirder? {
        inventory.data?.pmcMortarTreatment?.bottomOfMainGirder
    }
    private var sideOfMainGirder: PmcMortarTreatment.SideOfMainGirder? {
        inventory.data?.pmcMortarTreatment?.sideOfMainGirder
    }
    private var crossGirder: PmcMortarTreatment.CrossGirder? {
        inventory.data?.pmcMortarTreatment?.crossGirder
    }
    private var topSlabInterior: PmcMortarTreatment.TopSlabInterior? {
        inventory.data?.pmcMortarTreatment?.topSlabInterior
    }
    private var topSlabCantilever: PmcMortarTreatment.TopSlabCantilever? {
        inventory.data?.pmcMortarTreatment?.topSlabCantilever
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

extension Step9Form: UICollectionViewDataSource {
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
        let isFieldEditable = (indexPath.section != 0) && fieldNo == 1
        switch indexPath.section {
        case 0:
            fieldValue = fieldValueForSection0(row: fieldNo)
        case 1:
            fieldValue = fieldValueForSection1(row: fieldNo)
        case 2:
            fieldValue = fieldValueForSection2(row: fieldNo)
        case 3:
            fieldValue = fieldValueForSection3(row: fieldNo)
        case 4:
            fieldValue = fieldValueForSection4(row: fieldNo)
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
            return bottomOfMainGirder?.areaOfBottom.description
        case 1:
            return bottomOfMainGirder?.totalArea.description

        default:
            return nil
        }
    }

    func fieldValueForSection1(row: Int) -> String? {
        switch row {
        case 0:
            return sideOfMainGirder?.totalArea.description
        case 1:
            return sideOfMainGirder?.estimatedPcOfDamagedArea.description
        case 2:
            return sideOfMainGirder?.damagedArea.description

        default:
            return nil
        }
    }

    func fieldValueForSection2(row: Int) -> String? {
        switch row {
        case 0:
            return crossGirder?.totalArea.description
        case 1:
            return crossGirder?.estimatedPcOfDamagedArea.description
        case 2:
            return crossGirder?.damagedArea.description

        default:
            return nil
        }
    }

    func fieldValueForSection3(row: Int) -> String? {
        switch row {
        case 0:
            return topSlabInterior?.totalArea.description
        case 1:
            return topSlabInterior?.estimatedPcOfDamagedArea.description
        case 2:
            return topSlabInterior?.damagedArea.description

        default:
            return nil
        }
    }

    func fieldValueForSection4(row: Int) -> String? {
        switch row {
        case 0:
            return topSlabCantilever?.totalArea.description
        case 1:
            return topSlabCantilever?.estimatedPcOfDamagedArea.description
        case 2:
            return topSlabCantilever?.damagedArea.description
        case 3:
            return inventory.data?.pmcMortarTreatment?.totalAreaForPmcMortarTreatment.description

        default:
            return nil
        }
    }
}

extension Step9Form: UICollectionViewDelegate {
}

extension Step9Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

extension Step9Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        guard let index = index as? IndexPath else { return }
        switch index.section {
        case 0:
            setValuesForSectin0(row: index.row, item: item)
        case 1:
            setValuesForSectin1(row: index.row, item: item)
        case 2:
            setValuesForSectin2(row: index.row, item: item)
        case 3:
            setValuesForSectin3(row: index.row, item: item)
        case 4:
            setValuesForSectin4(row: index.row, item: item)

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }
}

//MARK: Section 0 - Bottom of Main Girder
extension Step9Form {
    func setValuesForSectin0(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            bottomOfMainGirder?.areaOfBottom = floatValue
            inventory.data?.setPMCMortarTotalAreaOfBottomOfMainGirder()
            collectionView?.reloadItems(at: [IndexPath(item: 1, section: 0)])
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
        case 1:
            bottomOfMainGirder?.totalArea = floatValue
            inventory.data?.setTotalAreaForPmcMortarTreatment()
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])

        default:
            break
        }
        
    }
}

//MARK: Section 1 - Side of Main Girder
extension Step9Form {
    func setValuesForSectin1(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            sideOfMainGirder?.totalArea = floatValue
            setSideOfGirderDamagedArea()
        case 1:
            sideOfMainGirder?.estimatedPcOfDamagedArea = floatValue
            setSideOfGirderDamagedArea()
        case 2:
            sideOfMainGirder?.damagedArea = floatValue
            inventory.data?.setTotalAreaForPmcMortarTreatment()
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
        default:
            break
        }
        
    }
    
    func setSideOfGirderDamagedArea() {
        inventory.data?.setPMCMortarSideDamagedArea()
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 1)])
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
    }
}

//MARK: Section 2 - Cross Girder
extension Step9Form {
    func setValuesForSectin2(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            crossGirder?.totalArea = floatValue
            setCrossGirderDamagedArea()
        case 1:
            crossGirder?.estimatedPcOfDamagedArea = floatValue
            setCrossGirderDamagedArea()
        case 2:
            crossGirder?.damagedArea = floatValue
            inventory.data?.setTotalAreaForPmcMortarTreatment()
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
        default:
            break
        }
        
    }
    
    func setCrossGirderDamagedArea() {
        inventory.data?.setPMCMortarSideDamagedArea()
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 2)])
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
    }
}

//MARK: Section 3 - Top Slab (Interior)
extension Step9Form {
    func setValuesForSectin3(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            topSlabInterior?.totalArea = floatValue
            setTopSlabDamagedArea()
        case 1:
            topSlabInterior?.estimatedPcOfDamagedArea = floatValue
            setTopSlabDamagedArea()
        case 2:
            topSlabInterior?.damagedArea = floatValue
            inventory.data?.setTotalAreaForPmcMortarTreatment()
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
        default:
            break
        }
        
    }
    
    func setTopSlabDamagedArea() {
        inventory.data?.setPMCMortarTopSlabIDamagedArea()
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 2)])
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
    }
}

//MARK: Section 4 - Top Slab (Cantilever)
extension Step9Form {
    func setValuesForSectin4(row: Int, item: Any) {
        guard let value = (item as? String), let floatValue = Float(value) else {
            return
        }
        switch row {
        case 0:
            topSlabCantilever?.totalArea = floatValue
            setTopSlabCDamagedArea()
        case 1:
            topSlabCantilever?.estimatedPcOfDamagedArea = floatValue
            setTopSlabCDamagedArea()
        case 2:
            topSlabCantilever?.damagedArea = floatValue
            inventory.data?.setTotalAreaForPmcMortarTreatment()
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
        case 3:
            inventory.data?.pmcMortarTreatment?.totalAreaForPmcMortarTreatment = floatValue

        default:
            break
        }
        
    }
    
    func setTopSlabCDamagedArea() {
        inventory.data?.setPMCMortarTopSlabCDamagedArea()
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 2)])
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 4)])
    }
}
