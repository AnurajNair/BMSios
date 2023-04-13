//
//  ReusableFormElementView.swift
//  bms
//
//  Created by Naveed on 20/10/22.
//

import UIKit
import SwiftValidator

@objc protocol ReusableFormElementViewDelegate: class {
    @objc optional func refreshView(index: Any)
    @objc optional func setValues(index: Any, item: Any)
    @objc optional func setError(index: Any, error: String)
}

class ReusableFormElementView: UIView {
    
    @IBOutlet weak var formElementTitle: UILabel!
    @IBOutlet weak var formElementFieldView: UIView!
    @IBOutlet weak var formElementFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var formElementError: UILabel!
    @IBOutlet weak var formElementErrorIcon: UIImageView!
    @IBOutlet weak var formElementOverallStackView: UIStackView!
    @IBOutlet weak var formElementErrorStackView: UIStackView!
    
    weak var delegate: ReusableFormElementViewDelegate?
    var showErrorMessageInRealTime = true
    var showErrorIcon = true
    
    enum FormElementType {
        case textfield
        case textview
        case popup
        case switcher
        case segmentedController
        case options
        case file
        case slider
        case checkbox
        case dropdown
    }
    
    var index: Any = ""
    var currentValidator = Validator()
    var showTitleByDefault = false
    var showTitleWhileEditing = false
    var isRequired = true
    var isEditable = true
    var previousHeight: CGFloat = 0.0
    var frameWidth:CGFloat = 0.0
    var formElement:FormElementType = .textfield
    var isRequiredErrorMessage = "This field is required"
    
