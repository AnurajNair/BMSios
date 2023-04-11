//
//  InventoryListTableViewCell.swift
//  bms
//
//  Created by Sahil Ratnani on 08/04/23.
//

import UIKit

class InventoryListTableViewCell: UITableViewCell {
    class var identifier: String { return String(describing: self) }
    @IBOutlet weak var srNoLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var projectIdLabel: UILabel!
    @IBOutlet weak var buidLabel: UILabel!
    @IBOutlet weak var saveStatusLabel: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var bridgeIdLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var bridgeNameLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        let labelStyle = Styler.textStyle(font: UIFont.BMS.InterMedium.withSize(20), color: UIColor.BMS.bmsLabelGrey)
        UILabel.style([(view: srNoLabel, style: labelStyle),
                       (view: projectNameLabel, style: labelStyle),
                       (view: projectIdLabel, style: labelStyle),
                       (view: buidLabel, style: labelStyle),
                       (view: saveStatusLabel, style: labelStyle),
                       (view: saveStatusLabel, style: labelStyle),
                       (view: bridgeIdLabel, style: labelStyle),
                       (view: bridgeNameLabel, style: labelStyle)])
    }

    func configure(srNo: Int, data: InventoryListObj) {
        srNoLabel.text = srNo.description
        projectIdLabel.text = data.projectId.description
        projectNameLabel.text = data.projectName
        buidLabel.text = data.buid
        saveStatusLabel.text = data.saveStatus
        statusSwitch.isOn = data.status == "1"
        bridgeIdLabel.text = data.bridgeId.description
        bridgeNameLabel.text = data.bridgeName
    }

    @IBAction func editButtonDidTap(_ sender: UIButton) {
    }
    @IBAction func removeButtonDidTap(_ sender: UIButton) {
    }
    @IBAction func statusSwitchDidChange(_ sender: UISwitch) {
    }
}
