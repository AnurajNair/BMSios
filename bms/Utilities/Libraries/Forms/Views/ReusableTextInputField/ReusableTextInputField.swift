//
//  ReusableTextInputField.swift
//  bms
//
//  Created by Naveed on 20/10/22.
//

import UIKit

class ReusableTextInputField: UIView{
    
    @IBOutlet weak var reusableTextInputLabel: UILabel!
    @IBOutlet weak var reusableTextInputFieldView: UIView!
    
    @IBOutlet weak var reusableTextInputErrorIcon: UIImageView!
    
    @IBOutlet weak var reusableTextInputErrorLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
        initFromNib()
//        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fromNib()
        initFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        if self.frameWidth != self.frame.size.width {
//            self.frameWidth = self.frame.size.width
//            self.updateHeight()
//        }
    }
}
