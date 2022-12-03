//
//  FormElementStyler.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit

class FormElementStyler {
    
    typealias formTextFieldStyle = (font: UIFont,fontSize:CGFloat, textColor: UIColor , tintColor: UIColor , backgroundColor:  UIColor,placeholderColor : UIColor?, fieldBorderThickness: CGFloat? , fieldBorderEdges: UIRectEdge? , fieldBorderNormalColor: UIColor? , fieldBorderSelectedColor: UIColor?, leftLabelFont: UIFont? , leftLabelTextColor: UIColor?, accessoryBackgroundColor: UIColor?, accessoryBorderColor: UIColor?, saveButtonStyle: Styler.buttonBackgroundStyle? , cancelButtonStyle: Styler.buttonBackgroundStyle?,isCurvedBorder:Bool?,fieldRadius:CGFloat?,leftPadding:CGFloat?,rightPadding:CGFloat?,topPadding:CGFloat?,bottomPadding:CGFloat?,textFieldHeight:CGFloat?)
    
    typealias formElementViewStyle = (titleFontDefault: UIFont , titleFontSelected: UIFont , titleTextColorDefault: UIColor , titleTextColorSelected: UIColor , errorFont: UIFont , errorTextColor: UIColor , errorImage: String? , errorImageRenderingMode: UIImage.RenderingMode , errorImageTintColor: UIColor ,formBackgroundColor : UIColor, nonEditableFieldAlpha:CGFloat)
    
    struct FormHelper {
        static var imagePickerControllerBarTintColor: UIColor { return UIColor.SORT.blue.getColorWithTranslucency(true) }
        static var imagePickerControllerTintColor: UIColor { return UIColor.SORT.white }
        static var imagePickerControllerDoneButtonFont: UIFont { return UIFont.SORT.InterBold.withSize(14) }
        static var imagePickerControllerDoneButtonColor: UIColor { return UIColor.SORT.white }
        static var imagePickerControllerCancelButtonFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var imagePickerControllerCameraTintColor: UIColor { return UIColor.SORT.green }
        static var imagePickerControllerCameraLabelFont: UIFont { return UIFont.SORT.InterBold.withSize(14)  }
        static var imagePickerControllerCameraCheckboxFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var imagePickerControllerCameraCheckoboxLabelColor: UIColor { return UIColor.SORT.white }
        static var imagePickerControllerCameraCheckboxTintColor: UIColor { return UIColor.SORT.green }
    }
    
