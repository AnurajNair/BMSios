//
//  ReusbaleFormPopupField.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit
import SwiftValidator

@objc protocol ReusablePopupFieldSelectionViewDelegate: class {
    @objc optional func saveButtonTapped(_ selectedItems: [Any])
    @objc optional func itemSelected(_ selectedItems: Any)
    @objc optional func itemDeselected(_ selectedItems: Any)
}

@objc protocol ReusableFormPopupFieldDelegate: class {
    @objc optional func popupFieldViewDidChangeHeight(_ popupFieldView:ReusableFormPopupField, height: CGFloat)
    @objc optional func popupFieldViewDidBeginEditing(_ popupFieldView:ReusableFormPopupField)
    @objc optional func popupFieldViewDidEndEditing(_ popupFieldView:ReusableFormPopupField, selectedItems: [Any])
}

class ReusableFormPopupField: UIView {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftText: UILabel!
    
    weak var delegate: ReusableFormPopupFieldDelegate?
    
    enum FieldSubtype {
        case normal
        case detail
        case custompopup
        case customdetail
        
        func getTransitionType() -> Navigate.TransitionType {
            switch self {
            case .detail, .customdetail:
                return .push
            default:
                return .popup
            }
        }
    }
    
    var fieldSubtype:FieldSubtype = .normal
    var id: Any = ""
    var popupValueData:[Any] = []
    var selectedItems:[Any] = []
    var fieldTitleValue: String = ""
    var minHeight: CGFloat = 0.0
    var minCount: Int = 0
    var maxCount: Int = 0
    var isEditable: Bool = true
    var currentValidator = Validator()
    var currentValidationRules: [Rule] = []
    var currentErrorLabel: UILabel = UILabel()
    var destinationView: Any? = nil
    var destinationData: [String: Any] = [:]
    var frameWidth:CGFloat = 0.0
    var allowsDeselect: Bool = true
    
    var text:String! = "" {
        didSet {
            self.textView.text = self.text
        }
    }
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frameWidth != self.frame.size.width {
            self.frameWidth = self.frame.size.width
            self.updateHeight(true)
        }
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        
        self.leftImageView.isHidden = true
        self.rightImageView.isHidden = true
        self.leftText.isHidden = true

        self.leftText.font = FormElementStyler.Popup.font
        self.leftText.textColor = FormElementStyler.Popup.textColor
        self.textView.font = FormElementStyler.Popup.font
        self.textView.textColor = FormElementStyler.Popup.textColor
        self.textView.dataDetectorTypes = .link
        self.textView.placeHolderLeftMargin = 0.0
        self.textView.contentInset = UIEdgeInsets.zero
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.bounces = false
        self.textView.isEditable = false
        self.textView.shouldDetectTouches = false
        self.textView.backgroundColor = FormElementStyler.Popup.backgroundColor
        
