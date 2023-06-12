//
//  InventoryListHeaderView.swift
//  bms
//
//  Created by Sahil Ratnani on 08/04/23.
//

import Foundation
import UIKit

class InventoryListHeaderView: UITableViewHeaderFooterView {
    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var srNoLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var buidLabel: UILabel!
    @IBOutlet weak var saveStatusLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var bridgeIdLabel: UILabel!
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var bridgeNameLabel: UILabel!
    @IBOutlet weak var removeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        let labelStyle = TextStyles.ListHeaderGreyTitle
        UILabel.style([(view: srNoLabel, style: labelStyle),
                       (view: projectNameLabel, style: labelStyle),
                       (view: projectIdLabel, style: labelStyle),
                       (view: buidLabel, style: labelStyle),
                       (view: saveStatusLabel, style: labelStyle),
                       (view: saveStatusLabel, style: labelStyle),
                       (view: statusLabel, style: labelStyle),
                       (view: bridgeIdLabel, style: labelStyle),
                       (view: editLabel, style: labelStyle),
                       (view: bridgeNameLabel, style: labelStyle),
                       (view: removeLabel, style: labelStyle)])
    }
}