    struct FormElementView {
        static var titleFontDefault: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var titleFontSelected: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var titleTextColorDefault: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.5) }
        static var titleTextColorSelected: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.8) }
        
        static var errorFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(11.0) }
        static var errorTextColor: UIColor { return UIColor.SORT.red }
        static var errorImage: String? { return "Form-Icon-Warning" }
        static var errorImageRenderingMode: UIImage.RenderingMode { return .alwaysTemplate }
        static var errorImageTintColor: UIColor { return UIColor.SORT.red }
        static var formBackgroundColor : UIColor{return UIColor.clear}
        
        static var nonEditableFieldAlpha:CGFloat = 0.5
    }
    
    struct TextField {
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var textColor: UIColor { return UIColor.SORT.fontBlack }
        static var tintColor: UIColor { return UIColor.SORT.fontBlack }
        static var backgroundColor:  UIColor { return UIColor.SORT.clear }
        
        static var fieldBorderThickness: CGFloat { return Styler.borderThickness }
        static var fieldBorderEdges: UIRectEdge { return [UIRectEdge.bottom] }
        static var fieldBorderNormalColor: UIColor { return UIColor.SORT.clear }
        static var fieldBorderSelectedColor: UIColor { return UIColor.SORT.clear }
        static var placeholderColor: UIColor{return UIColor.SORT.fontBlack.withAlphaComponent(0.5)}
        
        static var leftLabelFont: UIFont { return UIFont.SORT.InterBold.withSize(14) }
        static var leftLabelTextColor: UIColor { return UIColor.SORT.fontBlack }
        static var fieldRadiusCorner:CGFloat{return 0.0}
        static var leftPadding:CGFloat{return 0.0}
        static var rightPadding:CGFloat{return 0.0}
        static var topPadding:CGFloat{return 0.0}
        static var bottomPadding:CGFloat{return 0.0}
        static var accessoryBackgroundColor: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.5) }
        static var accessoryBorderColor: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.5) }
        static var saveButtonStyle: Styler.buttonBackgroundStyle {
            var buttonStyle = ButtonStyles.greenButton
            buttonStyle.shadowStyle = nil
            buttonStyle.cornerRadius = 0
            return buttonStyle}
        static var cancelButtonStyle: Styler.buttonBackgroundStyle {
            var buttonStyle = ButtonStyles.inverseGreenButtonPlain
            buttonStyle.shadowStyle = nil
            buttonStyle.cornerRadius = 0
            return buttonStyle}
     
    }
    
    struct TextView {
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var textColor: UIColor { return UIColor.SORT.fontBlack }
        static var backgroundColor:  UIColor { return UIColor.SORT.clear }
        
        static var fieldBorderThickness: CGFloat { return Styler.borderThickness }
        static var fieldBorderEdges: UIRectEdge { return [UIRectEdge.bottom] }
        static var fieldBorderNormalColor: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.5) }
        static var fieldBorderSelectedColor: UIColor { return UIColor.SORT.fontBlack }
        
        static var charactersFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var charactersTextColor: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.6) }
    }
    
    struct Popup {
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var textColor: UIColor { return UIColor.SORT.fontBlack }
        static var backgroundColor:  UIColor { return UIColor.SORT.clear }
        
        static var fieldBorderThickness: CGFloat { return Styler.borderThickness }
        static var fieldBorderEdges: UIRectEdge { return [UIRectEdge.bottom] }
        static var fieldBorderNormalColor: UIColor { return UIColor.SORT.separatorGray }
        static var fieldBorderSelectedColor: UIColor { return UIColor.SORT.green }
        
        static var popupViewBarTintColor: UIColor {return UIColor.SORT.blue.getColorWithTranslucency(true) }
        static var popupViewTintColor: UIColor {return UIColor.SORT.white }
        static var popupViewBarTextColor: UIColor {return UIColor.SORT.fontWhite }
        static var popupViewBarFont: UIFont {return UIFont.SORT.InterBold.withSize(14.0) }
        
        static var headerViewBackgroundColor: UIColor { return UIColor.SORT.white }
        static var headerViewFont: UIFont { return UIFont.SORT.InterBold.withSize(14.0) }
        static var headerViewTextColor: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.4) }
        
        static var rightImageRenderingMode: UIImage.RenderingMode { return .alwaysTemplate }
        static var rightImageTintColor: UIColor { return UIColor.SORT.blue }
        
        static var saveButtonStyle: Styler.buttonBackgroundStyle {  var buttonStyle = ButtonStyles.blueButton
            buttonStyle.shadowStyle = nil
            buttonStyle.cornerRadius = 0
            return buttonStyle}
        static var selectAllClearButtonStyle: Styler.buttonBackgroundStyle { var buttonStyle = ButtonStyles.inverseBlueButton
            buttonStyle.shadowStyle = nil
            buttonStyle.cornerRadius = 0
            return buttonStyle}
        
        static var innerFieldFontDefault: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var innerFieldFontSelected: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var innerFieldTextColorDefault: UIColor { return UIColor.SORT.fontBlack }
        static var innerFieldTextColorSelected: UIColor { return UIColor.SORT.fontBlack }
    }
    
    struct Switcher {
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var textColor: UIColor { return UIColor.SORT.fontBlack }
        static var tintColor:  UIColor { return UIColor.SORT.green }
    }
    
    struct SegmentedController {
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var textColor: UIColor { return UIColor.SORT.fontBlack }
        static var selectedFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var selectedTextColor: UIColor { return UIColor.SORT.fontWhite }
        static var tintColor:  UIColor { return UIColor.SORT.green }
    }
    
    struct Options {
        static var fieldBackgroundColor:UIColor { return UIColor.SORT.clear }
        static var fieldHeaderFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var fieldHeaderTextColor: UIColor { return UIColor.SORT.fontBlack }
        static var fieldHeaderSelectAllFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var fieldHeaderSelectAllTextColor: UIColor { return UIColor.SORT.fontBlack.withAlphaComponent(0.7) }
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var leftImageRenderingMode: UIImage.RenderingMode { return .alwaysTemplate }
        static var leftImageTintColor: UIColor { return UIColor.SORT.blue }
        static var leftImageCheckboxDefault: String { return "Form-Checkbox-Default" }
        static var leftImageCheckboxSelected: String { return "Form-Checkbox-Selected" }
        static var leftImageRadiobuttonDefault: String { return "Form-Radiobutton-Default" }
        static var leftImageRadiobuttonSelected: String { return "Form-Radiobutton-Selected" }
        static var fieldDefaultFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var fieldSelectedFont: UIFont { return UIFont.SORT.InterBold.withSize(14) }
        static var fieldDefaultTextColor: UIColor { return UIColor.SORT.fontBlack }
        static var fieldSelectedTextColor: UIColor { return UIColor.SORT.fontBlack }
    }
    
    struct Image {
        static var fieldDeleteImageDefault: String { return "Form-Image-Delete" }
        static var fieldDeleteImageRenderingMode: UIImage.RenderingMode { return .alwaysOriginal }
        static var fieldDeleteImageTintColor: UIColor { return UIColor.SORT.green }
        static var fieldAddEditFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var fieldAddEditBackgroundColor: UIColor { return UIColor.SORT.fontBlack }
        static var fieldAddEditTextColor: UIColor { return UIColor.SORT.fontWhite }
        
        static var imageViewStyle: Styler.viewStyle { return (backgroundColor: UIColor.SORT.imageBackgroundColor, cornerRadius: 0.0, borderStyle: (edges: .all, thickness: 1.0, color: UIColor.SORT.separatorGray),shadowStyle : nil) }
       
    }
    
    struct File {
        static var galleryBackgroundColor: UIColor { return UIColor.SORT.clear }
        
        static var fieldDeleteImageDefault: String { return "Form-Image-Delete" }
        static var fieldDeleteImageRenderingMode: UIImage.RenderingMode { return .alwaysOriginal }
        static var fieldDeleteImageTintColor: UIColor { return UIColor.SORT.green }
        static var fieldAddEditFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var fieldAddEditBackgroundColor: UIColor { return UIColor.SORT.fontBlack }
        static var fieldAddEditTextColor: UIColor { return UIColor.SORT.fontWhite }
        
        static var fileActionSheetTextColor: UIColor { return UIColor.SORT.green }
        
        static var fileViewStyle: Styler.viewStyle { return (backgroundColor: UIColor.SORT.imageBackgroundColor, cornerRadius: 0.0, borderStyle: (edges: .all, thickness: 1.0, color: UIColor.SORT.separatorGray),shadowStyle : nil) }
        
        static var uploadDocumentHolderSpacing: CGFloat { return 10.0 }
        
        static var addDocumentButtonStyle: Styler.buttonBackgroundStyle { return TTFileStyler.addDocumentButtonStyle }
        
        static var addImageButtonStyle: Styler.buttonBackgroundStyle { return TTFileStyler.addImageButtonStyle }
        
        static var editDocumentButtonStyle: Styler.buttonBackgroundStyle { return TTFileStyler.editDocumentButtonStyle }
        
        static var buttonImagePadding: CGFloat { return 10.0 }
        
        static var maxFileSize: Double = 8
        
        /// File size validation error message
        /// This will be displayed when user uploads file with greater size than maxFileSize
        static var fileSizeErrorMessage: String = "File size cannot exceed %g MB"
        
    }
    
    struct Checkbox {
        static var font: UIFont { return UIFont.SORT.MontserratRegular.withSize(14) }
        static var textColor: UIColor { return UIColor.SORT.fontBlack }
        static var tintColor: UIColor { return UIColor.SORT.blue }
        static var leftImageDefault: String { return "Form-Checkbox-Default" }
        static var leftImageSelected: String { return "Form-Checkbox-Selected" }
    }
    
    struct Slider {
        static var titleFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var titleColor: UIColor { return UIColor.SORT.fontBlack }
        
        static var statusFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(12) }
        static var statusColor: UIColor { return UIColor.SORT.fontBlack }
        
        static var levelsLabelFont: UIFont { return UIFont.SORT.MontserratRegular.withSize(10) }
        static var levelsLabelColor: UIColor { return UIColor.SORT.separatorGray }
        
        static var sliderColor: UIColor { return UIColor.SORT.green }
        static var sliderTrackBackgroundColor: UIColor { return UIColor.SORT.separatorGray }
    }
    
}

