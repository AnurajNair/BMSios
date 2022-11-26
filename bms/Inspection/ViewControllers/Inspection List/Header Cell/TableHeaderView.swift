//
//  TableHeaderView.swift
//  bms
//
//  Created by Naveed on 26/10/22.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {
    
 
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView(){
//        idLabel.frame.size.width = outerView.frame.size.width/4.4
    }

}