    var formStyling : FormElementStyler.formElementViewStyle = TTFormElementViewStyler.defaultStyle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
        initFromNib()
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            self.updateHeight()
        }
    }
    
    func updateHeight(_ height: CGFloat? = nil, shouldDelegate: Bool = false) {
        
        if self.formElementFieldView.subviews.count > 0 {
            let fieldHeight = height != nil ? height! : self.formElementFieldView.subviews[0].frame.size.height
            
            if previousHeight == 0 {
                previousHeight = fieldHeight
                self.setupViewHeight(fieldHeight)
            }
                
            else if ceil(fieldHeight) != ceil(previousHeight) {
                previousHeight = fieldHeight
                self.setupViewHeight(fieldHeight)
                
                if shouldDelegate {
                    self.setViewRefreshNeeded("Update Height")
                }
            }
            
        }
        
    }
    
    //MARK:- Setup Functions
    
    func setupView( _ style : FormElementStyler.formElementViewStyle = TTFormElementViewStyler.defaultStyle) {
        self.translatesAutoresizingMaskIntoConstraints =  false;
        self.formElementTitle.font = style.titleFontDefault
        self.formElementTitle.textColor = style.titleTextColorDefault
        self.formElementTitle.text = ""
        
        self.formElementError.font = style.errorFont
        self.formElementError.textColor = style.errorTextColor
        self.formElementError.text = ""
        
        if let errorImage = style.errorImage, !errorImage.isEmpty {
            self.formElementErrorIcon.isHidden = false
            self.formElementErrorIcon.tintColor = style.errorImageTintColor
            self.formElementErrorIcon.image = UIImage(named: errorImage)?.withRenderingMode(style.errorImageRenderingMode)
        } else {
            self.formElementErrorIcon.isHidden = true
        }
        
        showTitleByDefault = false
        showTitleWhileEditing = false
        isRequired = true
        isEditable = true
        
        self.formElementTitle.isHidden = true
        self.formElementErrorStackView.isHidden = true
        
        self.frameWidth = self.frame.size.width
        self.backgroundColor = style.formBackgroundColor
        
    }
    
    
    func setupViewHeight(_ height: CGFloat = 0.0) {
        self.formElementFieldHeight.constant = height
        //self.layoutIfNeeded()
    }
    
    func showTitle(_ shouldShow: Bool) {
        
        let isErrorHidden = self.formElementTitle.isHidden
        
        self.formElementTitle.isHidden = !shouldShow
        
        if (shouldShow && isErrorHidden || !shouldShow && !isErrorHidden) {
            self.setViewRefreshNeeded("Show Title")
        }
        
    }
    
    func showError(_ shouldShow: Bool, shouldDelegate: Bool = true) {
        let isErrorHidden = self.formElementErrorStackView.isHidden
        
        self.formElementErrorStackView.isHidden = !shouldShow
        
        if (shouldShow && isErrorHidden || !shouldShow && !isErrorHidden) && shouldDelegate {
            self.setViewRefreshNeeded("Show Error")
        }
        
    }
    
    //MARK:- Setup Field Functions
    // To be called from controllers
    
    func prepareForReuse() {
        
        setupView()
        
        for subview in self.formElementFieldView.subviews{
            subview.removeFromSuperview()
        }
    }
    
    func showErrorMessage(_ errorMessage:String="", errorLabel: UILabel? = nil) {
        setErrorMessage(errorMessage, errorLabel: errorLabel, shouldDelegate: false)
    }
    
    //Textfield
    func setupTextField(id: Any = "",
                        fieldTitle: String = "",
                        showFieldTitleByDefault: Bool = true,
                        showFieldTitleWhileEditing: Bool = true,
                        placeholderTitle: String = "",
                        fieldValue: String = "",
                        isEditable: Bool = true,
                        minLength:Int = 0,
                        maxLength:Int = 0,
                        fieldSubtype: ReusableFormTextField.FieldSubtype = .normal,
                        validationRules: [Rule] = [],
                        validator: Validator = Validator(),
                        height:CGFloat = 28.0,
                        isRequired:Bool = true,
                        leftImage:Any? = nil,
                        leftText:String = "",
                        rightImage:UIImage? = nil,
                        isEmojiSupported: Bool = false,
                        matchingTextField: UITextField? = nil,
                        matchingTextFieldError: String = "",
                        isRequiredMessage:String? = nil,
                        textFieldStyling : FormElementStyler.formTextFieldStyle = TTTextFieldStyler.defaultStyle ,
                        formStyling : FormElementStyler.formElementViewStyle = TTFormElementViewStyler.defaultStyle) -> ReusableFormTextField {
        
        setupView(formStyling)
        self.formStyling = formStyling
        self.index = id
        self.currentValidator = validator
        self.showTitleByDefault = showFieldTitleByDefault
        self.showTitleWhileEditing = showFieldTitleWhileEditing
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.formElement = .textfield
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault, shouldShowWhileEditing: showFieldTitleWhileEditing, fieldValue: fieldValue)
        
        let field = ReusableFormTextField(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        var rules:[Rule] = []
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        if isRequired {
            rules.append(RequiredRule(message: isRequiredErrorMessage))
        }
        
        rules.append(contentsOf: validationRules)
        
        if minLength != 0 || maxLength != 0 {
            rules.append(CharacterLengthRule(minLength: minLength, maxLength: maxLength))
        }
        
        if matchingTextField != nil {
            rules.append(ConfirmationRule(confirmField: matchingTextField!, message: matchingTextFieldError))
        }
        
        field.textFieldDelegate = self
        
        field.setupTextField(id:self.index,
                             fieldSubtype: fieldSubtype,
                             placeholderTitle: setTextAsRequired(placeholderTitle, isRequired: isRequired),
                             fieldValue: fieldValue,
                             isEditable: isEditable,
                             maxLength: maxLength,
                             errorLabel: self.formElementError,
                             validationRules: rules,
                             validator: validator,
                             leftImage: leftImage,
                             leftText: leftText,
                             rightImage: rightImage,
                             isEmojiSupported: isEmojiSupported,
                             textFieldStyling : textFieldStyling)
        
        setupFieldCompleted(field: field)
        
        return field
        
    }
    
    //TextView
    func setupTextView(id: Any = "",
                       fieldTitle: String = "",
                       showFieldTitleByDefault: Bool = true,
                       showFieldTitleWhileEditing: Bool = true,
                       placeholderTitle: String = "",
                       fieldValue: String = "",
                       isEditable: Bool = true,
                       validationRules: [Rule] = [],
                       validator: Validator = Validator(),
                       minLength:Int = 0,
                       maxLength:Int = 0,
                       height:CGFloat = 28.0,
                       maxHeight:CGFloat = 0.0,
                       isRequired:Bool = true,
                       shouldShowCharacterLabel: Bool = false,
                       isRequiredMessage:String? = nil) {
        
        self.index = id
        self.currentValidator = validator
        self.showTitleByDefault = showFieldTitleByDefault
        self.showTitleWhileEditing = showFieldTitleWhileEditing
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.formElement = .textview
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault, shouldShowWhileEditing: showFieldTitleWhileEditing, fieldValue: fieldValue)
        
        var rules:[Rule] = []
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        if isRequired {
            rules.append(RequiredRule(message: isRequiredErrorMessage))
        }
        
        rules.append(contentsOf: validationRules)
        
        if minLength != 0 || maxLength != 0 {
            rules.append(CharacterLengthRule(minLength: minLength, maxLength: shouldShowCharacterLabel ? 0 : maxLength))
        }
        
        let field = ReusableFormTextView(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        field.delegate = self
        
        field.setupTextView(id:self.index,
                            maxLength: maxLength,
                            showCharactersLabel: shouldShowCharacterLabel,
                            minHeight: height,
                            maxHeight: maxHeight,
                            placeholderTitle: setTextAsRequired(placeholderTitle, isRequired: isRequired),
                            fieldValue: fieldValue,
                            isEditable: isEditable,
                            errorLabel: self.formElementError,
                            validationRules: rules,
                            validator: validator)
        
        setupFieldCompleted(field: field)
    }
    
    //Popup
    func setupPopupField(id: Any = "",
                         fieldSubtype: ReusableFormPopupField.FieldSubtype = .normal,
                         fieldValue: String? = nil,
                         destinationView: Any? = nil,
                         destinationData: [String: Any] = [:],
                         destinationTitle: String = "",
                         fieldTitle: String = "",
                         showFieldTitleByDefault: Bool = true,
                         showFieldTitleWhileEditing: Bool = true,
                         placeholderTitle: String = "",
                         validationRules: [Rule] = [],
                         validator: Validator = Validator(),
                         leftImage:String = "",
                         leftText:String = "",
                         rightImage:String = "",
                         minCount:Int = 0,
                         maxCount:Int = 0,
                         height:CGFloat = 28.0,
                         maxHeight:CGFloat = 0.0,
                         popUpValues: [String] = [],
                         selectedItems: [Any] = [],
                         isRequired:Bool = true,
                         isEditable: Bool = true,
                         isTappable: Bool = true,
                         showBorder: Bool = true,
                         allowsDeselect: Bool = false,
                         isRequiredMessage:String? = nil) {
        
        self.index = id
        self.currentValidator = validator
        self.showTitleByDefault = showFieldTitleByDefault
        self.showTitleWhileEditing = showFieldTitleWhileEditing
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.formElement = .popup
        
        let displayText = selectedItems.count > 0 ? selectedItems.description : ""
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault, shouldShowWhileEditing: showFieldTitleWhileEditing, fieldValue: displayText)
        
        var rules:[Rule] = []
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        if isRequired {
            rules.append(RequiredRule(message: isRequiredErrorMessage))
        }
        
        rules.append(contentsOf: validationRules)
        
        self.formElementFieldView.frame.size.height = height
        
        let field = ReusableFormPopupField(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        field.delegate = self
        
        field.setupPopupField(id:self.index,
                              fieldSubtype: fieldSubtype,
                              fieldValue: fieldValue,
                              destinationView: destinationView,
                              destinationData: destinationData,
                              destinationTitle: destinationTitle,
                              placeholderTitle: setTextAsRequired(placeholderTitle, isRequired: isRequired),
                              errorLabel: self.formElementError,
                              validationRules: rules,
                              validator: validator,
                              leftImage: leftImage,
                              leftText : leftText,
                              rightImage: rightImage,
                              minHeight: height,
                              maxHeight: maxHeight,
                              minCount: minCount,
                              maxCount: maxCount,
                              popUpValues: popUpValues,
                              selectedItems: selectedItems,
                              isEditable: isEditable,
                              showBorder: showBorder,
                              isTappable: isTappable,
                              allowsDeselect: allowsDeselect)
        
        setupFieldCompleted(field: field)
        
    }
    
    //Switch
    func setupSwitcher(id: Any = "",
                       fieldTitle: String = "",
                       showFieldTitleByDefault: Bool = true,
                       isEditable: Bool = true,
                       isOn: Bool = false,
                       onValue: String = "",
                       offValue: String = "",
                       height:CGFloat = 34.0) {
        
        self.index = id
        self.isEditable = isEditable
        self.showTitleByDefault = showFieldTitleByDefault
        self.formElement = .switcher
        
        setupTitleField(fieldTitle, isRequired: true, shouldShowByDefault: showFieldTitleByDefault)
        
        let field = ReusableFormSwitch(frame:  CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        field.delegate = self
        
        field.setupSwitcher(id: id,
                            isOn: isOn,
                            onValue: onValue,
                            offValue: offValue,
                            isEditable: isEditable)
        
        setupFieldCompleted(field: field)
    }
    
    //Segmented Controller
    func setupSegmentedController(id: Any = "",
                                  fieldTitle: String = "",
                                  showFieldTitleByDefault: Bool = true,
                                  isEditable: Bool = true,
                                  items: [Any] = [],
                                  selectedIndex: Int = 0,
                                  height:CGFloat = 43.5) {
        
        self.index = id
        self.isEditable = isEditable
        self.formElement = .segmentedController
        
        setupTitleField(fieldTitle, isRequired: true, shouldShowByDefault: showFieldTitleByDefault)
        
        let field = ReusableFormSegmentedController(frame:  CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        field.delegate = self
        
        field.setupSegmentedController(id: id,
                                       items: items,
                                       selectedIndex: selectedIndex,
                                       isEditable: isEditable)
        
        setupFieldCompleted(field: field)
        
    }
    
    //Options
    func setupOptionsField(id: Any = "",
                           fieldTitle: String = "",
                           showFieldTitleByDefault: Bool = true,
                           placeholderTitle: String = "",
                           isEditable: Bool = true,
                           maxCount:Int = 1,
                           maxHeight:CGFloat = 0.0,
                           isRequired:Bool = true,
                           optionValues: [String] = [],
                           selectedItems: [Int] = [0],
                           scrollDirection: UICollectionView.ScrollDirection = .vertical,
                           numberOfItemsPerRow: CGFloat = 3.0,
                           asymmetricPadding: CGFloat = 20.0,
                           isEqualWidth: Bool = false,
                           isEqualHeight: Bool = false,
                           allowsDeselect: Bool = true,
                           showSelectAll: Bool = true,
                           showClear: Bool = true,
                           isRequiredMessage:String? = nil) {
        
        
        self.index = id
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.showTitleByDefault = showFieldTitleByDefault
        self.formElement = .options
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault)
        
        let field = ReusableFormOptionsField(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: 0))
        
        field.optionsDelegate = self
        
        field.setupOptionsField(id: self.index,
                                title: placeholderTitle,
                                values: optionValues,
                                selectedItems: selectedItems,
                                isEditable: isEditable,
                                maxHeight: maxHeight,
                                maxCount: maxCount,
                                scrollDirection: scrollDirection,
                                numberOfItemsPerRow: numberOfItemsPerRow,
                                asymmetricPadding: asymmetricPadding,
                                isEqualWidth: isEqualWidth,
                                isEqualHeight: isEqualHeight,
                                allowsDeselect: allowsDeselect,
                                showSelectAll: showSelectAll,
                                showClear: showClear)
        
        setupFieldCompleted(field: field)
        
    }
    
    //File
    func setupFileField(id: Any = "",
                        fieldTitle: String = "",
                        showFieldTitleByDefault: Bool = true,
                        fieldSubtype: ReusableFormFileField.FieldSubtype = .images,
                        documentTypes: [String] = ["public.png", "public.jpeg", "com.adobe.pdf"],
                        maxCount:Int = 1,
                        isEditable: Bool = true,
                        canDelete: Bool = true,
                        isAddPositionFirst: Bool = true,
                        addPreviewImagePlaceholder: String = "Form-Add-Image-Placeholder",
                        displayPreviewImagePlaceholder: String = "Form-Display-Image-Placeholder",
                        isRoundedPreview: Bool = false,
                        isViewCentered: Bool = true,
                        previewAspectRatio: CGFloat = 1.0,
                        previewImageContentMode: UIView.ContentMode = .scaleAspectFit,
                        previewWebScaleToFit: Bool = true,
                        maxHeight:CGFloat = 0.0,
                        isRequired:Bool = true,
                        files: [Any] = [],
                        fileTypes: [ReusableFormFileField.FileType] = [],
                        scrollDirection: UICollectionView.ScrollDirection = .horizontal,
                        numberOfItemsPerRow: CGFloat = 3.0,
                        isPreviewEnabled: Bool = false,
                        isCameraEnabled: Bool = true,
                        maxFileSizeAllowedInMB: Double = 0,
                        fileSizeErrorMessage: String = FormElementStyler.File.fileSizeErrorMessage,
                        isRequiredMessage:String? = nil) -> ReusableFormFileField{
        
        self.index = id
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.showTitleByDefault = showFieldTitleByDefault
        self.formElement = .file
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault)
        
        for view in self.formElementFieldView.subviews{
            if view is ReusableFormFileField{
                view.removeFromSuperview()
                break
            }
        }
        
        let field = ReusableFormFileField(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: 0))
        
        field.delegate = self
        
        field.setupFileField(id: self.index,
                             files: files,
                             fileTypes: fileTypes,
                             fieldSubtype: fieldSubtype,
                             documentTypes: documentTypes,
                             isEditable: isEditable,
                             canDelete: canDelete,
                             isAddPositionFirst: isAddPositionFirst,
                             addPreviewImagePlaceholder: addPreviewImagePlaceholder,
                             displayPreviewImagePlaceholder: displayPreviewImagePlaceholder,
                             isRoundedPreview: isRoundedPreview,
                             isViewCentered: isViewCentered,
                             previewAspectRatio: previewAspectRatio,
                             previewImageContentMode: previewImageContentMode,
                             previewWebScaleToFit: previewWebScaleToFit,
                             maxHeight: maxHeight,
                             maxCount: maxCount,
                             scrollDirection: scrollDirection,
                             numberOfItemsPerRow: numberOfItemsPerRow,
                             isPreviewEnabled: isPreviewEnabled,
                             isCameraEnabled: isCameraEnabled,
                             maxFileSizeAllowedInMB : maxFileSizeAllowedInMB,
                             fileSizeErrorMessage : fileSizeErrorMessage)
        
        
        setupFieldCompleted(field: field)
        
        return field
    }
    
    //slider
    func setupSliderField(id: Any = "",
                          fieldTitle: String = "",
                          showFieldTitleByDefault: Bool = true,
                          isEditable: Bool = true,
                          maxHeight:CGFloat = 0.0,
                          isRequired:Bool = true,
                          levels: [String] = [],
                          selectedLevel: Int = 0,
                          shouldShowStatus: Bool = true,
                          shouldShowLevels: Bool = true,
                          leftImage: Any? = nil,
                          leftImageRenderingMode: UIView.ContentMode = .scaleAspectFit,
                          inDisplayMode: Bool = false,
                          isRequiredMessage:String? = nil) {
        
        self.index = id
        self.isEditable = isEditable
        self.isRequired = isRequired
        self.showTitleByDefault = showFieldTitleByDefault
        self.formElement = .slider
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault)
        
        let field = ReusableFormSliderField(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: 0))
        
        field.fieldDelegate = self
        field.setupSliderFormField(title: fieldTitle,
                                   levels:levels,
                                   selectedLevel: selectedLevel,
                                   shouldShowStatus: shouldShowStatus,
                                   shouldShowLevels: shouldShowLevels,
                                   leftImage: leftImage,
                                   leftImageRenderingMode: leftImageRenderingMode,
                                   isEditable: isEditable,
                                   inDisplayMode: inDisplayMode)
        
        setupFieldCompleted(field: field)
        
        field.alpha = 1.0
    }
    
    //Checkbox
    func setupCheckboxField(id: Any = "",
                            fieldTitle: String = "",
                            showFieldTitleByDefault: Bool = false,
                            fieldLabel: String = "",
                            isSelectedByDefault: Bool = true,
                            height:CGFloat = 36.0,
                            isEditable: Bool = true,
                            isTextUserInteractionEnabled: Bool = true,
                            isRequired:Bool = true,
                            isRequiredMessage:String? = nil) -> ReusableFormCheckboxField {
        
        
        self.index = id
        self.isRequired = isRequired
        self.isEditable = isEditable
        self.showTitleByDefault = showFieldTitleByDefault
        self.formElement = .checkbox
        
        if let value = isRequiredMessage, !value.isEmpty {
            isRequiredErrorMessage = value
        }
        
        setupTitleField(fieldTitle, isRequired: isRequired, shouldShowByDefault: showFieldTitleByDefault)
        
        let field = ReusableFormCheckboxField(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        field.delegate = self
        
        field.setupCheckboxField(id: id,
                                 fieldLabel: fieldLabel,
                                 isSelectedByDefault: isSelectedByDefault,
                                 height: height,
                                 isEditable: isEditable,
                                 isUserInteractionEnabled : isTextUserInteractionEnabled)
        
        setupFieldCompleted(field: field)
        
        return field
        
    }
    
    //MARK:- Other Setup Functions
    
    func setupTitleField(_ title: String = "", isRequired: Bool = true, shouldShowByDefault: Bool = true, shouldShowWhileEditing: Bool = true, fieldValue: String = "") {
        
        let text = setTextAsRequired(title, isRequired: isRequired)
        self.formElementTitle.text = text
        
        if (!text.isEmpty && shouldShowByDefault) || (!text.isEmpty && shouldShowWhileEditing && !fieldValue.isEmpty){
            self.formElementTitle.isHidden = false
        }
    }
    
    
    func setupFieldCompleted(field: UIView) {
        
        self.setTitleSpacing()
        
        self.formElementFieldView.addSubview(field)
        
        self.layoutAllConstraints(field: field)
        
        self.updateHeight()
        
        if self.isEditable || formElement == .file {
            field.alpha = 1.0
        } else {
            field.alpha = FormElementStyler.FormElementView.nonEditableFieldAlpha
        }
        
    }

    func setupDropdownField(id: Any = "",
                            fieldTitle: String = "",
                            options: [DropDownModel] = [],
                            placeHolder: String = "",
                            showFieldTitleByDefault: Bool = true,
                            isEditable: Bool = true,
                            items: [Any] = [],
                            selectedIndex: Int = 0,
                            height:CGFloat = 43.5,
                            style: FormElementStyler.formDropDownStyle = TTDropDownStyle.defaultStyle) {
        
        self.index = id
        self.isEditable = isEditable
        self.formElement = .segmentedController
        
        setupTitleField(fieldTitle, isRequired: true, shouldShowByDefault: showFieldTitleByDefault)
        
        let field = ReusableDropDown(frame: CGRect(x: 0, y: 0, width: self.formElementFieldView.frame.size.width, height: height))
        
        field.setupDropDown(options: options, placeHolder: placeHolder, selectedItemIndex: selectedIndex, style: style)
        
        setupFieldCompleted(field: field)
    }

    //MARK:- Helper Functions
    
    func setTitleSpacing(spacing:CGFloat? = nil) {
        
        if formElement == .segmentedController || formElement == .file {
            self.formElementOverallStackView.spacing = spacing != nil ? spacing! : 12.0
        }
            
        else if formElement == .options ||  formElement == .checkbox {
            self.formElementOverallStackView.spacing = spacing != nil ? spacing! : 10.0
        }
            
        else {
            self.formElementOverallStackView.spacing = spacing != nil ? spacing! : 5.0
        }
        
    }
    
    func setTextAsRequired(_ title: String, isRequired: Bool = true) -> String {
        
        var text = title
        if isRequired && !text.isEmpty {
            text += ""
        }
        return text
        
    }
    
    func handleFieldEditingStart() {
        
        if self.showTitleWhileEditing && self.formElementTitle.isHidden {
            showTitle(true)
        }
        
        showError(false)
    }
    
    func handleFieldEditingEnd(text: String = "") {
        if self.showTitleWhileEditing && !self.showTitleByDefault {
            showTitle(!text.isEmpty)
        }
    }
    
    func setFieldStyling() {
        self.formElementTitle.font = formStyling.titleFontSelected
        self.formElementTitle.textColor = formStyling.titleTextColorSelected
    }
    
    func resetFieldStyling() {
        self.formElementTitle.font = formStyling.titleFontDefault
        self.formElementTitle.textColor = formStyling.titleTextColorDefault
    }
    
    func setErrorMessage(_ errorMessage:String="", errorLabel: UILabel? = nil, shouldDelegate: Bool = true) {
        
        var label = self.formElementError
        if errorLabel != nil {
            label = errorLabel
        }
        
        if showErrorMessageInRealTime {
            label!.text = errorMessage
            label!.isHidden = false
            showError(true, shouldDelegate: shouldDelegate)
        }
        
    }
    
    func layoutAllConstraints(field: UIView) {
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leadingAnchor.constraint(equalTo: self.formElementFieldView.leadingAnchor).isActive = true
        field.trailingAnchor.constraint(equalTo: self.formElementFieldView.trailingAnchor).isActive = true
        field.topAnchor.constraint(equalTo: self.formElementFieldView.topAnchor).isActive = true
        field.bottomAnchor.constraint(equalTo: self.formElementFieldView.bottomAnchor).isActive = true
    }
    
    //MARK:- Refresh Functions
    private func setViewRefreshNeeded(_ caller:String) {
        print("Refreshing View for \(formElementTitle.text) at Index \(self.index) from \(caller)")
        self.delegate?.refreshView?(index: self.index)
    }
    
    
    class func refreshTableView(_ tableView: UITableView) {
        
        DispatchQueue.main.async {
            //https://stackoverflow.com/questions/30108805/uitableview-scrolls-to-top-on-cell-refresh
            
            if tableView.window != nil{
                UIView.setAnimationsEnabled(false)
                let offset = tableView.contentOffset
                tableView.beginUpdates()
                tableView.endUpdates()
                tableView.setContentOffset(offset, animated: false)
                UIView.setAnimationsEnabled(true)
            }
            
        }
        
    }
    
    //MARK:- Validation Functions
    
    func validateRequiredItems(_ items: [Any]) {
        
        if self.isRequired {
            
            if items.count == 0 {
                let errorMessage = self.isRequiredErrorMessage
                setErrorMessage(errorMessage)
                self.delegate?.setError?(index: self.index, error: errorMessage)
            }
                
            else if !self.formElementErrorStackView.isHidden {
                handleFieldEditingStart()
                self.delegate?.setError?(index: self.index, error: "")
            }
            
        }
        
    }
    
    func validateField(_ field: UIView, callback: (_ errorMessage: String, _ error: ValidationError?) -> Void) {
        
        var errorMessage = ""
        
        self.currentValidator.validateField(field as! ValidatableField) { (error) in
            if error == nil {
                errorMessage = ""
            } else {
                
                errorMessage = error?.errorMessage ?? ""
                
                setErrorMessage(errorMessage, errorLabel: error?.errorLabel)
            }
            
            callback(errorMessage, error)
        }
        
    }
    
    class func validateRequiredFormField(isRequired: Bool, fieldValue:Any?, fieldIndexRow: Int, fieldIndexSection: Int = 0, errorsArray:[IndexPath: String], errorString:String? = nil) -> [IndexPath : String] {
        
        var errors:[IndexPath: String] = errorsArray
        
        var errorMessage = ""
        
        if isRequired {
            
            if let value = errorString {
                errorMessage = value
            } else {
                errorMessage = "This field is required"
            }
            
            if fieldValue == nil {
                errors[IndexPath(row: fieldIndexRow, section: fieldIndexSection)] = errorMessage
            }
                
            else if let value = fieldValue as? [Any], value.count == 0 {
                errors[IndexPath(row: fieldIndexRow, section: fieldIndexSection)] = errorMessage
            }
                
            else if let value = fieldValue as? [[Any]], value[0].count == 0 {
                errors[IndexPath(row: fieldIndexRow, section: fieldIndexSection)] = errorMessage
            }
                
            else if let value = fieldValue as? String, value.isEmpty {
                errors[IndexPath(row: fieldIndexRow, section: fieldIndexSection)] = errorMessage
            }
                
            else if let value = fieldValue as? Bool, value == false {
                errors[IndexPath(row: fieldIndexRow, section: fieldIndexSection)] = errorMessage
            }
                
            else if errors[IndexPath(row: fieldIndexRow, section: fieldIndexSection)] == errorMessage {
                errorMessage = ""
            }
            
        }
        
        if errorMessage.isEmpty {
            errors.removeValue(forKey: IndexPath(row: fieldIndexRow, section: fieldIndexSection))
        }
        
        return errors
        
    }
    
}

