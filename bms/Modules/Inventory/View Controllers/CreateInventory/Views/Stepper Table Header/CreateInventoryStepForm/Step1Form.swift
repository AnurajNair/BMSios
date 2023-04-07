//
//  Step1Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step1Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 3

    func populate(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Step1Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        16
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        switch fieldNo {
        case 0:
            cell.collectionFormElement.setupSwitcher(id: fieldNo, onValue: "Status", offValue: "Status")

        case 1:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Project Id")

        case 2:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "BUID")

        case 3:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Foundation")

        case 4:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Sub-Structure")
        
        case 5:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Super-Structure")

        case 6:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Bearing")
        
        case 7:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Expansion Joint")
        
        case 8:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Wearing Coars")
        
        case 9:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, options: options , placeHolder: "Type of Railing")
        
        case 10:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, placeholderTitle: "Length of Span")

        case 11:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "Width of Span")
        
        case 12:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, placeholderTitle: "no of main grider in a Span")
        
        case 13:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, placeholderTitle: "no of bearing in span")

        case 14:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "no of pile")
        
        case 15:
           _ = cell.collectionFormElement.setupTextField(id: fieldNo , placeholderTitle: "dia of pile")
        
        
        default:
            break
        }
        return cell
    }

    
}

extension Step1Form: UICollectionViewDelegate {
}

extension Step1Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

