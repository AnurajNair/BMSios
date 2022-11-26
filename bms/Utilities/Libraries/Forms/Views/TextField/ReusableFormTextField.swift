//
//  ReusableFormTextField.swift
//  bms
//
//  Created by Naveed on 18/10/22.
//

import UIKit
import SwiftValidator

@objc protocol ReusableFormTextFieldDelegate: UITextFieldDelegate {
    @objc optional func textFieldDidChange(_ textField: UITextField)
}

@objc protocol ReusableFormTextFieldTapDelegate: class {
    @objc optional func textField(_ textField: UITextField, didTapRightView id: Any)
}

class ReusableFormTextField: UITextField {
    
    enum FieldSubtype {
        case normal
        case email
        case url
        case number
        case decimal
        case phone
        case mobile
        case password
        case pincode
        case otp
        case datePicker
        case customPicker
        
        func getTextFieldKeyboardType() -> (UIKeyboardType) {
            switch self {
            case .normal:
                return (.default)
            case .email:
                return .emailAddress
            case .url:
                return .URL
            case .number:
                return .numberPad
            case .decimal:
                return .decimalPad
            case .phone:
                return .numberPad
            case .mobile:
                return .numberPad
            case .password:
                return .default
            case .pincode:
                return .numberPad
            case .otp:
                return .numberPad
            default:
                return .default
            }
        }
        
        func getTextFieldAutoCapitalizationType() -> (UITextAutocapitalizationType) {
            switch self {
            case .normal:
                return .sentences
            default:
                return .none
            }
        }
        
        func getTextFieldAutoCorrectionType() -> (UITextAutocorrectionType) {
            switch self {
            case .normal:
                return .yes
            default:
                return .no
            }
        }
        
        func getValidationRules() -> [Rule] {
            
            switch self {
            case .email:
                return [EmailRule(message: "Invalid Email")]
            case .url:
                return [WebUrlRule()]
//            case .phone:
//                return [LandlineRule()]
            case .mobile:
                return [PhoneNumberRule()]
            case .password:
                return []
            case .pincode:
                return [PincodeRule()]
//            case .otp:
//                return [OTPRule()]
            default:
                return []
            }
            
        }
        
    }
    
    weak var textFieldDelegate: ReusableFormTextFieldDelegate?
    weak var tapDelegate: ReusableFormTextFieldTapDelegate?
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var id: Any = ""
    var currentFieldType: FieldSubtype = .normal
    var currentFieldValue = ""
    var currentFieldFormat = Constants.displayDateFormat
    var currentValidator = Validator()
    var currentValidationRules: [Rule] = []
    var currentErrorLabel: UILabel = UILabel()
    var currentFieldMaxLength: Int = 0
    var shouldAllowUndoForCustomInput = true
    var trimWhiteSpaceWhenEndEditing = true
    var isEmojiSupported = false
    
    var isCurvedBorder:Bool = false
    
    var pickerDetails: (datePickerType: ReusableDatePickerView.DatePickerType, datePickerMode: UIDatePicker.Mode, minimumDate: Date?, maximumDate: Date?, startDate:Date) = (.custom, .date, nil, nil, Date())

    var textFieldStyle : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle
    
    //To be used for custom input fields like date
    var tempFieldValue = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK:- Setup Functions
    func setupView(_ style : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle) {
            self.font = style.font
            self.textColor = style.textColor
            self.tintColor = style.tintColor
            self.delegate = self
            self.backgroundColor = style.backgroundColor
            
            self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    
        self.isCurvedBorder = style.isCurvedBorder ?? false
        
     
            styleTextField(style)
       
            
        }
    func styleTextField(_ style : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle) {
        self.removeBorder()
        if(self.isCurvedBorder){
            self.setBorder(color: style.fieldBorderNormalColor ?? FormElementStyler.TextField.fieldBorderNormalColor,size: 1.0)
            self.setAsRounded(cornerRadius: style.fieldRadius ?? FormElementStyler.TextField.fieldRadiusCorner)
            
        }else{
            self.addBorders(edges: style.fieldBorderEdges ?? FormElementStyler.TextField.fieldBorderEdges, color: style.fieldBorderNormalColor ?? FormElementStyler.TextField.fieldBorderNormalColor, thickness: style.fieldBorderThickness ?? FormElementStyler.TextField.fieldBorderThickness)
        }
        self.padding = UIEdgeInsets(top: style.topPadding ?? FormElementStyler.TextField.topPadding, left: style.leftPadding ?? FormElementStyler.TextField.leftPadding, bottom: style.bottomPadding ?? FormElementStyler.TextField.bottomPadding, right: style.rightPadding ?? FormElementStyler.TextField.rightPadding)
        if(style.textFieldHeight != nil){
            self.setHeight(height: style.textFieldHeight ?? self.frame.size.height)
        }
        
       
    }
    
