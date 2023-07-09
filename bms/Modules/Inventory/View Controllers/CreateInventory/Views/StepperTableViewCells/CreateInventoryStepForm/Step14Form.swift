//
//  Step14Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step14Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1
    let fields = Array(["Main Girder": ["No of main girders to be wrapped",
                                         "Bottom area of main girder in a span", "side area of main girder in a span",
                                        "Total area of main girder in the bridge ( only upstreama and downstream girders and 30%)"]])

    let inventory: Inventory
    var collectionView: UICollectionView?

    private var mainGirder: Wrapping.MainGirder? {
        inventory.data?.wrapping?.mainGirder
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

extension Step14Form: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard kind == UICollectionView.elementKindSectionHeader,
                  let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableCollectionHeaderView.identifier, for: indexPath) as? ReusableCollectionHeaderView else {
                return UICollectionReusableView(frame: .zero)
            }
            
            headerView.titleLbl.text = fields[indexPath.section].key
            return headerView
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
        let fieldValue: String?
        let isFieldEditable = fieldNo == 0
        switch fieldNo {
        case 0:
            fieldValue = mainGirder?.noOfGirders.description
        case 1:
            fieldValue = mainGirder?.bottomArea.description
        case 2:
            fieldValue = mainGirder?.sideArea.description
        case 3:
            fieldValue = mainGirder?.totalArea.description
        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)

        cell.collectionFormElement.delegate = self
        return cell

    }

    
}

extension Step14Form: UICollectionViewDelegate {
}

extension Step14Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

extension Step14Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            mainGirder?.noOfGirders = intValue
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 0)])

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }
}
