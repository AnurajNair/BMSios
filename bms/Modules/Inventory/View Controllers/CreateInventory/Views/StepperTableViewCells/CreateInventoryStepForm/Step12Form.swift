//
//  Step12Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step12Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1
    let fields = ["No of expansion joints", "Length of a expansion joint", "Total length of expansion joint"]

      var collectionView: UICollectionView?
      let inventory: Inventory

      private var expansionJoint: ExpansionJoint? {
          inventory.data?.expansionJoint
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

extension Step12Form: UICollectionViewDataSource {
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
        switch fieldNo {
        case 0:
            fieldValue = expansionJoint?.noOfJoints.description
        case 1:
            fieldValue = expansionJoint?.length.description
        case 2:
            fieldValue = expansionJoint?.totalLength.description

        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: false, textFieldStyling: TTTextFieldStyler.blueStyle)

        return cell
    }

    
}

extension Step12Form: UICollectionViewDelegate {
}

extension Step12Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