    func setHeight(height:CGFloat){
        var frameRect: CGRect = self.frame;
        frameRect.size.height = height; // <-- Specify the height you want here.
        self.frame = frameRect;
    }
    
    func styleSelectedTextField(_ style : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle) {
        if(self.isCurvedBorder){
            self.setBorder(color: style.fieldBorderSelectedColor ?? FormElementStyler.TextField.fieldBorderSelectedColor,size: style.fieldBorderThickness ?? FormElementStyler.TextField.fieldBorderThickness)
            self.setAsRounded(cornerRadius: style.fieldRadius ?? FormElementStyler.TextField.fieldRadiusCorner)
        }else{
            self.addBorders(edges: style.fieldBorderEdges ?? FormElementStyler.TextField.fieldBorderEdges, color: style.fieldBorderSelectedColor ?? FormElementStyler.TextField.fieldBorderSelectedColor, thickness: style.fieldBorderThickness ?? FormElementStyler.TextField.fieldBorderThickness)
        }
        
    }
    
    //MARK:- Public Textfield Functions
    func setupTextField(id:Any = "",
                        fieldSubtype: ReusableFormTextField.FieldSubtype = .normal,
                        placeholderTitle: String = "",
                        fieldValue: String = "",
                        isEditable: Bool = true,
                        maxLength:Int = 0,
                        errorLabel: UILabel = UILabel(),
                        validationRules: [Rule] = [],
                        validator: Validator? = nil,
                        leftImage:Any? = nil,
                        leftText:String = "",
                        rightImage:UIImage? = nil,
                        isEmojiSupported: Bool = false,
                        textFieldStyling : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle) {
        
        self.setupView(textFieldStyling)
        self.id = id
        self.currentFieldType = fieldSubtype
        self.currentFieldValue = fieldValue
        
        self.currentFieldMaxLength = maxLength
        self.isEmojiSupported = isEmojiSupported
        
        if validator != nil {
            self.currentValidator = validator!
        }
        
        self.currentValidationRules = validationRules
        self.currentErrorLabel = errorLabel
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderTitle,
                                                        attributes: [NSAttributedString.Key.foregroundColor: textFieldStyling.placeholderColor ?? textFieldStyling.textColor.withAlphaComponent(0.8)])
        self.text = self.currentFieldValue
        
        self.isEnabled = isEditable
        