class TTFileStyler {
    
    //Base Button for All Buttons
    private static var baseButtonStyle: Styler.buttonBackgroundStyle {
        get {
            var button = Styler.baseButtonStyle
            button.font = UIFont.SORT.InterBold.withSize(14)
            button.titleColor = UIColor.SORT.fontWhite
            button.backgroundColor = UIColor.SORT.clear
            button.cornerRadius = 0
            button.borderStyle = (edges: .all, color: UIColor.SORT.black, thickness: 1.0)
            button.tintColor = UIColor.SORT.black
            button.buttonImageRenderingMode = .alwaysTemplate
            return button
        }
    }
    
    static var addDocumentButtonStyle: Styler.buttonBackgroundStyle {
        get {
            var button = TTFileStyler.baseButtonStyle
            button.buttonImage = "Form-Add-Document"
            return button
        }
    }
    
    static var addImageButtonStyle: Styler.buttonBackgroundStyle {
        get {
            var button = TTFileStyler.baseButtonStyle
            button.buttonImage = "Form-Add-Image"
            return button
        }
    }
    
    static var editDocumentButtonStyle: Styler.buttonBackgroundStyle {
        get {
            var button = TTFileStyler.baseButtonStyle
            button.buttonImage = "Form-Edit-Document"
            return button
        }
    }
    
}

