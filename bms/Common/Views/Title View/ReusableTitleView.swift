//
//  ReusableTitleView.swift
//  bms
//
//  Created by Naveed on 25/10/22.
//

import UIKit

class ReusableTitleView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleImageView: UIImageView!
    //MARK:- Default functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        self.setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK:- Setup functions
    func setupView() {
        
    }

}
