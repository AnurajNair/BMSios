//
//  TableHeaderView.swift
//  bms
//
//  Created by Naveed on 26/10/22.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var srNoLabel: UILabel!
    
    @IBOutlet weak var buidLabel: UILabel!
    
    @IBOutlet weak var inspectionLabel: UILabel!
    @IBOutlet weak var bridgeNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startInspectionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView(){
        let labelStyle = Styler.textStyle(font: UIFont.BMS.InterSemiBold.withSize(20), color: UIColor.BMS.bmsLabelGrey)
        UILabel.style([(view: srNoLabel, style: labelStyle),
                       (view: buidLabel, style: labelStyle),
                       (view: inspectionLabel, style: labelStyle),
                       (view: bridgeNameLabel, style: labelStyle),
                       (view: startDateLabel, style: labelStyle),
                       (view: endDateLabel, style: labelStyle),
                       (view: statusLabel, style: labelStyle),
                       (view: startInspectionLabel, style: labelStyle)])
    }

}
