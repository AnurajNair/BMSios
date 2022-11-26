//
//  ReusableFormTextView.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//


import UIKit
import SwiftValidator

protocol ReusableFormTextViewDelegate: UITextViewDelegate {
    func viewDidChangeHeight(_ view: ReusableFormTextView, height: CGFloat)
}

class ReusableFormTextView: UIView {
    
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var textViewHolder: UIView!
    @IBOutlet weak var charactersRemainingLabel: UILabel!
    
    weak var delegate:ReusableFormTextViewDelegate?
    
    var currentValidator = Validator()
    var currentValidationRules: [Rule] = []
    var currentErrorLabel: UILabel = UILabel()
    
    var viewHeight: CGFloat = 0.0
    var showCharacterLabel = false
    var shouldTrimWhiteSpaces = true
    
    let borderHeight = CGFloat(1.0)
    let border = CALayer()
    var frameWidth:CGFloat = 0.0
    
    override init (frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
        initFromNib()
        self.setupView()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frameWidth != self.frame.size.width {
            self.frameWidth = self.frame.size.width
            self.setInitialHeight(true)
        }
        
        
    }
    
    //MARK:- Setup Functions
    func setupView() {
        
        self.textView.delegate = self
        self.textView.font = FormElementStyler.TextView.font
        self.textView.textColor = FormElementStyler.TextView.textColor
        self.textView.dataDetectorTypes = .link
        self.textView.placeHolderLeftMargin = 0.0
        self.textView.contentInset = UIEdgeInsets.zero
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.bounces = false
        self.textView.backgroundColor = FormElementStyler.TextView.backgroundColor
        
        self.charactersRemainingLabel.font = FormElementStyler.TextView.charactersFont
        self.charactersRemainingLabel.textColor = FormElementStyler.TextView.charactersTextColor
        self.charactersRemainingLabel.isHidden = true
        
        styleDefaultBorder()
        
        self.frameWidth = self.frame.size.width
        
    }
    
    func setupTextView(id:Any = "",
                       maxLength:Int = 0,
                       showCharactersLabel:Bool = false,
                       minHeight:CGFloat = 0.0,
                       maxHeight:CGFloat = 0.0,
                       placeholderTitle: String = "",
                       fieldValue: String = "",
                       isEditable: Bool = true,
                       errorLabel: UILabel = UILabel(),
                       validationRules: [Rule] = [],
                       validator: Validator? = nil) {
        
        self.showCharacterLabel = showCharactersLabel
        
        //DO NOT CHANGE THIS ORDER. The Layout is called on minHeight / maxHeight so .text and .placeholder needs to be prior to that
        self.textView.trimWhiteSpaceWhenEndEditing = shouldTrimWhiteSpaces
        self.textView.maxLength = maxLength
        self.textView.text = fieldValue
        self.textView.placeHolder = placeholderTitle
        self.textView.minHeight = minHeight
        self.textView.maxHeight = maxHeight
        
        self.textView.isEditable = isEditable
        
        if validator != nil {
            self.currentValidator = validator!
        }
        
        self.currentValidationRules = validationRules
        self.currentErrorLabel = errorLabel
        
        self.addValidationRules()
        
        self.setInitialHeight()
        
        toggleCharacterLabelVisibility()
        
        self.updateCharacterCount()
        
    }
    
    func styleDefaultBorder() {
        self.textViewHolder.addBorders(edges: FormElementStyler.TextView.fieldBorderEdges, color: FormElementStyler.TextView.fieldBorderNormalColor, thickness: FormElementStyler.TextView.fieldBorderThickness)
    }
    
    func styleSelectedBorder() {
        self.textViewHolder.addBorders(edges: FormElementStyler.TextView.fieldBorderEdges, color: FormElementStyler.TextView.fieldBorderSelectedColor, thickness: FormElementStyler.TextView.fieldBorderThickness)
    }
    
    //MARK:- Public Validation Functions
    func addValidationRules(_ rules: [Rule] = []) {
        self.currentValidationRules.append(contentsOf: rules)
        self.currentValidator.registerField(self.textView, errorLabel: self.currentErrorLabel, rules: self.currentValidationRules)
    }
    
    //MARK:- Update Functions
    func setInitialHeight(_ shouldDelegate: Bool = false) {
        
        self.layoutIfNeeded()
        updateHeight(self.textView.frame.size.height, shouldDelegate: shouldDelegate)
        
    }
    
    func updateHeight(_ height: CGFloat, shouldDelegate: Bool = false) {
        let fieldHeight = getViewHeight(height)
        self.frame.size.height = fieldHeight
        self.textView.layoutIfNeeded()
        
        if shouldDelegate {
            self.delegate?.viewDidChangeHeight(self, height: fieldHeight)
        }
    }
    
    func updateCharacterCount() {
        
        if let inputText = self.textView.text, inputText.count <= self.textView.maxLength && self.textView.maxLength > 0  {
            self.charactersRemainingLabel.text = "(\(self.textView.maxLength - inputText.count) characters remaining)"
        }
        
    }
    
    //MARK:- Helpenr Functions
    
    func getViewHeight(_ height: CGFloat) -> CGFloat {
        
        if showCharacterLabel {
            viewHeight = height + getCharacterLabelHeight()
        } else {
            viewHeight = height
        }
        
        return viewHeight
        
    }
    
    func toggleCharacterLabelVisibility() {
        
        if self.showCharacterLabel {
            self.charactersRemainingLabel.isHidden = false
        } else {
            self.charactersRemainingLabel.isHidden = true
        }
        
    }
    
    func getCharacterLabelHeight() -> CGFloat {
        return 25 //15: Height of the Characters Remaining Label + 10: Spacing of stack view
    }
}

extension ReusableFormTextView: GrowingTextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.textViewDidBeginEditing!(textView)
        styleSelectedBorder()
    }
    
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        self.updateHeight(height, shouldDelegate: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharacterCount = textView.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let newLength = currentCharacterCount + text.count - range.length
        
        if self.textView.maxLength > 0 && newLength > self.textView.maxLength {
            return false
        }
        
        return true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.updateCharacterCount()
        self.delegate?.textViewDidChange!(textView)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if shouldTrimWhiteSpaces {
            self.textView.trimWhiteSpace()
        }
        
        styleDefaultBorder()
        self.updateCharacterCount()
        self.delegate?.textViewDidEndEditing!(textView)
        
    }
    
}
