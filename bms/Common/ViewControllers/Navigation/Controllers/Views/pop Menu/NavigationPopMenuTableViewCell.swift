//
//  NavigationPopMenuTableViewCell.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class NavigationPopMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var optionNameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        self.optionNameLabel.font = UIFont.SORT.MontserratRegular.withSize(12.0)
        self.optionNameLabel.textColor = UIColor.SORT.fontBlack.withAlphaComponent(0.75)
    }
    
    //MARK:- Update Functions
    
    func updateOptionName(_ name: String) {
        self.optionNameLabel.text = name
    }
    
}
