//
//  Step5Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step5Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1
    private let fields = ["Width", "Depth", "Length", "Area of Bottom", "Area of Side", "Volume", "No. of Cross Grider"]
    var collectionView: UICollectionView?
    let inventory: Inventory

    private var crossGirder: CrossGirder? {
        inventory.data?.crossGirder
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

extension Step5Form: UICollectionViewDataSource {
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
        let isFieldEditable = fieldNo == 0 || fieldNo == 1 || fieldNo == 2 || fieldNo == 6
        switch fieldNo {
        case 0:
            fieldValue = crossGirder?.width.description
        case 1:
            fieldValue = crossGirder?.depth.description
        case 2:
            fieldValue = crossGirder?.length.description
        case 3:
            fieldValue = crossGirder?.areaOfBottom.description
        case 4:
            fieldValue = crossGirder?.areaOfSide.description
        case 5:
            fieldValue = crossGirder?.volume.description
        case 6:
            fieldValue = crossGirder?.noOfCrossGirders.description

        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)
        cell.collectionFormElement.delegate = self
        return cell
    }

    
}

extension Step5Form: UICollectionViewDelegate {
}

extension Step5Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

extension Step5Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            crossGirder?.width = floatValue
            setAreaOfBottom()
            setVolume()
        case 1:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            crossGirder?.depth = floatValue
            setAreaOfSide()
            setVolume()
        case 2:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            crossGirder?.length = floatValue
            setAreaOfBottom()
            setAreaOfSide()
            setVolume()
        case 3:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            crossGirder?.areaOfBottom = floatValue

        case 4:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            crossGirder?.areaOfSide = floatValue
            inventory.data?.setPMCMortarTotalAreaOfCrossGirder()

        case 5:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            crossGirder?.volume = floatValue
        case 6:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            crossGirder?.noOfCrossGirders = intValue
            inventory.data?.setPMCMortarTotalAreaOfCrossGirder()

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }

    func setAreaOfBottom() {
        guard let length = crossGirder?.length, let width = crossGirder?.width else {
             return
        }
        let area = Float(length)*width
        crossGirder?.areaOfBottom = area
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 0)])
    }

    func setAreaOfSide() {
        guard let length = crossGirder?.length, let depth = crossGirder?.depth else {
             return
        }
        let area = Float(length)*depth
        crossGirder?.areaOfSide = area
        inventory.data?.setPMCMortarTotalAreaOfCrossGirder()
        collectionView?.reloadItems(at: [IndexPath(item: 4, section: 0)])
    }

    func setVolume() {
        guard let length = crossGirder?.length, let width = crossGirder?.width, let depth = crossGirder?.depth else {
             return
        }
        let volume = Float(length)*Float(width)*depth
        crossGirder?.volume = volume
        inventory.data?.polymerModifiedCementGrout?.crossGirders?.volumeOfACrossGirder = volume
        collectionView?.reloadItems(at: [IndexPath(item: 5, section: 0)])
        
    }
}
