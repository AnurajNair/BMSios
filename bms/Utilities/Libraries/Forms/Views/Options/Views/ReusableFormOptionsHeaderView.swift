//
//  ReusableFormOptionsHeaderView.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit

class ReusableFormOptionsHeaderView: UIView {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var selectClearButton: UIButton!
    
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
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        self.messageLabel.font = FormElementStyler.Options.fieldHeaderFont
        self.messageLabel.textColor = FormElementStyler.Options.fieldHeaderTextColor
        
        self.selectClearButton.titleLabel?.font = FormElementStyler.Options.fieldHeaderSelectAllFont
        self.selectClearButton.setTitleColor(FormElementStyler.Options.fieldHeaderSelectAllTextColor, for: UIControl.State.normal)
        
    }
    
    func setMessage(message:String = "") {
        self.messageLabel.text = message
        self.messageLabel.isHidden = message.isEmpty
    }
    
}

