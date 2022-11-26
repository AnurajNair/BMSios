//
//  Styler.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit

class Styler {
    
    static let borderThickness: CGFloat = 1.0
    typealias textStyle = (font: UIFont,color: UIColor)
    typealias textBackgroundStyle = (font: UIFont,textColor: UIColor, backgroundColor: UIColor)
    typealias borderStyle = (edges: UIRectEdge, color: UIColor, thickness: CGFloat)
    typealias viewStyle = (backgroundColor: UIColor?, cornerRadius: CGFloat?, borderStyle:borderStyle? , shadowStyle : shadowStyle?)
    typealias buttonBackgroundStyle = (font: UIFont, titleColor: UIColor, backgroundColor: UIColor?, cornerRadius: CGFloat?, borderStyle:borderStyle?, tintColor: UIColor?, buttonImage: String?, buttonImageInsets: UIEdgeInsets?, buttonImageRenderingMode: UIImage.RenderingMode?, isUnderlined: Bool?, overrideDefaultTextCase:Bool?, shadowStyle: shadowStyle?, contentEdgeInsets: UIEdgeInsets?)
    typealias buttonImageStyle = (normal: String, highlighted: String, selected: String, disabled:String, renderingMode: UIImage.RenderingMode, imageInsets: UIEdgeInsets?)
    typealias shadowStyle = (cornerRadius: CGFloat, shadowRadius: CGFloat, opacity: Float, color: UIColor, shadowOffset: CGSize, frameOffset: CGSize)
    
    static let baseButtonStyle: Styler.buttonBackgroundStyle = (font: UIFont.systemFont(ofSize: 14.0),
                                                                titleColor: UIColor.white,
                                                                backgroundColor: nil,
                                                                cornerRadius: 10,
                                                                borderStyle: nil,
                                                                tintColor: UIColor.white,
                                                                buttonImage: "",
                                                                buttonImageInsets: nil,
                                                                buttonImageRenderingMode: .automatic,
                                                                isUnderlined: false,
                                                                overrideDefaultTextCase: false,
                                                                shadowStyle: nil,
                                                                contentEdgeInsets: nil)
    
}

class ShadowLayer: UIView {
    //https://stackoverflow.com/questions/37645408/uitableviewcell-rounded-corners-and-shadow
    override var bounds: CGRect {
        didSet {
            setupViewShadow()
            
        }
    }
    var isShadow : Bool = true{
        didSet{
            //self.layer.isHidden = !isShadow
            if isShadow{
                self.layer.shadowOpacity = 0.2
            }else{
                self.layer.shadowOpacity = 0
            }
        }
    }
    var cornerRadius: CGFloat = 1.5 {
        didSet {
            setupViewShadow()
        }
    }
    private func setupViewShadow() {
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        self.layer.shadowRadius = 1.5
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 1.5, height: 0.5)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension CGFloat {
    struct FontSize {
        static func get(_ size: CGFloat) -> CGFloat
        {
            return size
        }
    }
}

extension UIColor {
    func getColorWithTranslucency(_ isTranslucent: Bool = true) -> UIColor {
        
        let colorComponents =  self.getRGBAComponents()
        
        if !isTranslucent || colorComponents == nil {
            return self
        }
            
        else {
            
            let red = colorComponents!.red
            let green = colorComponents!.green
            let blue = colorComponents!.blue
            let alpha = colorComponents!.alpha
            
            let minimumColorValue:CGFloat = 40
            let maximumColorValue:CGFloat = 255.0
            let newRed = red >= minimumColorValue ? getNewValueForColor(red) : red
            let newGreen = green >= minimumColorValue ? getNewValueForColor(green) : green
            let newBlue = blue >= minimumColorValue ? getNewValueForColor(blue) : blue
            
            return UIColor(red: newRed/maximumColorValue, green: newGreen/maximumColorValue, blue: newBlue/maximumColorValue, alpha: alpha)
            
        }
        
    }
    
    //Credit: https://gist.github.com/StefanJager/73e87f400479b6c13f1e
    func getRGBAComponents() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)?
    {
        let maximumColorValue:CGFloat = 255.0
        var (red, green, blue, alpha) = (CGFloat(0.0), CGFloat(0.0), CGFloat(0.0), CGFloat(0.0))
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        {
            return (red * maximumColorValue, green * maximumColorValue, blue * maximumColorValue, alpha)
        }
        else
        {
            return nil
        }
    }
    
    private func getNewValueForColor(_ color: CGFloat) -> CGFloat {
        let minimumColorValue:CGFloat = 40.0
        let maximumColorValue:CGFloat = 255.0
        let baseColorValue:CGFloat = 1.0
        return (color - minimumColorValue) / (baseColorValue - (minimumColorValue / maximumColorValue))
    }
    
    class func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    class func color(HEXValue: String, alpha: CGFloat = 1.0) -> UIColor {
        var newHEXValue:String = HEXValue.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (newHEXValue.hasPrefix("#")) {
            newHEXValue.remove(at: newHEXValue.startIndex)
        }
        
