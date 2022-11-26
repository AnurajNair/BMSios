//
//  ReusableFormCheckboxField.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit

@objc protocol TTReusableFormCheckboxFieldDelegate:class {
    @objc optional func checkboxSelected(_ selectedItems: Any)
    @objc optional func checkboxDeselected(_ selectedItems: Any)
}

class ReusableFormCheckboxField: UIView {
    
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var checkboxLabel: UITextView!
    
    weak var delegate: TTReusableFormCheckboxFieldDelegate?
    
    var id: Any = ""
    var isSelected:Bool = false {
        didSet {
            if isSelected {
                checkboxImage.image = UIImage(named: FormElementStyler.Checkbox.leftImageSelected)?.withRenderingMode(.alwaysTemplate)
            } else {
                checkboxImage.image = UIImage(named: FormElementStyler.Checkbox.leftImageDefault)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
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
        self.setupView()
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        self.checkboxLabel.font = FormElementStyler.Checkbox.font
        self.checkboxLabel.textColor = FormElementStyler.Checkbox.textColor
        self.checkboxLabel.dataDetectorTypes = .link
        self.checkboxImage.tintColor = FormElementStyler.Checkbox.tintColor
        
        self.isSelected = false
        
        let tapGestureRecognizer = Utils.getTapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    //MARK:- Update Functions
    
    func setupCheckboxField(id: Any = "",
                            fieldLabel: String = "",
                            isSelectedByDefault: Bool = true,
                            height:CGFloat = 30.0,
                            isEditable: Bool = true,
                            isUserInteractionEnabled : Bool = true) {
        
        self.id = id
        self.isSelected = isSelectedByDefault
        
        self.checkboxLabel.isEditable = false
        self.checkboxLabel.text = fieldLabel
        self.isUserInteractionEnabled = isEditable
        self.checkboxLabel.isUserInteractionEnabled = isUserInteractionEnabled
        
        self.checkboxLabel.textContainerInset = UIEdgeInsets.zero
        self.checkboxLabel.textContainer.lineFragmentPadding = 0.0
        
        self.frame.size.height = height
        self.layoutIfNeeded()
    }
    
    //MARK:- Action Functions
    
    @objc func viewTapped() {
        self.isSelected = !self.isSelected
        
        if self.isSelected {
            self.delegate?.checkboxSelected?(self.id)
        } else {
            self.delegate?.checkboxDeselected?(self.id)
        }
    }
    
    //MARK:- Helper Functions
    
    
    
    //MARK:- Handle Highlighting of View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let opacity: Float = 0.7
        self.toggleViewHighlight(opacity)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let opacity: Float = 1.0
        self.toggleViewHighlight(opacity)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let opacity: Float = 1.0
        self.toggleViewHighlight(opacity)
    }
    
    func toggleViewHighlight(_ opacity: Float) {
        self.layer.opacity = opacity
    }
    
}
