//
//  Step1Cell.swift
//  bms
//
//  Created by Sahil Ratnani on 04/04/23.
//

import Foundation
import UIKit
import SwiftyMenu
import DropDown

class Step1Cell: UITableViewCell {
    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var timelineViewLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var dropdown1: ReusableDropDown!
    @IBOutlet weak var dropdown2: SwiftyMenu!
    @IBOutlet weak var projectIdDropdown: ReusableDropDown!
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setup() {
        dropdown1.translatesAutoresizingMaskIntoConstraints = false

        dropdown1.setupDropDown(options: [DropDownModel(id: 1, name: "NIBM"), DropDownModel(id: 2, name: "Wakad")], placeHolder: "Project ID", textColor: UIColor.BMS.black)

        
        
        setupDropDown(options: [DropDownModel(id: 1, name: "Hadapsar"), DropDownModel(id: 2, name: "KP")], placeHolder: "Project ID", textColor: UIColor.BMS.black)
        
        
        
        projectIdDropdown.translatesAutoresizingMaskIntoConstraints = false

        projectIdDropdown.setupDropDown(options: [DropDownModel(id: 1, name: "Hinjewadi"), DropDownModel(id: 2, name: "baner")], placeHolder: "Project ID", textColor: UIColor.BMS.black)

        
//        projectIdDropdown.dropDown.backgroundColor = .yellow
        let dropdown = DropDown()
        dropdown.dataSource = ["NIBM", "WAKAD"]

        dropdown.anchorView = dropdown2
        
        
    }

    func setupDropDown(options:[DropDownModel]?,placeHolder:String?,textColor:UIColor?){
        self.dropdown2.items = options ?? []
        var codeMenuAttributes = SwiftyMenuAttributes()
        codeMenuAttributes.placeHolderStyle = .value(text: placeHolder ?? "", textColor: textColor ?? UIColor.BMS.black)
        codeMenuAttributes.name = placeHolder
        codeMenuAttributes.roundCorners = .all(radius: 5)
//        codeMenuAttributes.height  = .value(height: 100)
        codeMenuAttributes.border = .value(color: UIColor.BMS.separatorGray, width: 0.8)
        self.dropdown2.configure(with: codeMenuAttributes)

    }
}
