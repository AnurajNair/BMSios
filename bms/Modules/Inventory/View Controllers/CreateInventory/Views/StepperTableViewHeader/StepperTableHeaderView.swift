//
//  StepperTableHeaderView.swift
//  bms
//
//  Created by Sahil Ratnani on 03/04/23.
//

import UIKit

class StepperTableHeaderView: UITableViewHeaderFooterView {
    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var timelineView: UIView!
    @IBOutlet weak var stepNoLbl: UILabel!
    @IBOutlet weak var stepTitleLbl: UILabel!

    var onHeaderTap: ((Int)->())?

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

    func setupView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(headerDidTap(_:)))
        self.addGestureRecognizer(tap)
    }

    func configHeader(step: Int, title: String, isExpanded: Bool) {
        tag = step
        stepNoLbl.setAsRounded(cornerRadius: stepNoLbl.frame.width/2)
        stepNoLbl.backgroundColor = isExpanded ? UIColor.BMS.green : UIColor.BMS.gray
        self.contentView.backgroundColor = isExpanded ? UIColor.BMS.dashboardCard : UIColor.BMS.clear

        stepNoLbl.text = step.description
        stepTitleLbl.text = title
    }

    @objc func headerDidTap(_ sender: UITapGestureRecognizer) {
        onHeaderTap?(tag)
    }
}
