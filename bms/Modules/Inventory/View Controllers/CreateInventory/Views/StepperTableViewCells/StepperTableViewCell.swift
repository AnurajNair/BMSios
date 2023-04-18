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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveAndNextButton: UIButton!
    @IBOutlet weak var formCollectionView: UICollectionView!

    private var form: StepperTableViewCellFormProtocol?

    private lazy var formObjectDict = [Int: StepperTableViewCellFormProtocol]()
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    var onTapBack: (()->())?
    var onTapSaveAndNext: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup() {
        UIButton.style([(view: saveAndNextButton,
                         title: "Save & Next",
                         style: ButtonStyles.inverseBlackButton),
                        (view: backButton,
                         title: "Back",
                         style: ButtonStyles.inverseBlackButton)])
        formCollectionView.registerNib(FormCollectionViewCell.identifier)
        formCollectionView.registerReusableHeaderNibs([ReusableCollectionHeaderView.identifier])
    }

    override func prepareForReuse() {
        form = nil
    }

    func configureForStep(_ step: Int, inventory: Inventory, isFirst: Bool, isLast: Bool) {
        guard let form = getFormForStep(step, inventory: inventory) else {
            EmptyForm.shared.populate(collectionView: formCollectionView)
            formCollectionView.layoutIfNeeded()
            return
        }
        form.populate(collectionView: formCollectionView)
        formCollectionView.layoutIfNeeded()
        saveAndNextButton.setTitle(isLast ? "Save" : "Save & Next", for: .normal)
        backButton.isHidden = isFirst
    }

    private func getFormForStep( _ step: Int, inventory: Inventory) -> StepperTableViewCellFormProtocol? {
        if let form = formObjectDict[step] {
            return form
        }
    
        let form: StepperTableViewCellFormProtocol
        switch step {
        case 1:
            form = Step1Form(formData: inventory)
            
        case 2:
            form = Step2Form(inventory: inventory)
            
        case 3:
            form = Step3Form(inventory: inventory)
            
        case 4:
            form = Step4Form(inventory: inventory)
            
        case 5:
            form = Step5Form(inventory: inventory)

        case 6:
            form = Step6Form(inventory: inventory)
            
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
    @IBAction func backDidTap(_ sender: UIButton) {
        onTapBack?()
    }
    @IBAction func saveAndNextDidTap(_ sender: UIButton) {
        onTapSaveAndNext?()
    }
}

