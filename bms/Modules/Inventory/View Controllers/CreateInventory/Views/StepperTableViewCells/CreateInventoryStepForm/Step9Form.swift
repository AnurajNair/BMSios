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

    let fields = Array(["Bottom of Main Girder": ["Area of bottom of main girder",
                                                   "Total area of botton of main giders in the bridge"],
                         "Side of Main Girder": ["Total side area of all main girders in the bridge",
                                                 "Estimated % of damageed area",
                                                 "Damageed area"],
                         "Cross Girder": ["Total area of all side girders in the bridge",
                                          "Estimated % of damageed area",
                                          "Damageed area"],
                         "Top Slab (Interior)": ["Total area of top slab in the bridge",
                                                 "Estimated % of damageed area",
                                                 "Damageed area"],
                         "Top Slab (Cantilever)": ["Total area of top slab in the bridge",
                                                   "Estimated % of damageed area",
                                                   "Damageed area",
                                                   "Total area of PMC mortar treatment"]])

    func populate(collectionView: UICollectionView) {
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

extension Step9Form: UICollectionViewDelegate {
}

extension Step9Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

