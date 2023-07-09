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
    var style: FormElementStyler.formDropDownStyle?
    var delegate: ReusableDropDownDelegate?
    var options: [DropDownModel] = []
    var placeHolder = ""
    var selectedItem: DropDownModel? {
        guard let selectedIndex = dropDown.indexForSelectedRow else { return nil }
        return options[selectedIndex]
    }
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
        self.options = options
        dropDown.dataSource = options.compactMap { $0.name }
        dropDown.anchorView = dropDownView
        applyStyle(style: style)
        self.placeHolder = placeHolder
        if let index = selectedItemIndex, index < options.count {
            setTitle(text: options[index].displayableValue)
            dropDown.selectRow(at: index)
        } else {
            setTitle(text: placeHolder, isPlaceholder: true)
        }
        dropDown.selectionAction = { [weak self] index, displayValue in
            self?.makeSelection(option: options[index])
        }
    }

    func setTitle(text: String, isPlaceholder: Bool = false) {
        titleLabel.text = text
        titleLabel.textColor = isPlaceholder ? UIColor.BMS.black.withAlphaComponent(0.5) : style?.titleTextColor ?? .black
    }

    func makeSelection(option: DropDownModel) {
        setTitle(text: option.displayableValue)
        delegate?.didSelectOption(option: option)
    }

    private func applyStyle(style: FormElementStyler.formDropDownStyle) {
        self.style = style
        titleLabel.font = style.titleFont
        dropDownView.backgroundColor = style.backgroundColor
        if let edges = style.fieldBorderEdges {
            dropDownView.addBorders(edges: edges, color: UIColor.BMS.textBorderGrey)
        }
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
