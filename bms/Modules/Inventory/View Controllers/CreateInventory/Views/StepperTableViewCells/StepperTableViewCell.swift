//
//  StepperTableViewCell.swift
//  bms
//
//  Created by Sahil Ratnani on 04/04/23.
//

import Foundation
import UIKit
import SwiftyMenu
import DropDown

protocol StepperTableViewCellFormProtocol {
    func populate(collectionView: UICollectionView)
}

class StepperTableViewCell: UITableViewCell {

    typealias sectionDict = ([String: [String]])

    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var timelineViewLeadingConstant: NSLayoutConstraint!
    
    @IBOutlet weak var formCollectionView: UICollectionView!

    private var form: StepperTableViewCellFormProtocol?

    private lazy var formObjectDict = [Int: StepperTableViewCellFormProtocol]()
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup() {
        formCollectionView.registerNib(FormCollectionViewCell.identifier)
        formCollectionView.registerReusableHeaderNibs([ReusableCollectionHeaderView.identifier])
    }

    override func prepareForReuse() {
        form = nil
    }

    func configureForStep(_ step: Int) {
        guard let form = getFormForStep(step) else {
            EmptyForm.shared.populate(collectionView: formCollectionView)
            formCollectionView.layoutIfNeeded()
            return
        }
        form.populate(collectionView: formCollectionView)
        formCollectionView.layoutIfNeeded()
    }

    private func getFormForStep( _ step: Int) -> StepperTableViewCellFormProtocol? {
        if let form = formObjectDict[step] {
            return form
        }
    
        let form: StepperTableViewCellFormProtocol
        switch step {
        case 1:
            form = Step1Form()
            
        case 2:
            form = Step2Form()
            
        case 3:
            form = Step3Form()
            
        case 4:
            form = Step4Form()
            
        case 5:
            form = Step5Form()

        case 6:
            form = Step6Form()
            
        case 7:
            form = Step7Form()

        case 8:
            form = Step8Form()

        case 9:
            form = Step9Form()

        case 10:
            form = Step10Form()

        case 11:
            form = Step11Form()

        case 12:
            form = Step12Form()

        case 13:
            form = Step13Form()

        case 14:
            form = Step14Form()

        case 15:
            form = Step15Form()

        case 16:
            form = Step16Form()

        case 17:
            form = Step17Form()


        default:
            return nil
        }
        formObjectDict[step] = form
        return form
    }
}

