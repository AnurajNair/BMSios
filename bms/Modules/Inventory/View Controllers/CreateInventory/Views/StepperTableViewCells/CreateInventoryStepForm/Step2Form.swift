//
//  Step2Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step2Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 3
    private let fields = ["Depth", "Width", "Area Bottom", "Area Side", "Volume"]
    
    var collectionView: UICollectionView?
    let inventory: Inventory

    private var mainGirder: MainGirder? {
        inventory.data?.mainGirder
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

extension Step2Form: UICollectionViewDataSource {
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
        let isFieldEditable = fieldNo == 0 || fieldNo == 1
        switch fieldNo {
        case 0:
            fieldValue = mainGirder?.depth.description
        case 1:
            fieldValue = mainGirder?.width.description
        case 2:
            fieldValue = mainGirder?.areaBottom.description
        case 3:
            fieldValue = mainGirder?.areaSide.description
        case 4:
            fieldValue = mainGirder?.volume.description
        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)
        cell.collectionFormElement.delegate = self
        return cell
    }

    
}

extension Step2Form: UICollectionViewDelegate {
}

extension Step2Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

extension Step2Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.depth = floatValue
            setAreaOfSide()
            setVolume()
        case 1:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.width = floatValue
            setAreaOfBottom()
            setVolume()
        case 2:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.areaBottom = floatValue

        case 3:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.areaSide = floatValue

        case 4:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.volume = floatValue

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }

    func setAreaOfBottom() {
        guard let length = inventory.data?.lengthOfSpan, let width = mainGirder?.width else {
             return
        }
        let area = Float(length)*width
        mainGirder?.areaBottom = area
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 0)])
    }

    func setAreaOfSide() {
        guard let length = inventory.data?.lengthOfSpan, let depth = mainGirder?.depth else {
             return
        }
        let area = Float(length)*depth
        mainGirder?.areaSide = area
        collectionView?.reloadItems(at: [IndexPath(item: 3, section: 0)])
    }

    func setVolume() {
        guard let length = inventory.data?.lengthOfSpan, let width = mainGirder?.width, let depth = mainGirder?.depth else {
             return
        }
        let area = Float(length)*Float(width)*depth
        mainGirder?.volume = area
        collectionView?.reloadItems(at: [IndexPath(item: 4, section: 0)])
    }
}