        self.configureTextFieldByType()
        self.configureTextFieldLeftView(leftImage: leftImage, leftText: leftText , textFieldStyling: textFieldStyling)
        self.configureTextFieldRightView(rightImage: rightImage)
        self.textFieldStyle = textFieldStyling
        
    }
    
    //MARK:- Public DatePicker Functions
    
    func configureDateOfBirthPicker(minAge:Int = 0,
                                    maxAge:Int = 0,
                                    minimumDate: Date? = nil,
                                    maximumDate: Date? = nil,
                                    startDate: Date? = nil,
                                    dateFormat: String = "dd-mmm-yyyy") {
        
        self.currentFieldFormat = dateFormat
        
        if minAge > 0 || maxAge > 0 {
            self.addValidationRules([AgeRule(minimumAge: minAge, maximumAge: maxAge, dateFormat: self.currentFieldFormat)])
        }
        
        self.configureCustomDatePickerView(datePickerType: .dateOfBirth, datePickerMode: .date, minimumDate: minimumDate, maximumDate: maximumDate, startDate: startDate ?? Date())
        
    }
    
    func configureDatePicker(datePickerType: ReusableDatePickerView.DatePickerType = .custom,
                             datePickerMode: UIDatePicker.Mode = UIDatePicker.Mode.date,
                             minimumDate: Date? = nil,
                             maximumDate: Date? = nil,
                             startDate: Date = Date(),
                             dateFormat: String = "dd-MMM-yyyy") {
        
        self.currentFieldFormat = dateFormat
        
        self.configureCustomDatePickerView(datePickerType: datePickerType,
                                           datePickerMode: datePickerMode,
                                           minimumDate: minimumDate,
                                           maximumDate: maximumDate,
                                           startDate: startDate)
    }
    
    func configureCustomPicker(view: UIView) {
        
        self.configureCustomInputView(view: view)
    }
    
    func isPickerField() -> Bool {
        return self.currentFieldType == .datePicker || self.currentFieldType == .customPicker
    }
    
    //MARK:- Public Validation Functions
    func addValidationRules(_ rules: [Rule]) {
        self.currentValidationRules.append(contentsOf: rules)
        self.currentValidator.registerField(self, errorLabel: self.currentErrorLabel, rules: self.currentValidationRules)
    }
    
    //MARK:- Helper Textfield Functions
    
    private func configureTextFieldByType() {
        
        //Specific Configuration for Different TextField Types
        self.keyboardType = self.currentFieldType.getTextFieldKeyboardType()
        self.autocapitalizationType = self.currentFieldType.getTextFieldAutoCapitalizationType()
        self.autocorrectionType = self.currentFieldType.getTextFieldAutoCorrectionType()
        
        if self.currentFieldType == .password {
            self.isSecureTextEntry = true
        }
        
        self.addValidationRules(self.currentFieldType.getValidationRules())
        
    }
    
    private func configureTextFieldLeftView(leftImage:Any? = nil, leftText: String , textFieldStyling : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle) {
        
        let height = self.frame.size.height
        let viewHeight:CGFloat = 13
        let originY = (self.frame.size.height - viewHeight) / 2
        
        //add the left image view
        let leftView = UIView()
        if let value = leftImage {
            
            var shouldSetupView = false
            let leftImageView = UIImageView(frame: CGRect(x: 5, y: originY, width: 13, height: viewHeight))
            
            if let imageString = value as? String, !imageString.isEmpty {
                leftImageView.cacheImage(url: imageString)
                shouldSetupView = true
            }
                
            else if let imageValue = value as? UIImage {
                leftImageView.image = imageValue
                shouldSetupView = true
            }
            
            if shouldSetupView {
                leftView.frame = CGRect(x: 0, y: 0, width: 26, height: height)
                leftImageView.contentMode = .scaleAspectFit
                leftView.addSubview(leftImageView)
            }
            
        }
            
        else if !leftText.isEmpty {
            leftView.frame = CGRect(x: 0, y: 0, width: 26, height: height)
            let leftLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 26, height: height))
            leftLabel.text = leftText
            leftLabel.textColor = textFieldStyling.leftLabelTextColor ?? FormElementStyler.TextField.leftLabelTextColor
            leftLabel.font = textFieldStyling.leftLabelFont ?? FormElementStyler.TextField.leftLabelFont
            if let value = leftLabel.text?.width(withConstraintedHeight: height, font: leftLabel.font) {
                leftView.frame.size.width = value + 5
            }
            leftView.addSubview(leftLabel)
            leftLabel.layoutAllConstraints(parentView: leftView, topConstant: 0.0, bottomConstant: 0.0, leadingConstant: 0.0, trailingConstant: 0.0)
        }
        
        self.leftView = leftView
        self.leftViewMode = .always
        
    }
    
    func configureTextFieldRightView(rightImage: UIImage? = nil, imageContentMode: UIView.ContentMode = .scaleAspectFit) {
        
        if let value = rightImage {
            
            let viewSize:CGFloat = 30
            let height = self.frame.size.height
            let viewHeight:CGFloat = 16
            let originY = (self.frame.size.height - viewHeight) / 2
            
            let rightView = UIView(frame: CGRect(x: self.bounds.size.width - viewSize, y: 0, width: viewSize, height: height))
            let rightButtonView = UIButton(frame: CGRect(x: (viewSize-viewHeight)/2, y: originY , width: viewHeight, height: viewHeight))
            rightButtonView.contentMode = imageContentMode
            rightButtonView.setImage(value, for: UIControl.State())
            rightButtonView.addTarget(self, action: #selector(rightViewTapped), for: .touchUpInside)
            rightView.addSubview(rightButtonView)
            self.rightView = rightView
            self.rightViewMode = .always
            
        }
    }
    
    func isTextfieldLowercase() -> Bool {
        if self.currentFieldType == .password{
            return false
        }
        return self.autocapitalizationType == .none
    }
    
    func isTextfieldUppercase() -> Bool {
        return self.autocapitalizationType == .allCharacters
    }
    
    func isEmojiSupported(_ string : String) -> Bool{
        return isEmojiSupported ?  true : string.canBeConverted(to: .ascii)
    }
    
    //MARK:- Helper Datepicker Functions
    private func configureCustomDatePickerView(datePickerType: ReusableDatePickerView.DatePickerType = .custom,
                                               datePickerMode: UIDatePicker.Mode = UIDatePicker.Mode.date,
                                               minimumDate: Date? = nil,
                                               maximumDate: Date? = nil,
                                               startDate: Date = Date()) {

        self.pickerDetails.datePickerType = datePickerType
        self.pickerDetails.datePickerMode = datePickerMode
        self.pickerDetails.minimumDate = minimumDate
        self.pickerDetails.maximumDate = maximumDate
        self.pickerDetails.startDate = startDate

    }

    func showCustomDatePickerView() {
        
        let datePickerView: ReusableDatePickerView = ReusableDatePickerView()
        datePickerView.delegate = self
        
        var selectedDate = self.pickerDetails.startDate
        
        if !self.currentFieldValue.isEmpty {
            selectedDate = self.currentFieldValue.toDate(self.currentFieldFormat)
        }
        
        self.tempFieldValue = selectedDate.toString(format: self.currentFieldFormat)
        
        datePickerView.configureDatePickerView(datePickerType: self.pickerDetails.datePickerType,
                                               datePickerMode: self.pickerDetails.datePickerMode,
                                               minimumDate: self.pickerDetails.minimumDate,
                                               maximumDate: self.pickerDetails.maximumDate,
                                               currentDate: selectedDate)
        
        self.configureCustomInputView(view: datePickerView)
        
    }
    
    private func configureCustomInputView(view: UIView) {
        
        let width = UIScreen.main.bounds.width
        
        //Create Input Accessory View
        var inputAccessoryHeight:CGFloat = 0
        var inputAccessoryView = UIView()
        
        if shouldAllowUndoForCustomInput {
            inputAccessoryView = configureCustomInputAccessoryView(width: width)
            inputAccessoryView.frame.origin.y = view.frame.size.height
            inputAccessoryHeight = inputAccessoryView.frame.size.height
        }
        
        //Create Input View
        let inputViewForPicker = UIView(frame: CGRect(x: 0, y: 0, width: width, height: view.frame.height + inputAccessoryHeight))
        inputViewForPicker.backgroundColor = FormElementStyler.TextField.accessoryBackgroundColor
        
        inputViewForPicker.addSubview(view)
        
        if shouldAllowUndoForCustomInput {
            inputViewForPicker.addSubview(inputAccessoryView)
        }
        
        self.inputView = inputViewForPicker
        
    }
    
    private func configureCustomInputAccessoryView(width: CGFloat = UIScreen.main.bounds.width) -> UIView {
        
        let inputAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 51))
        
        let topSeparator = UIView(frame: CGRect(x: 0,y: 0, width: width, height: 1))
        topSeparator.backgroundColor = FormElementStyler.TextField.accessoryBorderColor
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 1, width: width / 2, height: 50))
        UIButton.style([(view: cancelButton, title: "Cancel".localized(), style: FormElementStyler.TextField.cancelButtonStyle)])
        cancelButton.addTarget(self, action: #selector(customViewCancelClicked), for: .touchUpInside)
        
        let saveButton = UIButton(frame: CGRect(x: width/2, y: 1, width: width/2, height: 50))
        UIButton.style([(view: saveButton, title: "Save".localized(), style: FormElementStyler.TextField.saveButtonStyle)])
        
        saveButton.addTarget(self, action: #selector(customViewSaveClicked), for: .touchUpInside)
        
        inputAccessoryView.addSubview(topSeparator)
        inputAccessoryView.addSubview(cancelButton)
        inputAccessoryView.addSubview(saveButton)
        
        return inputAccessoryView
        
    }
    
    @objc func customViewCancelClicked() {
        self.tempFieldValue = self.currentFieldValue
        textFieldDidChange(self)
        self.resignFirstResponder()
    }
    
    @objc func customViewSaveClicked() {
        
        if currentFieldType == .datePicker || currentFieldType == .customPicker {
            self.currentFieldValue = self.tempFieldValue
            self.text = self.currentFieldValue
            textFieldDidChange(self)
            self.resignFirstResponder()
        }
        
    }
    
    func trimWhiteSpace() {
        if trimWhiteSpaceWhenEndEditing {
            self.text = self.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    //MARK:- Action Functions
    
    @objc func rightViewTapped() {
        
        //Example if you want to show / hide the password
        if self.currentFieldType == .password {
            self.isSecureTextEntry = !self.isSecureTextEntry
        }
        
        self.tapDelegate?.textField?(self, didTapRightView: self.id)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.textFieldDelegate?.textFieldDidChange?(self)
    }
    
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

extension ReusableFormTextField: ReusableDatePickerViewDelegate {
    func datePickerValueChanged(selectedDate: Date) {
        self.tempFieldValue = selectedDate.toString(format: self.currentFieldFormat)
        self.text = selectedDate.toString(format: self.currentFieldFormat)
    }
}

extension ReusableFormTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if currentFieldType == .datePicker {
            showCustomDatePickerView()
        }
        styleSelectedTextField(textFieldStyle)
        self.textFieldDelegate?.textFieldDidBeginEditing!(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        customViewSaveClicked()
        styleTextField(textFieldStyle)
        trimWhiteSpace()
        self.textFieldDelegate?.textFieldDidEndEditing!(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let value = self.textFieldDelegate?.textFieldShouldReturn!(textField) {
            return value
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !self.isEmojiSupported(string){
            return false
        }
        
        //For Changing it to Lower Case Characters
        if self.isTextfieldLowercase() {
            
            let uppercaseCharRange = string.rangeOfCharacter(from: .uppercaseLetters)
            
            if uppercaseCharRange != nil {
                let convertString = textField.text as NSString?
                textField.text = convertString?.replacingCharacters(in: range, with: string.lowercased())
                return false
            }
            
        }
            
        //For Changing it to Upper Case Characters
        else if self.isTextfieldUppercase() {
            
            let lowercaseCharRange = string.rangeOfCharacter(from: .lowercaseLetters)
            
            if lowercaseCharRange != nil {
                let convertString = textField.text as NSString?
                textField.text = convertString?.replacingCharacters(in: range, with: string.uppercased())
                return false
            }
            
        }
        
        //For Character Count Limits
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        switch currentFieldType {
            
        case .phone:
            return newLength <= 14
        case .mobile:
            return newLength <= 10
        case .pincode:
            return newLength <= 6
        case .otp:
            return newLength <= 4
        case .password:
            return newLength <= (currentFieldMaxLength > 0 ? currentFieldMaxLength : 20)
        default:
            if currentFieldMaxLength > 0 {
                return newLength <= currentFieldMaxLength
            }
            return newLength < 255
        }
        
    }
    
}