class TTFormElementViewStyler{
    static let defaultStyle : FormElementStyler.formElementViewStyle = (titleFontDefault: FormElementStyler.FormElementView.titleFontDefault , titleFontSelected: FormElementStyler.FormElementView.titleFontSelected , titleTextColorDefault: FormElementStyler.FormElementView.titleTextColorDefault , titleTextColorSelected: FormElementStyler.FormElementView.titleTextColorSelected , errorFont: FormElementStyler.FormElementView.errorFont , errorTextColor: FormElementStyler.FormElementView.errorTextColor , errorImage: FormElementStyler.FormElementView.errorImage , errorImageRenderingMode: FormElementStyler.FormElementView.errorImageRenderingMode , errorImageTintColor: FormElementStyler.FormElementView.errorImageTintColor ,formBackgroundColor:FormElementStyler.FormElementView.formBackgroundColor, nonEditableFieldAlpha:FormElementStyler.FormElementView.nonEditableFieldAlpha)
    
    
    static let userDetailsStyle : FormElementStyler.formElementViewStyle = (titleFontDefault: UIFont.SORT.MontserratThin.withSize(24) , titleFontSelected: UIFont.SORT.MontserratThin.withSize(24), titleTextColorDefault: UIColor.SORT.fontBlack , titleTextColorSelected: UIColor.SORT.fontBlack , errorFont: FormElementStyler.FormElementView.errorFont , errorTextColor: FormElementStyler.FormElementView.errorTextColor , errorImage: FormElementStyler.FormElementView.errorImage , errorImageRenderingMode: FormElementStyler.FormElementView.errorImageRenderingMode , errorImageTintColor: FormElementStyler.FormElementView.errorImageTintColor ,formBackgroundColor:FormElementStyler.FormElementView.formBackgroundColor, nonEditableFieldAlpha:FormElementStyler.FormElementView.nonEditableFieldAlpha)
    
    static let blackStyle : FormElementStyler.formElementViewStyle = (titleFontDefault: FormElementStyler.FormElementView.titleFontDefault , titleFontSelected: FormElementStyler.FormElementView.titleFontSelected , titleTextColorDefault: UIColor.SORT.fontBlack.withAlphaComponent(0.8) , titleTextColorSelected: UIColor.SORT.fontBlack , errorFont: FormElementStyler.FormElementView.errorFont , errorTextColor: FormElementStyler.FormElementView.errorTextColor , errorImage: FormElementStyler.FormElementView.errorImage , errorImageRenderingMode: FormElementStyler.FormElementView.errorImageRenderingMode , errorImageTintColor: FormElementStyler.FormElementView.errorImageTintColor ,formBackgroundColor:UIColor.SORT.fontBlack.withAlphaComponent(0.02), nonEditableFieldAlpha:FormElementStyler.FormElementView.nonEditableFieldAlpha)
    
    static let lightStyle : FormElementStyler.formElementViewStyle = (titleFontDefault: FormElementStyler.FormElementView.titleFontDefault , titleFontSelected: FormElementStyler.FormElementView.titleFontSelected , titleTextColorDefault: UIColor.SORT.fontWhite.withAlphaComponent(0.8) , titleTextColorSelected: UIColor.SORT.fontWhite , errorFont: FormElementStyler.FormElementView.errorFont , errorTextColor: FormElementStyler.FormElementView.errorTextColor , errorImage: FormElementStyler.FormElementView.errorImage , errorImageRenderingMode: FormElementStyler.FormElementView.errorImageRenderingMode , errorImageTintColor: FormElementStyler.FormElementView.errorImageTintColor ,formBackgroundColor:UIColor.SORT.fontBlack.withAlphaComponent(0.02), nonEditableFieldAlpha:FormElementStyler.FormElementView.nonEditableFieldAlpha)
    
