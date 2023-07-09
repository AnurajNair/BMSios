//
//  Step6Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class Step6Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 1
    let fields = Array(["Main Girder": ["Volume of a Girder",
                                         "Porosity", "Porous Volume",
                                         "% of porous volume filled by grouting",
                                        "Grouting to be done to % of all girders/area of girders",
                                         "Net volume to be filled in all girder in the bridge by grout",
                                        "TSpecific gravity of grout",
                                        "Total volume to be filled in all girder of the bridge by grout"]])

    var collectionView: UICollectionView?
    let inventory: Inventory

    private var mainGirder: LowViscosityGrout.MainGirder? {
        inventory.data?.lowViscosityGrout?.mainGirder
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

extension Step6Form: UICollectionViewDataSource {
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
        let isFieldEditable = fieldNo == 0 || fieldNo == 1 ||  fieldNo == 3 || fieldNo == 4 || fieldNo == 6
        switch fieldNo {
        case 0:
            fieldValue = mainGirder?.volume.description
        case 1:
            fieldValue = mainGirder?.porosity.description
        case 2:
            fieldValue = mainGirder?.porousVolume.description
        case 3:
            fieldValue = mainGirder?.pcOfPorousVolFilled.description
        case 4:
            fieldValue = mainGirder?.groutingToBeDonePc.description
        case 5:
            fieldValue = mainGirder?.netVolumeToBeFilled.description
        case 6:
            fieldValue = mainGirder?.specificGravity.description
        case 7:
            fieldValue = mainGirder?.totalVolToBeFilled.description

        default:
            fieldValue = nil
        }

        _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: fieldTitle, showFieldTitleByDefault: false, placeholderTitle: fieldTitle, fieldValue: fieldValue ?? "", isEditable: isFieldEditable, textFieldStyling: TTTextFieldStyler.blueStyle)
        cell.collectionFormElement.delegate = self
        return cell
    }

    
}

extension Step6Form: UICollectionViewDelegate {
}

extension Step6Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 90)
    }
}

extension Step6Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.volume = floatValue
            setPorousVolume()
        case 1:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.porosity = floatValue
            setPorousVolume()
        case 2:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.porousVolume = floatValue
        case 3:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.pcOfPorousVolFilled = floatValue
            setNetVolume()
        case 4:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.groutingToBeDonePc = floatValue
            setTotalVolumeToBeFilled()
        case 5:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.netVolumeToBeFilled = floatValue
        case 6:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.specificGravity = floatValue
            setTotalVolumeToBeFilledInLtrs()
        case 7:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            mainGirder?.totalVolToBeFilled = floatValue

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }

    func setPorousVolume() {
        guard let mainGirderVolume = mainGirder?.volume, let porosity = mainGirder?.porosity else {
             return
        }
        let volume = mainGirderVolume*porosity
        mainGirder?.porousVolume = volume
        collectionView?.reloadItems(at: [IndexPath(item: 2, section: 0)])
    }

    func setNetVolume() {
        guard let porousVolume = mainGirder?.porousVolume, let porousVolFilled = mainGirder?.pcOfPorousVolFilled else {
            return
        }
        let netVoulme = porousVolume*porousVolFilled
        mainGirder?.netVolumeToBeFilled = netVoulme
        collectionView?.reloadItems(at: [IndexPath(item: 5, section: 0)])
        setTotalVolumeToBeFilled()
    }

    func setTotalVolumeToBeFilled() {
        guard let netVolume = mainGirder?.netVolumeToBeFilled,
              let groutingToBeDone = mainGirder?.groutingToBeDonePc,
              let noOfSpan = inventory.data?.noOfSpan,
              let noOfGirdersInSpan = inventory.data?.noOfMainGirderInASpan else {
             return
        }
        let totalVolume = netVolume*groutingToBeDone*Float(noOfSpan)*Float(noOfGirdersInSpan)
        mainGirder?.totalVolToBeFilled = totalVolume
        collectionView?.reloadItems(at: [IndexPath(item: 7, section: 0)])
        setTotalVolumeToBeFilledInLtrs()
    }

    func setTotalVolumeToBeFilledInLtrs() {
        guard let totalVolume = mainGirder?.totalVolToBeFilled,
              let gravity = mainGirder?.specificGravity else {
             return
        }
        let totalVolumeInLtr = totalVolume*gravity
        mainGirder?.totalVolumeInLtr = totalVolumeInLtr
    }
}
