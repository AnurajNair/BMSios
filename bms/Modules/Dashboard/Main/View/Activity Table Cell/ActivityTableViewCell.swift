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
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    var onEyeButtonTap: (()->())?

    override func awakeFromNib() {
        super.awakeFromNib()
       setupView()
    }

    func setupView(){
        let labelStyle = TextStyles.ListItemBlackTitle
        UILabel.style([(view: idLabel, style: labelStyle),
                       (view: authorLabel, style: labelStyle),
                       (view: activityNameLabel, style: labelStyle),
                       (view: dateLabel, style: labelStyle),
                       (view: timeLabel, style: labelStyle)])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configCell(srNo: Int, activity:Activity){
        self.idLabel.text = srNo.description
        self.authorLabel.text = activity.publisherName
        self.activityNameLabel.text = activity.activityDesc
        self.dateLabel.text = activity.publishedDate
        self.timeLabel.text = activity.publishedTime
    }

    
    @IBAction func eyeButtonDidTap(_ sender: Any) {
        onEyeButtonTap?()
    }
}
