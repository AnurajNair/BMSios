//
//  ActivityTableViewCell.swift
//  bms
//
//  Created by Naveed on 08/12/22.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var activityNameLabel: UILabel!
    
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statuslabel: UILabel!
    
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(activity:ActivityModel){
        
        self.idLabel.text = activity.id
        self.authorLabel.text = activity.author
        self.activityNameLabel.text = activity.activity
        self.dateLabel.text = activity.date
        self.timeLabel.text = activity.time
        self.statuslabel.text = activity.status
        
    }
    
}