    static let blueStyle : FormElementStyler.formElementViewStyle = (titleFontDefault: FormElementStyler.FormElementView.titleFontDefault , titleFontSelected: FormElementStyler.FormElementView.titleFontSelected , titleTextColorDefault: UIColor.SORT.blue.withAlphaComponent(0.8) , titleTextColorSelected: UIColor.SORT.blue , errorFont: FormElementStyler.FormElementView.errorFont , errorTextColor: FormElementStyler.FormElementView.errorTextColor , errorImage: FormElementStyler.FormElementView.errorImage , errorImageRenderingMode: FormElementStyler.FormElementView.errorImageRenderingMode , errorImageTintColor: FormElementStyler.FormElementView.errorImageTintColor ,formBackgroundColor:UIColor.SORT.fontBlack.withAlphaComponent(0.02), nonEditableFieldAlpha:FormElementStyler.FormElementView.nonEditableFieldAlpha)
}

class TTTextFieldStyler{
    static let defaultStyle : FormElementStyler.formTextFieldStyle = (font: FormElementStyler.TextField.font ,fontSize:14.0, textColor: FormElementStyler.TextField.textColor , tintColor: FormElementStyler.TextField.tintColor ,  backgroundColor:  FormElementStyler.TextField.backgroundColor, placeholderColor : FormElementStyler.TextField.placeholderColor,fieldBorderThickness: FormElementStyler.TextField.fieldBorderThickness , fieldBorderEdges: FormElementStyler.TextField.fieldBorderEdges , fieldBorderNormalColor: FormElementStyler.TextField.fieldBorderNormalColor , fieldBorderSelectedColor:FormElementStyler.TextField.fieldBorderSelectedColor, leftLabelFont: FormElementStyler.TextField.leftLabelFont , leftLabelTextColor: FormElementStyler.TextField.leftLabelTextColor, accessoryBackgroundColor: FormElementStyler.TextField.accessoryBorderColor, accessoryBorderColor: FormElementStyler.TextField.accessoryBackgroundColor, saveButtonStyle: FormElementStyler.TextField.saveButtonStyle  , cancelButtonStyle: FormElementStyler.TextField.cancelButtonStyle,isCurvedBorder:true,fieldRadius:FormElementStyler.TextField.fieldRadiusCorner,leftPadding:FormElementStyler.TextField.leftPadding,rightPadding: FormElementStyler.TextField.rightPadding, topPadding: FormElementStyler.TextField.topPadding, bottomPadding: FormElementStyler.TextField.bottomPadding,textFieldHeight: nil)
    static let defaultBorderStyle : FormElementStyler.formTextFieldStyle = (font: FormElementStyler.TextField.font ,fontSize:14.0 , textColor: FormElementStyler.TextField.textColor , tintColor: FormElementStyler.TextField.tintColor ,  backgroundColor:  FormElementStyler.TextField.backgroundColor, placeholderColor : FormElementStyler.TextField.placeholderColor,fieldBorderThickness: FormElementStyler.TextField.fieldBorderThickness , fieldBorderEdges: FormElementStyler.TextField.fieldBorderEdges , fieldBorderNormalColor: FormElementStyler.TextField.fieldBorderNormalColor , fieldBorderSelectedColor:FormElementStyler.TextField.fieldBorderSelectedColor, leftLabelFont: FormElementStyler.TextField.leftLabelFont , leftLabelTextColor: FormElementStyler.TextField.leftLabelTextColor, accessoryBackgroundColor: FormElementStyler.TextField.accessoryBorderColor, accessoryBorderColor: FormElementStyler.TextField.accessoryBackgroundColor, saveButtonStyle: FormElementStyler.TextField.saveButtonStyle  , cancelButtonStyle: FormElementStyler.TextField.cancelButtonStyle,isCurvedBorder:false,fieldRadius:FormElementStyler.TextField.fieldRadiusCorner,leftPadding:FormElementStyler.TextField.leftPadding,rightPadding: FormElementStyler.TextField.rightPadding, topPadding: FormElementStyler.TextField.topPadding, bottomPadding: FormElementStyler.TextField.bottomPadding,textFieldHeight: nil)
    
