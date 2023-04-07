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
    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var timelineViewLeadingConstant: NSLayoutConstraint!
    
    @IBOutlet weak var formCollectionView: UICollectionView!

    private var form: StepperTableViewCellFormProtocol?

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
    }

    func configureForStep(_ step: Int) {
        guard let form = form else {
            form = getFormForStep(step)
            form?.populate(collectionView: formCollectionView)
            return
        }
        form.populate(collectionView: formCollectionView)
    }

    private func getFormForStep( _ step: Int) -> StepperTableViewCellFormProtocol? {
        switch step {
        case 1:
            return Step1Form()
        default:
            return nil
        }
    }
}

