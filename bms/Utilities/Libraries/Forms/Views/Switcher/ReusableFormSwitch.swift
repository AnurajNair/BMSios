//
//  ReusableFormSwitch.swift
//  bms
//
//  Created by Naveed on 18/10/22.
//

import UIKit

protocol ReusableFormSwitchDelegate: AnyObject {
    func switchStateChanged(id: Any, isOn: Bool)
}

class ReusableFormSwitch: UIView {
    
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var switcherLabel: UILabel!
    
    weak var delegate: ReusableFormSwitchDelegate?
    
    var offText = ""
    var onText = ""
    var id: Any = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
        initFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fromNib()
        initFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK:- Setup Functions
    func setupView() {
        
        self.switcherLabel.font = FormElementStyler.Switcher.font
        self.switcherLabel.textColor = FormElementStyler.Switcher.textColor
        
        self.switcher.isOn = false
        self.switcher.onTintColor = FormElementStyler.Switcher.tintColor
        self.switcher.addTarget(self, action: #selector(switchStateChanged), for: .valueChanged)
        
    }
    
    func setupSwitcher(id:Any = "",
                       isOn: Bool = false,
                       onValue: String = "",
                       offValue: String = "",
                       isEditable: Bool = true) {
        
        self.id = id
        self.switcher.isOn = isOn
        self.onText = onValue
        self.offText = offValue
        
        handleStateChange(isOn)
        
        self.switcher.isEnabled = isEditable
        
    }
    
    //MARK:- Action Functions
    @objc func switchStateChanged(_ sender: UISwitch) {
        handleStateChange(sender.isOn)
        self.delegate?.switchStateChanged(id: self.id, isOn: sender.isOn)
    }
    
    //MARK:- Helper Functions
    func handleStateChange(_ isOn: Bool) {
        if isOn {
            self.switcherLabel.text = self.onText
        } else {
            self.switcherLabel.text = self.offText
        }
        
    }
    
    
}