    static let userDetailsStyle : FormElementStyler.formTextFieldStyle = (font: UIFont.SORT.MontserratRegular.withSize(16),fontSize:24.0 , textColor: FormElementStyler.TextField.textColor , tintColor: FormElementStyler.TextField.tintColor ,  backgroundColor:  FormElementStyler.TextField.backgroundColor, placeholderColor : FormElementStyler.TextField.placeholderColor,fieldBorderThickness: 0.6 , fieldBorderEdges: .all , fieldBorderNormalColor: UIColor.SORT.textBorderGrey , fieldBorderSelectedColor: UIColor.SORT.gray, leftLabelFont: FormElementStyler.TextField.leftLabelFont , leftLabelTextColor: FormElementStyler.TextField.leftLabelTextColor, accessoryBackgroundColor: FormElementStyler.TextField.accessoryBorderColor, accessoryBorderColor: FormElementStyler.TextField.accessoryBackgroundColor, saveButtonStyle: FormElementStyler.TextField.saveButtonStyle  , cancelButtonStyle: FormElementStyler.TextField.cancelButtonStyle,isCurvedBorder:true,fieldRadius:5.0,leftPadding: 6.0,rightPadding: FormElementStyler.TextField.rightPadding, topPadding: FormElementStyler.TextField.topPadding, bottomPadding: FormElementStyler.TextField.bottomPadding,textFieldHeight: 48.0 )
    
    static let blackStyle : FormElementStyler.formTextFieldStyle = (font: FormElementStyler.TextField.font,fontSize:14.0 , textColor: UIColor.SORT.fontBlack , tintColor: UIColor.SORT.fontBlack ,  backgroundColor:  FormElementStyler.TextField.backgroundColor, placeholderColor : UIColor.SORT.fontBlack.withAlphaComponent(0.5),fieldBorderThickness: FormElementStyler.TextField.fieldBorderThickness , fieldBorderEdges: FormElementStyler.TextField.fieldBorderEdges , fieldBorderNormalColor: UIColor.SORT.fontBlack.withAlphaComponent(0.8) , fieldBorderSelectedColor:UIColor.SORT.fontBlack, leftLabelFont: FormElementStyler.TextField.leftLabelFont , leftLabelTextColor: UIColor.SORT.fontBlack, accessoryBackgroundColor: UIColor.SORT.fontBlack.withAlphaComponent(0.5), accessoryBorderColor: UIColor.SORT.fontBlack.withAlphaComponent(0.5), saveButtonStyle: FormElementStyler.TextField.saveButtonStyle  , cancelButtonStyle: FormElementStyler.TextField.cancelButtonStyle,isCurvedBorder:false,fieldRadius:FormElementStyler.TextField.fieldRadiusCorner,leftPadding:FormElementStyler.TextField.leftPadding,rightPadding: FormElementStyler.TextField.rightPadding, topPadding: FormElementStyler.TextField.topPadding, bottomPadding: FormElementStyler.TextField.bottomPadding,textFieldHeight: nil)
    
    static let blueStyle : FormElementStyler.formTextFieldStyle = (font: FormElementStyler.TextField.font,fontSize:14.0 , textColor: UIColor.SORT.fontBlack , tintColor: UIColor.SORT.blue ,  backgroundColor:  FormElementStyler.TextField.backgroundColor, placeholderColor : UIColor.SORT.fontBlack.withAlphaComponent(0.5),fieldBorderThickness: FormElementStyler.TextField.fieldBorderThickness , fieldBorderEdges: FormElementStyler.TextField.fieldBorderEdges , fieldBorderNormalColor: UIColor.SORT.fontBlack.withAlphaComponent(0.8) , fieldBorderSelectedColor:UIColor.SORT.blue, leftLabelFont: FormElementStyler.TextField.leftLabelFont , leftLabelTextColor: UIColor.SORT.blue, accessoryBackgroundColor: UIColor.SORT.fontBlack.withAlphaComponent(0.5), accessoryBorderColor: UIColor.SORT.fontBlack.withAlphaComponent(0.5), saveButtonStyle: FormElementStyler.TextField.saveButtonStyle  , cancelButtonStyle: FormElementStyler.TextField.cancelButtonStyle,isCurvedBorder:false,fieldRadius:FormElementStyler.TextField.fieldRadiusCorner,leftPadding:FormElementStyler.TextField.leftPadding,rightPadding: FormElementStyler.TextField.rightPadding, topPadding: FormElementStyler.TextField.topPadding, bottomPadding: FormElementStyler.TextField.bottomPadding,textFieldHeight: nil)
}

