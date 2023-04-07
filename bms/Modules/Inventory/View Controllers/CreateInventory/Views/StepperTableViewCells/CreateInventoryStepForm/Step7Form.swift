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

    let fields = Array(["Cross Girder": ["Volume of a Cross Girder",
                                         "Porosity", "Porous Volume",
                                         "% of porous volume filled by grouting",
                                         "Net volume to be filled in a girder by grout",
                                         "Net volume to be filled in all girder in the bridge by grout"],
                        "Top Slab (Interior)": ["Volume of a Top Slab",
                                                "Porosity", "Porous Volume",
                                                "% of porous volume filled by grouting",
                                                "Net volume to be filled in a girder by grout",
                                                "Net volume to be filled in all girder in the bridge by grout"],
                        "Top Slab (Cantilever)": ["Total area of a top slab in the bridge",
                                                  "Estimated % of damaged area",
                                                  "Damaged area",
                                                  "Total are for PMC mortar treatment"]])

    func populate(collectionView: UICollectionView) {
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
        _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: fieldTitle)

        return cell
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

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