        if ((newHEXValue.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: newHEXValue).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    func getComplementaryForColor() -> UIColor{
        
        let ciColor = CIColor(color: self)
        
        // get the current values and make the difference from white:
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }
    
}

extension UILabel{
    class func style(_ items: [(view: UILabel?, style: Styler.textStyle)])
    {
        for (view, style) in items{
            view?.textColor = style.color
            view?.font = style.font
        }
    }
    
    class func style(_ items: [(view: UILabel?, style: Styler.textBackgroundStyle)])
    {
        for (view, style) in items{
            view?.textColor = style.textColor
            view?.backgroundColor = style.backgroundColor
            view?.font = style.font
        }
    }
}

extension UITextView{
    class func style(_ items: [(view: UITextView?, style: Styler.textStyle)])
    {
        for (view, style) in items{
            view?.textColor = style.color
            view?.font = style.font
        }
    }
}


extension UITextField {
    class func style(_ items: [(view: UITextField?, style: Styler.textStyle)])
    {
        for (view, style) in items{
            view?.textColor = style.color
            view?.font = style.font
        }
    }
}

extension UIButton
{
    func setCommonButtonTitle(_ title:String, state:UIControl.State) {
        self.setTitle(title, for: state)
    }
    
    private func applyBackgroundStyle(_ style: Styler.buttonBackgroundStyle)
    {
        if let backgroundColor = style.backgroundColor
        {
            self.backgroundColor = backgroundColor
        }
        
        self.setTitleColor(style.titleColor, for: UIControl.State.normal)
        self.setTitleColor(style.titleColor, for: UIControl.State.selected)
        self.setTitleColor(style.titleColor, for: UIControl.State.highlighted)
        
        self.titleLabel?.font = style.font
        
        if let backgroundColor = style.backgroundColor
        {
            self.backgroundColor = backgroundColor
        }
        if let cornerRadius = style.cornerRadius
        {
            self.setAsRounded(cornerRadius: cornerRadius)
        }
        if let borderStyle = style.borderStyle
        {
            if borderStyle.edges == .all {
                self.setupBorderViaLayer(color: borderStyle.color, thickness: borderStyle.thickness)
            }
                
            else {
                self.addBorders(edges: borderStyle.edges, color: borderStyle.color, thickness: borderStyle.thickness)
            }
        }
        if let tintColor = style.tintColor
        {
            self.tintColor = tintColor
        }
       
        if let buttonImage = style.buttonImage
        {
            var imageRenderingMode = UIImage.RenderingMode.automatic
            
            if let buttonImageRenderingMode = style.buttonImageRenderingMode {
                imageRenderingMode = buttonImageRenderingMode
            }
            
            UIButton.styleImageButton([(view: self, style: (normal: buttonImage, highlighted: buttonImage, selected: buttonImage, disabled:buttonImage, renderingMode: imageRenderingMode, imageInsets: style.buttonImageInsets))])
            
        }
        else {
            self.setImage(nil, for: UIControl.State())
        }
        
        
        if let shadowStyle = style.shadowStyle {
            self.layer.shadowColor = shadowStyle.color.cgColor
            self.layer.shadowOffset = shadowStyle.shadowOffset
            self.layer.masksToBounds = false
            self.layer.shadowRadius = shadowStyle.shadowRadius
            self.layer.shadowOpacity = shadowStyle.opacity
        }
        
        if let contentInsets = style.contentEdgeInsets {
            self.contentEdgeInsets = contentInsets
        }
        
    }
    
    class func style(_ items: [(view: UIButton?, title: String?, style: Styler.buttonBackgroundStyle)])
    {
        for (view, title, style) in items{
            if let title = title {
                
                var titleString = title.capitalized
                
                if let overrideDefaultTextCase = style.overrideDefaultTextCase, overrideDefaultTextCase {
                    titleString = title
                }
                
                if let isUnderlined = style.isUnderlined, isUnderlined
                {
                    view?.setAttributedTitle(titleString.getUnderlined(textColor: style.titleColor, font: style.font), for: .normal)
                } else {
                    view?.setCommonButtonTitle(titleString, state: .normal)
                }
                
            }
            
            view?.applyBackgroundStyle(style)
            
        }
    }
    
    class func styleImageButton(_ items: [(view: UIButton?, style: Styler.buttonImageStyle)])
    {
        for (view, style) in items {
            view?.setImage(UIImage(named: style.normal)?.withRenderingMode(style.renderingMode), for: UIControl.State.normal)
            view?.setImage(UIImage(named: style.highlighted)?.withRenderingMode(style.renderingMode), for: UIControl.State.highlighted)
            view?.setImage(UIImage(named: style.selected)?.withRenderingMode(style.renderingMode), for: UIControl.State.selected)
            view?.setImage(UIImage(named: style.disabled)?.withRenderingMode(style.renderingMode), for: UIControl.State.disabled)
            
            if let buttonImageInsets = style.imageInsets {
                view?.imageEdgeInsets = buttonImageInsets
            }
        }
    }
}

extension UIView {
    
