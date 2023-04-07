//
//  Step3Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step3Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1

    func populate(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Step3Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        switch fieldNo {
        case 0:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "Width")

        case 1:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "No. of Portion")

        case 2:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "Thickness")

        case 3:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "Area")

        case 4:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "Volume")
        
        default:
            break
        }
        return cell
    }

    
}

extension Step3Form: UICollectionViewDelegate {
}

extension Step3Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

