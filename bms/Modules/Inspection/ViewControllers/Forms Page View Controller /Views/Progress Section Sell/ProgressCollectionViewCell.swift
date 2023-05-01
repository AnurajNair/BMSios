//
//  ProgressCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 03/11/22.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var stepNoLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        stepNoLabel.setAsRounded(cornerRadius: stepNoLabel.frame.width/2)

        UILabel.style([(view: progressLabel, style: Styler.textStyle(font: UIFont.BMS.InterRegular.withSize(17),color: UIColor.BMS.fontBlack))])
    }

    func configHeader(stepNo: Int, title: String,  isActive: Bool) {
        stepNoLabel.backgroundColor = isActive ? UIColor.BMS.green : UIColor.BMS.gray
        self.contentView.backgroundColor = isActive ? UIColor.BMS.dashboardCard : UIColor.BMS.clear

        progressLabel.text = title
        stepNoLabel.text = stepNo.description
    }
}
