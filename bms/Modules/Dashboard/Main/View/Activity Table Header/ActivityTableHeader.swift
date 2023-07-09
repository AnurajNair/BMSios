//
//  ActivityTableHeader.swift
//  bms
//
//  Created by Naveed on 08/12/22.
//

import UIKit

class ActivityTableHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var activityLabel: UILabel!
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statuslabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        let labelStyle = TextStyles.ListHeaderGreyTitle
        UILabel.style([(view: idLabel, style: labelStyle),
                       (view: authorLabel, style: labelStyle),
                       (view: activityLabel, style: labelStyle),
                       (view: dateLabel, style: labelStyle),
                       (view: timeLabel, style: labelStyle),
                       (view: statuslabel, style: labelStyle)])
    }

}