        self.frameWidth = self.frame.size.width
        
    }
    
    func styleDefaultBorder() {
        self.addBorders(edges: FormElementStyler.Popup.fieldBorderEdges, color: FormElementStyler.Popup.fieldBorderNormalColor, thickness: FormElementStyler.Popup.fieldBorderThickness)
    }
    
    func setupPopupField(id:Any = "",
                         fieldSubtype: FieldSubtype = .normal,
                         fieldValue: String? = nil,
                         destinationView: Any? = nil, //Pass a UIView Controller or a NavigationRoute.ScreenType
        destinationData: [String: Any] = [:],
        destinationTitle: String = "",
        placeholderTitle: String = "",
        errorLabel: UILabel = UILabel(),
        validationRules: [Rule] = [],
        validator: Validator? = nil,
        leftImage:String = "",
        leftText : String = "",
        rightImage:String = "",
        minHeight: CGFloat = 0.0,
        maxHeight: CGFloat = 0.0,
        minCount:Int = 0,
        maxCount:Int = 0,
        popUpValues: [Any] = [],
        selectedItems: [Any] = [],
        isEditable: Bool = true,
        showBorder: Bool = true,
        isTappable: Bool = true,
        allowsDeselect: Bool = true) {
        
        if showBorder {
            self.styleDefaultBorder()
        }
        
        if !leftImage.isEmpty {
            self.leftImageView.image = UIImage(named: leftImage)
            self.leftImageView.isHidden = false
        }
        
        if !rightImage.isEmpty {
            self.rightImageView.image = UIImage(named: rightImage)
            self.rightImageView.isHidden = false
        }
        
        if !leftText.isEmpty{
            self.leftText.text = leftText
            self.leftText.isHidden = false
        }
        
        self.fieldSubtype = fieldSubtype
        self.id = id
        self.fieldTitleValue = destinationTitle
        self.minHeight = minHeight
        self.minCount = minCount
        self.maxCount = maxCount
        
        self.popupValueData = popUpValues
        self.selectedItems = selectedItems
        
        if self.isDefaultPopupView() {
            self.text = self.updateFieldValue()
        } else if fieldValue != nil {
            self.text = fieldValue!
        }
        
        self.textView.placeHolder = placeholderTitle
        self.textView.minHeight = minHeight
        self.textView.maxHeight = maxHeight
        
        if validator != nil {
            self.currentValidator = validator!
        }
        
        self.isEditable = isEditable
        self.allowsDeselect = allowsDeselect
        
        self.currentValidationRules = validationRules
        self.currentErrorLabel = errorLabel
        
        self.addValidationRules()
        
        self.destinationView = destinationView
        self.destinationData = destinationData
        
        if isTappable {
            let tapGesture = Utils.getTapGestureRecognizer()
            tapGesture.addTarget(self, action: #selector(tappedView))
            self.addGestureRecognizer(tapGesture)
            
            let imageTapGesture = Utils.getTapGestureRecognizer()
            imageTapGesture.addTarget(self, action: #selector(tappedView))
            self.addGestureRecognizer(tapGesture)
        }
        
        self.updateHeight()
        
    }
    
    //MARK:- Field Functions
    func fieldEndUpdateText(displayText: String) {
        self.text = displayText
        self.updateHeight(true)
    }
    
    //MARK:- Public Validation Functions
    func addValidationRules(_ rules: [Rule] = []) {
        self.currentValidationRules.append(contentsOf: rules)
        self.currentValidator.registerField(self.textView, errorLabel: self.currentErrorLabel, rules: self.currentValidationRules)
    }
    
    //MARK:- Update Functions
    
    func updateHeight(_ shouldDelegate: Bool = false) {
        self.textView.setNeedsLayout()
        self.textView.layoutIfNeeded()
        let height = getViewHeight(self.textView.frame.size.height)
        self.frame.size.height = height
        
        if shouldDelegate {
            self.delegate?.popupFieldViewDidChangeHeight?(self, height: height)
        }
        
    }
    
    //MARK:- Action Functions
    
    @objc func tappedView() {
        
        let destinationViewController: Any? = isDefaultPopupView() ? getPopupViewController() : self.destinationView
        
        if destinationViewController != nil {
            if destinationViewController is NavigationRoute.ScreenType {
                
                var vcData:[String:Any] = ["values": self.popupValueData, "selectedItems":self.selectedItems, "minCount" : self.minCount, "maxCount" : self.maxCount, "isEditable" : self.isEditable, "delegate": self]
                
//                vcData.merge(self.destinationData)
                vcData.merge(self.destinationData) { (current, _) in current }
                
                Navigate.routeUserToScreen(screenType: destinationViewController as! NavigationRoute.ScreenType, transitionType: self.fieldSubtype.getTransitionType(), data: vcData, screenTitle: self.fieldTitleValue)
                
            }
                
            else if destinationViewController is UIViewController {
                Navigate.transitionToScreen(destinationViewController: destinationViewController as! UIViewController, transitionType: self.fieldSubtype.getTransitionType())
            }
            
            self.delegate?.popupFieldViewDidBeginEditing?(self)
        }
        
    }
    
    //MARK:- Helper Functions
    
    func isDefaultPopupView() -> Bool {
        return self.fieldSubtype == .normal || self.fieldSubtype == .detail
    }
    
    func getViewHeight(_ height: CGFloat) -> CGFloat {
        
        var value:CGFloat = 0
        
        if height > self.minHeight {
            value = height
        }
        else {
            value = self.minHeight
        }
        
        return value
    }
    
    //MARK:- Normal and Detail Popupview Controller Functions
    
    func updateFieldValue() -> String {
        
        var fieldValue:[String] = []
        
        for value in self.selectedItems as! [Int] {
            fieldValue.append(self.popupValueData[value] as! String)
        }
        
        return fieldValue.joined(separator: ", ")
        
    }
    
    func getPopupViewController() -> ReusablePopupViewController {
        let viewController =  ReusablePopupViewController()
        viewController.pageTitle = self.fieldTitleValue
        viewController.data = self.popupValueData as! [String]
        viewController.selectedItems = self.selectedItems as! [Int]
        viewController.minCount = self.minCount
        viewController.maxCount = self.maxCount
        viewController.isEditable = self.isEditable
        viewController.delegate = self
        viewController.allowsDeselect = self.allowsDeselect
        return viewController
    }
    
}

extension ReusableFormPopupField: ReusablePopupFieldSelectionViewDelegate {
    
    func saveButtonTapped(_ selectedItems: [Any]) {
        self.selectedItems = selectedItems
        
        if self.isDefaultPopupView() {
            fieldEndUpdateText(displayText: self.updateFieldValue())
        }
        
        self.delegate?.popupFieldViewDidEndEditing?(self, selectedItems: selectedItems)
        
    }
    
}

