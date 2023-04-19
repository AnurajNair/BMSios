//
//  Step4Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step4Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1
    private let fields = [ "Width", "No. of Portion", "Thickness", "Area", "Volume"]
    var collectionView: UICollectionView?

    let inventory: Inventory
    var topSlabCantilever: TopSlabCantilever? {
        inventory.data?.topSlabCantilever
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

extension Step4Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        let fieldTitle = fields[indexPath.row]
        let fieldValue: String?
        let isFieldEditable = fieldNo == 0 || fieldNo == 1 || fieldNo == 2
        switch fieldNo {
        case 0:
            fieldValue = topSlabCantilever?.width.description
        case 1:
            fieldValue = topSlabCantilever?.noOfPortions.description
        case 2:
            fieldValue = topSlabCantilever?.thickness.description
        case 3:
            fieldValue = topSlabCantilever?.area.description
        case 4:
            fieldValue = topSlabCantilever?.volume.description
        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)
        cell.collectionFormElement.delegate = self
        return cell
    }

    
}

extension Step4Form: UICollectionViewDelegate {
}

extension Step4Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

extension Step4Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            topSlabCantilever?.width = floatValue
            setArea()
            setVolume()
        case 1:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            topSlabCantilever?.noOfPortions = floatValue
            setVolume()
        case 2:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            topSlabCantilever?.thickness = floatValue
            setVolume()
        case 3:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            topSlabCantilever?.area = floatValue

        case 4:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            topSlabCantilever?.volume = floatValue

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }

    func setArea() {
        guard let length = inventory.data?.lengthOfSpan, let width = topSlabCantilever?.width else {
             return
        }
        let area = Float(length)*width
        topSlabCantilever?.area = area
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 0)])
    }

    func setVolume() {
        guard let length = inventory.data?.lengthOfSpan, let width = topSlabCantilever?.width, let thickness = topSlabCantilever?.thickness, let noOfPortion = topSlabCantilever?.noOfPortions else {
             return
        }
        let volume = Float(length)*Float(width)*thickness*noOfPortion
        topSlabCantilever?.volume = volume
        inventory.data?.polymerModifiedCementGrout?.topSlabCantilever?.volumeOfTopSlab = volume
        collectionView?.reloadItems(at: [IndexPath(item: 4, section: 0)])
    }
}
