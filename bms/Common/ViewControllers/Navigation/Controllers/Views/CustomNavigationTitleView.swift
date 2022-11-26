//
//  CustomNavigationTitleView.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class CustomNavigationTitleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
       
    }
    
}
