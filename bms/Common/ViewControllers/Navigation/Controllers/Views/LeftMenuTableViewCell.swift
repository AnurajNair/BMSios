//
//  LeftMenuTableViewCell.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class LeftMenuItemTableViewCell: UITableViewCell {

    @IBOutlet var menuName: UILabel!
    @IBOutlet var menuDescription: UILabel!
    @IBOutlet var menuImage: UIImageView!
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.menuName.font = UIFont.BMS.InterRegular.withSize(13)
        self.menuName.textColor = UIColor.BMS.fontBlack
        
        self.menuDescription.font = UIFont.BMS.InterRegular.withSize(10.0)
        self.menuDescription.textColor = UIColor.BMS.fontBlack.withAlphaComponent(0.4)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Setup Functions
    func configureCell(image: String, name: String, description: String = "version 1.0") {
        self.menuImage.image = UIImage(named: image)
        self.menuName.text = name
        
        if !description.isEmpty {
            self.menuDescription.isHidden = false
            self.menuDescription.text = description
        } else {
            self.menuDescription.isHidden = true
        }
    }
    
}
