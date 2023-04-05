//
//  ReusableDropDown.swift
//  bms
//
//  Created by Naveed on 02/12/22.
//

import UIKit
import DropDown

class ReusableDropDown: UIView {
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    private lazy var dropDown = DropDown()

    var placeHolder = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
       _ = initFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = initFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(DropdownDidTap(_ :)))
        self.addGestureRecognizer(tapGesture)
        dropDownView.addBorders(edges: .bottom, color: UIColor.BMS.textBorderGrey)
        dropDownView.backgroundColor = UIColor.BMS.dashboardCard
    }

    func setupDropDown(options: [DropDownModel], placeHolder: String = "", selectedItemIndex: Int? = nil) {
        dropDown.dataSource = options.compactMap { $0.name }
        dropDown.anchorView = dropDownView
        self.placeHolder = placeHolder
        if let index = selectedItemIndex {
            titleLabel.text = options[index].displayableValue
        } else {
            titleLabel.text = placeHolder
        }
        dropDown.selectionAction = { [weak self] _, displayValue in
            self?.titleLabel.text = displayValue
        }
    }

    @objc func DropdownDidTap(_ sender: UIButton) {
        if dropDown.isFocused {
            dropDown.hide()
        }  else {
            dropDown.show()
        }
    }
}
