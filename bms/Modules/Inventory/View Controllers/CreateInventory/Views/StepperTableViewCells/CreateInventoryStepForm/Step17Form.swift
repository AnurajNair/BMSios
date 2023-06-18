//
//  Step17Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step17Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1

    let fields = Array(["": ["Place at 50 mm distance"],
                        "Cross girder": ["No. of nipple along length of the girder",
                                                "No. of nipple across depth of the girder", "Porous Volume",
                                                "Total no. of nipples in side of the girder", "Total no. of nipples in a girder",
                                         "Total no. of nipples in the bridge"],
                        "Top Slab (grouting to be done from the top)": ["No. of nipples across the width of Slab",
                                                  "No. of nipples along the length of slab",
                                                  "Total no. of nipples in a slab of a span",
                                                  "Total no. of nipples in the bridge", "Pier Cap", "Total nipples"]])

    func populate(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Step17Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableCollectionHeaderView.identifier, for: indexPath) as? ReusableCollectionHeaderView else {
            return UICollectionReusableView(frame: .zero)
        }
        
        headerView.titleLbl.text = fields[indexPath.section].key
        return headerView
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        fields.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields[section].value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        let fieldTitle = fields[indexPath.section].value[fieldNo]
        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, textFieldStyling: TTTextFieldStyler.blueStyle)

        return cell
    }
}

extension Step17Form: UICollectionViewDelegate {
}

extension Step17Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

