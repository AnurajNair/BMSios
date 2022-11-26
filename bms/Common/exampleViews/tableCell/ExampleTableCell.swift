//
//  ExampleTableCell.swift
//  bms
//
//  Created by Naveed on 20/10/22.
//

import UIKit

class ExampleTableCell: UITableViewCell {
    
 
    @IBOutlet weak var elementView: ReusableFormElementView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
     setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Setup Functions
    func setupView(topPadding: CGFloat = 15.0, bottomPadding: CGFloat = 15.0, leftPadding: CGFloat = 16.0, rightPadding: CGFloat = 16.0) {
        
        elementView.translatesAutoresizingMaskIntoConstraints =  false;

      //  self.layoutIfNeeded()
        
        self.selectionStyle = .none
        
    }
    
}