    class func style(_ items: [(view: UIView?, style: Styler.viewStyle)])
    {
        for (view, style) in items{
            if let backgroundColor = style.backgroundColor
            {
                view?.backgroundColor = backgroundColor
            }
            if let cornerRadius = style.cornerRadius
            {
                view?.setAsRounded(cornerRadius: cornerRadius)
            }
            if let borderStyle = style.borderStyle
            {
                view?.addBorders(edges: borderStyle.edges, color: borderStyle.color, thickness: borderStyle.thickness)
            }
            
            if let shadowStyle = style.shadowStyle {
                view?.layer.shadowColor = shadowStyle.color.cgColor
                view?.layer.shadowOffset = shadowStyle.shadowOffset
                view?.layer.masksToBounds = false
                view?.layer.shadowRadius = shadowStyle.shadowRadius
                view?.layer.shadowOpacity = shadowStyle.opacity
            }
        }
    }
    
    func setupBorderViaLayer(color: UIColor, thickness: CGFloat) {
        self.layer.borderWidth = thickness
        self.layer.borderColor = color.cgColor
    }
    
}

extension NSMutableAttributedString {
    
    @discardableResult func bold(_ text:String ,_ font : UIFont) -> NSMutableAttributedString {
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let boldString = NSMutableAttributedString(string: text, attributes: boldFontAttribute)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String,_ font : UIFont = UIFont.systemFont(ofSize: 12.0))->NSMutableAttributedString {
        let regularFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let normal =  NSMutableAttributedString(string: text, attributes: regularFontAttribute)
        self.append(normal)
        return self
    }
    
    @discardableResult func color(_ text:String , color : UIColor , _ font : UIFont =  UIFont.systemFont(ofSize: 12.0))->NSMutableAttributedString {
        let attr :[NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor : color , NSAttributedString.Key.font: font]
        let colorText =  NSAttributedString(string: text , attributes: attr)
        self.append(colorText)
        return self
    }
    
    @discardableResult func underline(_ appendText:String , color : UIColor, font: UIFont =  UIFont.systemFont(ofSize: 12.0), underlineStyle: Int = 1)->NSMutableAttributedString {
        
        let colorText =  NSMutableAttributedString(string: appendText)
        colorText.setUnderlineAttributes(color: color, font: font, foregroundColor: color, underlineStyle: underlineStyle)
        
        self.append(colorText)
        
        return self
    }
    
    func setUnderlineAttributes(color : UIColor, font: UIFont? = nil, foregroundColor: UIColor? = nil, underlineStyle: Int = 1,  range: NSRange? = nil) {
        
        let attr :[NSAttributedString.Key: Any] = [NSAttributedString.Key.underlineStyle : underlineStyle,
                                                  NSAttributedString.Key.underlineColor : color]
        
        var stringRange = NSRange(location: 0, length: self.length)
        
        if let value = range {
            stringRange = value
        }
        
        self.addAttributes(attr, range: stringRange)
        
        if let value = font {
            self.addAttribute(NSAttributedString.Key.font, value: value, range: stringRange)
        }
        
        if let value = foregroundColor {
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: value, range: stringRange)
        }
        
    }
    
    func addLink(_ link: String, attributes: [NSAttributedString.Key: Any], text: String) {
        let pattern = "(\(text))"
        let regex = try! NSRegularExpression.init(pattern: pattern,
                                                  options: NSRegularExpression.Options(rawValue: 0))
        let matches = regex.matches(in: self.string,
                                    options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange.init(location: 0, length: self.string.count))
        
        for result in matches {
            self.addAttribute(NSAttributedString.Key(rawValue: Constants.linkAttributeName), value: link,
                              range: result.range(at: 0))
            self.addAttributes(attributes, range: result.range(at: 0))
        }
    }
}

extension UIImage {
    
    func imageWithColor(_ color : UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0) -> UIImage {
        var rect : CGRect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        
        if width == 0 {
            rect.size.width = 1.0
        }
        
        if height == 0 {
            rect.size.height = 1.0
        }
        
        UIGraphicsBeginImageContext(rect.size)
        let context : CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

@IBDesignable
class EdgeInsetLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        //        let textRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top, left: -textInsets.left, bottom: -textInsets.bottom, right: -textInsets.right)
        return rect.inset(by: invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
}

extension EdgeInsetLabel {
    @IBInspectable
    var leftTextInset: CGFloat {
        get {
            return textInsets.left
        }
        set {
            textInsets.left = newValue
        }
    }
    
    @IBInspectable
    var rightTextInset: CGFloat {
        get {
            return textInsets.right
        }
        set {
            textInsets.right = newValue
        }
    }
    
    @IBInspectable
    var topTextInset: CGFloat {
        get {
            return textInsets.top
        }
        set {
            textInsets.top = newValue
        }
    }
    
    @IBInspectable
    var bottomTextInset: CGFloat {
        get {
            return textInsets.bottom
        }
        set {
            textInsets.bottom = newValue
        }
    }
}


