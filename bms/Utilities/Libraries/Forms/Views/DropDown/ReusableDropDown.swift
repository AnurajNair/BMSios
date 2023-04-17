//
//  ReusableDropDown.swift
//  bms
//
//  Created by Naveed on 02/12/22.
//

import UIKit
import DropDown

protocol ReusableDropDownDelegate {
    func didSelectOption(option: DropDownModel)
}

class ReusableDropDown: UIView {
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var iconImageView: UIImageView!
    private lazy var dropDown = DropDown()

    var delegate: ReusableDropDownDelegate?
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
        applyStyle(style: TTDropDownStyle.defaultStyle)
    }

    func setupDropDown(options: [DropDownModel], placeHolder: String = "", selectedItemIndex: Int? = nil, style: FormElementStyler.formDropDownStyle = TTDropDownStyle.defaultStyle) {
        dropDown.dataSource = options.compactMap { $0.name }
        dropDown.anchorView = dropDownView
        self.placeHolder = placeHolder
        if let index = selectedItemIndex, index < options.count {
            titleLabel.text = options[index].displayableValue
            dropDown.selectRow(at: index)
        } else {
            titleLabel.text = placeHolder
        }
        dropDown.selectionAction = { [weak self] index, displayValue in
            self?.makeSelection(option: options[index])
        }
    }

    func makeSelection(option: DropDownModel) {
        titleLabel.text = option.displayableValue
        delegate?.didSelectOption(option: option)
    }

    private func applyStyle(style: FormElementStyler.formDropDownStyle) {
        titleLabel.font = style.titleFont
        titleLabel.textColor = style.titleTextColor
        dropDownView.backgroundColor = style.backgroundColor
        dropDownView.addBorders(edges: .bottom, color: UIColor.BMS.textBorderGrey)
        if let icon = style.icon {
            iconImageView.image = UIImage(named: icon)
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
