//
//  Step10Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step10Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1
    let fields = ["In a span", "Total no. of water sprout"]

    var collectionView: UICollectionView?
    let inventory: Inventory

    private var waterSprout: WaterSprout? {
        inventory.data?.waterSprout
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

extension Step10Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fields.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        let fieldTitle = fields[indexPath.row]
        let fieldValue: String?
        let isFieldEditable = fieldNo == 0
        switch fieldNo {
        case 0:
            fieldValue = waterSprout?.inSpan.description
        case 1:
            fieldValue = waterSprout?.totalNo.description

        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)

        cell.collectionFormElement.delegate = self
        return cell
    }
}

extension Step10Form: UICollectionViewDelegate {
}

extension Step10Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

extension Step10Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            waterSprout?.inSpan = intValue
            inventory.data?.setTotalNoOfWaterSprout()
            collectionView?.reloadItems(at: [IndexPath(item: 1, section: 0)])
        case 1:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            waterSprout?.totalNo = intValue

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }
}
