//
//  FormElementTableViewCell.swift
//  bms
//
//  Created by Naveed on 20/10/22.
//

import UIKit

class FormElementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formElementView: ReusableFormElementView!
    @IBOutlet weak var topPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftPaddingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPaddingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Setup Functions
    func setupView(topPadding: CGFloat = 15.0, bottomPadding: CGFloat = 15.0, leftPadding: CGFloat = 16.0, rightPadding: CGFloat = 16.0) {
        
        self.topPaddingConstraint.constant = topPadding
        self.bottomPaddingConstraint.constant = bottomPadding
        self.leftPaddingConstraint.constant = leftPadding
        self.rightPaddingConstraint.constant = rightPadding
        
        self.layoutIfNeeded()
        
        self.selectionStyle = .none
        
    }
    
}

