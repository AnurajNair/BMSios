//
//  ReusableSelectableCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit

class ReusableSelectableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectionIcon: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectionIconDefault = ""
    var selectionIconSelected = ""
    var nameLabelFontDefault: UIFont = UIFont.systemFont(ofSize: 12.0)
    var nameLabelFontSelected: UIFont = UIFont.boldSystemFont(ofSize: 12.0)
    var nameLabelColorDefault: UIColor = UIColor.black
    var nameLabelColorSelected: UIColor = UIColor.blue
    
    override var isSelected: Bool {
        didSet {
            setSelected(isSelected, animated: false)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        
    }
    
    //MARK:- Update Functions
    
    func updateData(nameLabelValue:String,
                    nameLabelFontDefaultValue: UIFont = FormElementStyler.Options.fieldDefaultFont,
                    nameLabelFontSelectedValue: UIFont = FormElementStyler.Options.fieldSelectedFont,
                    nameLabelColorDefaultValue: UIColor = FormElementStyler.Options.fieldDefaultTextColor,
                    nameLabelColorSelectedValue: UIColor = FormElementStyler.Options.fieldSelectedTextColor,
                    iconValue:String = "",
                    selectionIconDefaultValue:String = "",
                    selectionIconSelectedValue:String = "") {
        
        self.nameLabelFontSelected = nameLabelFontSelectedValue
        self.nameLabelFontDefault = nameLabelFontDefaultValue
        self.nameLabelColorSelected = nameLabelColorSelectedValue
        self.nameLabelColorDefault = nameLabelColorDefaultValue
        
        self.updateNameLabel(nameLabelValue)
        
        self.updateLeftImageView(iconValue)
        
        self.updateSelectionIcon(selectionIconDefaultValue, selectionIconSelectedValue: selectionIconSelectedValue)
    }
    
    
    
    func updateNameLabel(_ value:String="") {
        self.nameLabel.text = value
    }
    
    func updateLeftImageView(_ value:String="") {
        self.leftImageView.image = !value.isEmpty ? UIImage(named: value) : nil
        self.toggleVisibilityForView(self.leftImageView, text: [value])
    }
    
    func updateSelectionIcon(_ selectionIconDefaultValue:String="", selectionIconSelectedValue: String = "") {
        
        self.selectionIcon.tintColor = FormElementStyler.Options.leftImageTintColor
        self.selectionIconDefault = selectionIconDefaultValue
        self.selectionIconSelected = selectionIconSelectedValue
        self.toggleVisibilityForView(self.selectionIcon, text: [selectionIconDefaultValue, selectionIconSelectedValue])
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        
        if selected {
            self.nameLabel.font = self.nameLabelFontSelected
            self.nameLabel.textColor = self.nameLabelColorSelected
            self.selectionIcon.image = !selectionIconSelected.isEmpty ? UIImage(named: selectionIconSelected)?.withRenderingMode(FormElementStyler.Options.leftImageRenderingMode) : nil
        } else {
            self.nameLabel.font = self.nameLabelFontDefault
            self.nameLabel.textColor = self.nameLabelColorDefault
            self.selectionIcon.image = !selectionIconDefault.isEmpty ? UIImage(named: selectionIconDefault)?.withRenderingMode(FormElementStyler.Options.leftImageRenderingMode) : nil
        }
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


