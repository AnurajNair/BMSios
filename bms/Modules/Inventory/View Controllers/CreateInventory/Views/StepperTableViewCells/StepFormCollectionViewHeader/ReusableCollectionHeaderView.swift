//
//  RusableCollectionHeaderView.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit

class ReusableCollectionHeaderView: UICollectionReusableView {
    class var identifier: String { return String(describing: self) }
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        UILabel.style([(view: titleLbl, style: Styler.textStyle(font: UIFont.BMS.InterRegular.withSize(17),color: UIColor.BMS.fontBlack))])
    }
}
