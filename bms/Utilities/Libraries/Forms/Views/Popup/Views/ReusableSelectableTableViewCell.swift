//
//  ReusableSelectableTableViewCell.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class ReusableSelectableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rightAccessoryIcon: UIImageView!
    
    var rightAccessoryDefault = ""
    var rightAccessorySelected = ""
    var nameLabelFontDefault: UIFont = UIFont.systemFont(ofSize: 12.0)
    var nameLabelFontSelected: UIFont = UIFont.boldSystemFont(ofSize: 12.0)
    var nameLabelColorDefault: UIColor = UIColor.black
    var nameLabelColorSelected: UIColor = UIColor.blue
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.nameLabel.font = self.nameLabelFontSelected
            self.nameLabel.textColor = self.nameLabelColorSelected
            self.rightAccessoryIcon.image = !rightAccessorySelected.isEmpty ? UIImage(named: rightAccessorySelected)?.withRenderingMode(FormElementStyler.Popup.rightImageRenderingMode) : nil
        } else {
            self.nameLabel.font = self.nameLabelFontDefault
            self.nameLabel.textColor = self.nameLabelColorDefault
            self.rightAccessoryIcon.image = !rightAccessoryDefault.isEmpty ? UIImage(named: rightAccessoryDefault)?.withRenderingMode(FormElementStyler.Popup.rightImageRenderingMode) : nil
        }
    }
    
    //MARK:- Setup functions
    
    func setupView() {
        self.leadingConstraint.constant = 18.0
        self.selectionStyle = .none
    }
    
    
    func updateData(nameLabelValue:String,
                    nameLabelFontDefaultValue: UIFont = FormElementStyler.Popup.innerFieldFontDefault,
                    nameLabelFontSelectedValue: UIFont = FormElementStyler.Popup.innerFieldFontSelected,
                    nameLabelColorDefaultValue: UIColor = FormElementStyler.Popup.innerFieldTextColorDefault,
                    nameLabelColorSelectedValue: UIColor = FormElementStyler.Popup.innerFieldTextColorSelected,
                    iconValue:String = "",
                    rightAccessoryDefaultValue:String = "",
                    rightAccessorySelectedValue:String = "") {
        
        self.nameLabelFontSelected = nameLabelFontSelectedValue
        self.nameLabelFontDefault = nameLabelFontDefaultValue
        self.nameLabelColorSelected = nameLabelColorSelectedValue
        self.nameLabelColorDefault = nameLabelColorDefaultValue
        
        self.updateNameLabel(nameLabelValue)
        
        self.updateIconImageView(iconValue)
        
        self.updateSelectionRightIcon(rightAccessoryDefaultValue, rightAccessorySelectedValue: rightAccessorySelectedValue)
    }
    
    //MARK:- Update Functions
    
    func updateNameLabel(_ value:String="") {
        self.nameLabel.text = value
    }
    
    func updateIconImageView(_ value:String="") {
        self.iconImageView.image = UIImage(named: value)
        self.toggleVisibilityForView(self.iconImageView, text: [value])
    }
    
    func updateSelectionRightIcon(_ rightAccessoryDefaultValue:String="", rightAccessorySelectedValue: String = "") {
        
        self.rightAccessoryIcon.tintColor = FormElementStyler.Popup.rightImageTintColor
        self.rightAccessoryDefault = rightAccessoryDefaultValue
        self.rightAccessorySelected = rightAccessorySelectedValue
        self.toggleVisibilityForView(self.rightAccessoryIcon, text: [rightAccessoryDefaultValue, rightAccessorySelectedValue])
    }
    
    //MARK:- Helper Functions
    
    func toggleVisibilityForView(_ view: UIView, text: [String]) {
        
        for value in text {
            if value.isEmpty {
                view.isHidden = true
            } else {
                view.isHidden = false
                break
            }
        }
    }
    
}

