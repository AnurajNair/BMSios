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
    var formData: Inventory
    private var collectionView: UICollectionView?

    init(formData: Inventory) {
        self.formData = formData
    }

    func populate(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Step1Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }

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
            cell.collectionFormElement.setupSwitcher(id: fieldNo, isOn: formData.statusIsActive, onValue: "Status", offValue: "Status")

        case 1:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Project Id", options: options , placeHolder: "Project Id")

        case 2:
            let options = [DropDownModel(id: 1, name: "NIBM"),
                           DropDownModel(id: 2, name: "Wakad")]
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "BUID", options: options , placeHolder: "BUID")

        case 3:
            let options = [DropDownModel(id: 1, name: "Open"),
                           DropDownModel(id: 2, name: "Pile"),
                           DropDownModel(id: 3, name: "Well")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfFoundation ?? 0 } ?? 0
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Foundation", options: options , placeHolder: "Type of Foundation", selectedIndex: selectedIndex)

        case 4:
            let options = [DropDownModel(id: 1, name: "Solid RCC Pier"),
                           DropDownModel(id: 2, name: "Hollow Box"),
                           DropDownModel(id: 3, name: "RCC Pier with Prestress Pier Cap")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfSubstructure ?? 0 } ?? 0

            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Sub-Structure", options: options , placeHolder: "Type of Sub-Structure", selectedIndex: selectedIndex)
        
        case 5:
            let options = [DropDownModel(id: 1, name: "RCC Solid Slab"),
                           DropDownModel(id: 2, name: "RCC T Girder"),
                           DropDownModel(id: 3, name: "PSC T Girder"),
                           DropDownModel(id: 4, name: "RCC box Girder"),
                           DropDownModel(id: 5, name: "RCC twin cell box girder"),
                           DropDownModel(id: 6, name: "PSC Box girder"),
                           DropDownModel(id: 7, name: "PSC twin celll box girder"),
                           DropDownModel(id: 8, name: "Steel Box Girder"),
                           DropDownModel(id: 9, name: "Steel T Girder")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfSuperstructure ?? 0 } ?? 0
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Super-Structure", options: options , placeHolder: "Type of Super-Structure", selectedIndex: selectedIndex)

        case 6:
            let options = [DropDownModel(id: 1, name: "Steel"),
                           DropDownModel(id: 2, name: "Neoprene"),
                           DropDownModel(id: 3, name: "POT PTFE"),
                           DropDownModel(id: 4, name: "Spherical"),
                           DropDownModel(id: 5, name: "Special")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfBearing ?? 0 } ?? 0

            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Bearing", options: options , placeHolder: "Type of Bearing", selectedIndex: selectedIndex)
        
        case 7:
            let options = [DropDownModel(id: 1, name: "Burried Joint"),
                           DropDownModel(id: 2, name: "Filler"),
                           DropDownModel(id: 1, name: "Strip seal"),
                           DropDownModel(id: 1, name: "modular"),
                           DropDownModel(id: 1, name: "Special")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfExpansionJoint ?? 0 } ?? 0

            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Expansion Joint", options: options , placeHolder: "Type of Expansion Joint", selectedIndex: selectedIndex)
        
        case 8:
            let options = [DropDownModel(id: 1, name: "RCC wearing"),
                           DropDownModel(id: 2, name: "BC"),
                           DropDownModel(id: 2, name: "BC with mastic")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfWearingCoars ?? 0 } ?? 0
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Wearing Coars", options: options, placeHolder: "Type of Wearing Coars", selectedIndex: selectedIndex)
        
        case 9:
            let options = [DropDownModel(id: 1, name: "Steel"),
                           DropDownModel(id: 2, name: "Hand rail - htype"),
                           DropDownModel(id: 2, name: "RCC railing with 2 tier"),
                           DropDownModel(id: 2, name: "RCC Railing with 3 tier"),
                           DropDownModel(id: 2, name: "RCC Crash barrier")]
            let selectedIndex = options.firstIndex { $0.id as? Int ?? -1 == formData.data?.typeOfRailing ?? 0 } ?? 0
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Railing", options: options , placeHolder: "Type of Railing", selectedIndex: selectedIndex)
        
        case 10:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "Length of Span", showFieldTitleByDefault: false, placeholderTitle: "Length of Span", fieldValue: formData.data?.lengthOfSpan.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 11:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "Width of Span", showFieldTitleByDefault: false, placeholderTitle: "Width of Span", fieldValue: formData.data?.widthOfSpan.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 12:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "no of main grider in a Span", showFieldTitleByDefault: false, placeholderTitle: "no of main grider in a Span", fieldValue: formData.data?.noOfMainGirderInASpan.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)
        
        case 13:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "no of bearing in span", showFieldTitleByDefault: false, placeholderTitle: "no of bearing in span", fieldValue: formData.data?.noOfBearingInSpan.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 14:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "no of pile", showFieldTitleByDefault: false, placeholderTitle: "no of pile", fieldValue: formData.data?.noOfPile.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)
        
        case 15:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "dia of pile", showFieldTitleByDefault: false, placeholderTitle: "dia of pile", fieldValue: formData.data?.diaOfPile.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)
        
        
        default:
            break
        }
        cell.collectionFormElement.delegate = self
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

extension Step1Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let item = item as? Bool else {
                return
            }
            formData.status = (item == true) ? Status.active.rawValue : Status.inActive.rawValue

        case 1:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.projectId = id

        case 2:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.buid = id

        case 3:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfFoundation = id

        case 4:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfSubstructure = id

        case 5:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfSuperstructure = id

        case 6:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfBearing = id
        
        case 7:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfExpansionJoint = id
        
        case 8:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfWearingCoars = id
        
        case 9:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfRailing = id
        
        case 10:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.lengthOfSpan = intValue

        case 11:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.widthOfSpan = intValue

        case 12:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfMainGirderInASpan = intValue

        case 13:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfBearingInSpan = intValue

        case 14:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfPile = intValue

        case 15:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.diaOfPile = intValue

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }
}