extension ReusableFormElementView: ReusableFormTextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setFieldStyling()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
        if let value = textField.text, !value.isEmpty && (self.formElementTitle.isHidden || !self.formElementErrorStackView.isHidden) {
            handleFieldEditingStart()
        } else {
            handleFieldEditingEnd(text: textField.text!)
        }
        
        
        self.delegate?.setValues?(index: self.index, item: textField.text!)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        resetFieldStyling()
        
        self.textFieldDidChange(textField)
        
        if let text = textField.text, !text.isEmpty || isRequired {
            validateField(textField) { (errorMessage, error) in
                self.delegate?.setError?(index: self.index, error: errorMessage)
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension ReusableFormElementView: ReusableFormTextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setFieldStyling()
    }
    
    func viewDidChangeHeight(_ view: ReusableFormTextView, height: CGFloat) {
        view.frame.size.height = height
        self.updateHeight(height, shouldDelegate: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if (self.formElementTitle.isHidden || !self.formElementErrorStackView.isHidden) && !textView.text.isEmpty {
            handleFieldEditingStart()
        } else {
            handleFieldEditingEnd(text: textView.text)
        }
        
        self.delegate?.setValues?(index: self.index, item: textView.text)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        resetFieldStyling()
        
        self.textViewDidChange(textView)
        
        validateField(textView) { (errorMessage, error) in
            self.delegate?.setError?(index: self.index, error: errorMessage)
        }
        
    }
    
}

extension ReusableFormElementView: ReusableFormPopupFieldDelegate {
    
    func popupFieldViewDidChangeHeight(_ popupFieldView: ReusableFormPopupField, height: CGFloat) {
        self.updateHeight(height, shouldDelegate: true)
    }
    
    func popupFieldViewDidBeginEditing(_ popupFieldView: ReusableFormPopupField) {
        handleFieldEditingStart()
    }
    
    func popupFieldViewDidEndEditing(_ popupFieldView: ReusableFormPopupField, selectedItems: [Any]) {
        
        self.delegate?.setValues?(index: self.index, item: selectedItems)
        
        handleFieldEditingEnd(text: popupFieldView.textView.text)
        
        validateField(popupFieldView.textView) { (errorMessage, error) in
            self.delegate?.setError?(index: self.index, error: errorMessage)
        }
        
    }
    
}

extension ReusableFormElementView: ReusableFormSwitchDelegate {
    func switchStateChanged(id: Any, isOn: Bool) {
        self.delegate?.setValues?(index: self.index, item: isOn)
    }
}

extension ReusableFormElementView: ReusableFormSegmentedControllerDelegate {
    
    func segmentedControlValueChanged(id: Any, selectedIndex: Int, selectedItem: Any) {
        self.delegate?.setValues?(index: self.index, item: selectedIndex)
    }
    
}

extension ReusableFormElementView: ReusableFormOptionsFieldDelegate {
    
    func optionsFieldDidChangeHeight(height: CGFloat) {
        self.updateHeight(height, shouldDelegate: true)
    }
    
    func itemSaved(_ selectedItems: [Int]) {
        self.delegate?.setValues?(index: self.index, item: selectedItems)
        validateRequiredItems(selectedItems)
    }
    
}

extension ReusableFormElementView: ReusableFormFileFieldDelegate {
    
    func fileViewDidChangeHeight(_ fileView: ReusableFormFileField, height: CGFloat) {
        self.updateHeight(height, shouldDelegate: true)
    }
    
    func fileViewDidUpdateFiles(_ fileView: ReusableFormFileField, files: [[Any]]) {
        let data = files[0]
        validateRequiredItems(data)
        self.delegate?.setValues?(index: self.index, item: files)
    }
    
    func fileViewDidCancelAddingFiles(_ fileView: ReusableFormFileField, files: [Any]) {
        validateRequiredItems(files)
    }
}

extension ReusableFormElementView: ReusableFormSliderFieldDelegate {
    
    func viewDidUpdateValue(value: Any) {
        self.delegate?.setValues?(index: self.index, item: value)
    }
    
    func viewDidChangeSliderHeight(height: CGFloat) {
        self.updateHeight(height, shouldDelegate: true)
    }
}

extension ReusableFormElementView: TTReusableFormCheckboxFieldDelegate {
    
    func checkboxSelected(_ selectedItems: Any) {
        self.delegate?.setValues?(index: self.index, item: true)
        validateRequiredItems([selectedItems])
    }
    
    func checkboxDeselected(_ selectedItems: Any) {
        self.delegate?.setValues?(index: self.index, item: false)
        validateRequiredItems([])
    }
    
}

