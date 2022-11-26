//
//  ReusableFormSegmentedController.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//


import UIKit

protocol ReusableFormSegmentedControllerDelegate: class {
    func segmentedControlValueChanged(id: Any, selectedIndex: Int, selectedItem: Any)
}

class ReusableFormSegmentedController: UISegmentedControl {
    
    var id: Any = ""
    var items: [Any] = []
    weak var delegate: ReusableFormSegmentedControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        
        self.tintColor = FormElementStyler.SegmentedController.tintColor
        
        var attributes:[NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = FormElementStyler.SegmentedController.font
        attributes[NSAttributedString.Key.foregroundColor] = FormElementStyler.SegmentedController.textColor
        self.setTitleTextAttributes(attributes, for: .normal)
        
        attributes[NSAttributedString.Key.font] = FormElementStyler.SegmentedController.selectedFont
        attributes[NSAttributedString.Key.foregroundColor] = FormElementStyler.SegmentedController.selectedTextColor
        self.setTitleTextAttributes(attributes, for: .selected)
        
        self.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
    }
    
    //MARK:- Update Functions
    
    func setupSegmentedController(id:Any = "",
                                  items: [Any] = [],
                                  selectedIndex: Int = 0,
                                  isEditable: Bool = true) {
        
        self.id = id
        self.items = items
        self.isEnabled = isEditable
        
        for (index, item) in self.items.enumerated() {
            if let value = item as? String {
                self.insertSegment(withTitle: value, at: index, animated: false)
            } else if let value = item as? UIImage {
                self.insertSegment(with: value, at: index, animated: false)
            }
        }
        
        self.selectedSegmentIndex = selectedIndex
        
    }
    
    @objc func segmentedControlValueChanged()
    {
        self.delegate?.segmentedControlValueChanged(id: self.id, selectedIndex: self.selectedSegmentIndex, selectedItem: self.items[self.selectedSegmentIndex])
    }
    
}

