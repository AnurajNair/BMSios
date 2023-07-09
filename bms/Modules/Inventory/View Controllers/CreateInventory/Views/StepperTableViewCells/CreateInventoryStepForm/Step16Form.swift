//
//  Step16Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step16Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1

    let fields = [(sectionName: "Main Girder", fields: ["Place at 50 mm distance"]),
                  (sectionName: "Side of Main girder", fields: ["No. of nipple along length of the girder",
                                                                "No. of nipple along depth of the girder", "Porous Volume",
                                                                "Total no. of nipples in side of the girder"]),
                  (sectionName: "Bottom of Main girder", fields: ["No. of nipple",
                                                                  "Total no. of nipples in a  girder",
                                                                  "Grouting to be done to % of all girders/area of girder",
                                                                  "Total no. of nipples in the bridge"])]

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

extension Step16Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableCollectionHeaderView.identifier, for: indexPath) as? ReusableCollectionHeaderView else {
            return UICollectionReusableView(frame: .zero)
        }
        
        headerView.titleLbl.text = fields[indexPath.section].sectionName
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        fields.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields[section].fields.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        let fieldTitle = fields[indexPath.section].fields[fieldNo]
        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, textFieldStyling: TTTextFieldStyler.blueStyle)

        return cell
    }
}

extension Step16Form: UICollectionViewDelegate {
}

extension Step16Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

