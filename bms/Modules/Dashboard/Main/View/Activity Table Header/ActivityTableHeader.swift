//
//  ActivityTableHeader.swift
//  bms
//
//  Created by Naveed on 08/12/22.
//

import UIKit

class ActivityTableHeader: UITableViewHeaderFooterView {
    
 

    
    
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
