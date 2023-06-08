//
//  Utils.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit
import MBProgressHUD
import MessageUI
import WebKit
import RealmSwift
import CryptoSwift
import ObjectMapper

class Utils{
    
    static let userDefaultsSuite = "group.com.ios.appstore"
    
    static let loadingBackgroundViewTag = 84652
    
    static let progressViewTag = 94536
    
    class func showApiErrorMessage(_ error: ApiError?, title:String = "Error") {
        if error != nil && error?.message != "" {
            Utils.displayAlert(title: title, message: (error?.message)!)
        } else {
            Utils.displayAlert(title: title, message: Constants.Messages.unknownError)
        }
    }
    
    class func displayAlert(title: String, message: String, senderViewController: UIViewController? = nil, alertDisplayedHandler : @escaping ()-> Void = {}) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        alert.addAction(alertAction)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        var viewController = delegate.window?.topMostWindowController()
        if senderViewController != nil {
            viewController = senderViewController
        }
        if let _ = viewController?.presentedViewController as? UIAlertController{
            
        } else {
            viewController!.present(alert, animated: true, completion: {
                alertDisplayedHandler()
            })
        }
        
    }
    
    class func displayAlertController(_ title: String, message: String, viewC : UIViewController? = nil, isSingleBtn : Bool = true, cancelButtonTitle : String = "Cancel", submitButtonTitle : String = "Ok", okclickHandler : (() -> Void)?, cancelclickHandler : (() -> Void)?) -> UIAlertController{
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if !isSingleBtn{
            alert.addAction(UIAlertAction(title: cancelButtonTitle, style: .default, handler: {
                _ in
                if cancelclickHandler != nil {
                    cancelclickHandler!()
                }
            }))
        }
        alert.addAction(UIAlertAction(title:submitButtonTitle, style:.default, handler: {  _ in
            if okclickHandler != nil {
                okclickHandler!()
            }
        }))
        
        var presentingViewController = viewC
        
        if let rootController = UIApplication.shared.delegate?.window??.rootViewController, presentingViewController == nil {
            presentingViewController = rootController
        }
        
        if let viewController = presentingViewController, viewController.presentedViewController == nil {
            viewController.present(alert, animated: true, completion: nil)
        }
        
        return alert
    }
    
    class func displayActionSheet(title: String? = nil, message: String? = nil, viewTintColor: UIColor = UIColor.blue, actions : [(title: String, image : String, actionStyle: UIAlertAction.Style, actionCompletion: () -> Void)] = [], viewController: UIViewController? = nil , imageRendering : UIImage.RenderingMode = .alwaysTemplate) -> UIAlertController {
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.actionStyle, handler: { _ in
                action.actionCompletion()
            })
            if !action.image.isEmpty{
                let image = UIImage(named:action.image)?.withRenderingMode(imageRendering)
                alertAction.setValue(image , forKey: "image")
            }
            actionSheet.addAction(alertAction)
        }
        
        
        actionSheet.view.tintColor = viewTintColor
        
        var presentingViewController = viewController
        
        if let rootController = UIApplication.shared.delegate?.window??.rootViewController, presentingViewController == nil {
            presentingViewController = rootController
        }

        if let viewController = presentingViewController, viewController.presentedViewController == nil {
            /* Below two lines were added for single image upload in inspection for ipad
            actionSheet.popoverPresentationController?.sourceView = viewController.view
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 1)
             */
            viewController.present(actionSheet, animated: true, completion: nil)
        }

        return actionSheet
    }
    
    class func getSchemeKey(_ key: String) -> String {
        let plistPath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: plistPath!)
        return dict!["\(key)"] as! String
    }
    
    //MARK:- iOS Specific Functions
    
    class func getSafeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            
            if let topPadding = window?.safeAreaInsets.top, let bottomPadding = window?.safeAreaInsets.bottom {
                return (topPadding, bottomPadding)
            }
            
        }
        
        return (0.0, 0.0)
        
    }
    
    //MARK:- Loader Functions
    class func getRootViewToLoadIn() -> UIView? {
        
        var currentView: UIView? = nil
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if let viewController = delegate.window?.topMostWindowController() {
            currentView = viewController.view
        }
        
        return currentView
        
    }
    
    class func showToastMessageInRootView(_ text: String = "", textStyle: Styler.textStyle, backgroundColor: UIColor = UIColor.white.withAlphaComponent(0.9), bottomOffset: CGFloat = 90.0) {
        
        if let currentView = getRootViewToLoadIn() {
            
            var progressView: MBProgressHUD!
            
            progressView = MBProgressHUD.showAdded(to: currentView, animated: true)
            progressView.offset = CGPoint(x: 0, y: (Constants.screenBounds.height/2) - (Utils.getSafeAreaInsets().bottom + bottomOffset))
            progressView.label.text = text
            progressView.label.textColor = textStyle.color
            progressView.label.font = textStyle.font
            progressView.bezelView.color =  backgroundColor
            progressView.margin = 10
            progressView.mode = MBProgressHUDMode.text
            progressView.contentColor = textStyle.color
            progressView.isUserInteractionEnabled = false
            progressView.hide(animated: true, afterDelay: 2.0)
            
        }
        
    }
    
    class func showLoadingInRootView(text: String = "") {
        
        let currentView = getRootViewToLoadIn()
        
        if currentView != nil {
            let _ = Utils.showLoadingInView(currentView!, withText: text)
        }
        
    }
    
    @discardableResult class func showLoadingInView(_ view: UIView, withText text: String = "", backgroundColor: UIColor = UIColor.clear) -> UIView {
        
        var backgroundView = UIView()
        
        if let backgroundLoadingView = view.viewWithTag(loadingBackgroundViewTag){
            
            backgroundView = backgroundLoadingView
            backgroundView.isHidden = false
            
            if let progressloadingView = backgroundView.viewWithTag(progressViewTag) as? MBProgressHUD{
                progressloadingView.show(animated: true)
                return progressloadingView
            }
            
        }else{
            backgroundView = getLoadingBackground(view)
        }
        
        var progressView: MBProgressHUD!
        
        progressView = MBProgressHUD.showAdded(to: backgroundView, animated: true)
        
        progressView.tag = progressViewTag
        
        if !text.isEmpty {
            progressView.label.text = text + "..."
            progressView.label.textColor = UIColor.BMS.fontBlack
            progressView.label.font = UIFont.BMS.InterRegular.withSize(14.0)
        }
        
        progressView.isUserInteractionEnabled = false
        progressView.mode = MBProgressHUDMode.customView
        
        progressView.bezelView.color = backgroundColor
        progressView.bezelView.backgroundColor = backgroundColor
        //            progressView.bezelView.style = .solidColor
        
//        let animatedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        animatedImageView.animationImages = Utils.loadAnimatedImagesArray("loader", startIndex: 0, endIndex: 39)
//        animatedImageView.animationDuration = 2.0
//        animatedImageView.animationRepeatCount = 0
//        animatedImageView.startAnimating()
        let animatedImageView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        animatedImageView.startAnimating()
        progressView.customView = animatedImageView
        
        return progressView
    }
    
    class func hideLoadingInRootView() {
        
        let currentView = getRootViewToLoadIn()
        
        if currentView != nil {
            Utils.hideLoadingInView(currentView!)
        }
        
    }
    
    class func hideLoadingInView(_ view:UIView) {
        if let loadingView = view.viewWithTag(loadingBackgroundViewTag){
            MBProgressHUD.hide(for: loadingView, animated: true)
            loadingView.isHidden = true
        }
    }
    
    
    
    class func getLoadingBackground(_ inView : UIView) -> UIView{
        let backgroundView = UIView()
        
        backgroundView.backgroundColor = UIColor.clear
        
        backgroundView.tag = loadingBackgroundViewTag
        
        inView.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: inView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: inView.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: inView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: inView.bottomAnchor).isActive = true
        
        return backgroundView
    }
    
//    class func getFooterLoadingView(height: CGFloat = 50.0, backgroundColor: UIColor = UIColor.SORT.clear) -> UIView {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenBounds.width, height: height))
//        view.addSubview(ReusableFooterLoadingView(frame: view.frame))
//        view.backgroundColor = backgroundColor
//        return view
//    }
//
    class func loadAnimatedImagesArray(_ imageName:String, startIndex: Int, endIndex: Int, isLooped: Bool = false) -> [UIImage] {
        
        var animatedImageArray = [UIImage]()
        
        for index in startIndex...endIndex {
            animatedImageArray.append(UIImage(named: "\(imageName)-\(index)")!)
        }
        
        if isLooped {
            
            for index in stride(from: endIndex, through: startIndex, by: -1) {
                animatedImageArray.append(UIImage(named: "\(imageName)-\(index)")!)
            }
            
        }
        
        return animatedImageArray
        
    }
    
    //MARK:- File Upload Functions
    
//    class func getBase64FileString(file: Any?, fileMimeType: String?, compression: CGFloat = 1.0) -> String? {
//
//        guard let value = file, let mimeType = fileMimeType else {
//            return nil
//        }
//
//        if let fileData = value as? UIImage {
//
//            guard let base64 = fileData.convertToBase64String(compression: compression) else{
//                return nil
//            }
//
//            return base64
//
//        }
//
//        else if let fileData = value as? URL {
//
//            do {
//                let data = try Data(contentsOf: fileData)
//
//                let base64String = data.base64EncodedString(options: .lineLength64Characters)
//                return "data:\(mimeType);base64,\(base64String)"
//            }
//
//            catch {
//                return nil
//            }
//
//        }
//
//        return nil
//
//    }
    
    //MARK:- Convenience Functions
    class func convertArrayToString(array : [String]) -> String{
        do {
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
                return JSONString
            }
            
        } catch {
            print(error)
        }
        return ""
    }
    
    class func roundNumber(_ number: Float, numberOfPlaces:Int = 1) -> Float {
        let multiplier = pow(10.0, Float(numberOfPlaces))
        let rounded = round(number * multiplier) / multiplier
        return rounded
    }
    
    class func roundNumber(_ number:Double, numberOfPlaces:Int = 1) -> Double {
        let multiplier = pow(10.0, Double(numberOfPlaces))
        let rounded = round(number * multiplier) / multiplier
        return rounded
    }
    
    class func getTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        return tapGestureRecognizer
    }
    
    class func getLongPressGestureRecognizer() -> UILongPressGestureRecognizer {
        let tapGestureRecognizer = UILongPressGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        return tapGestureRecognizer
    }
    
    class func loadViewFromNib(nibName: String, view:UIView) -> UIView {
        let bundle = Bundle(for: type(of: view))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: view, options: nil)[0] as! UIView
    }
    
    //MARK:- NSUserDefault Functions
    class func setDefaultsForKey(key: String, withValue value: Any) {
        let defaults = UserDefaults(suiteName: Utils.userDefaultsSuite)
        defaults?.set(value, forKey: key)
        defaults?.synchronize()
    }
    
    class func getDefaultsForKey(key: String) -> Any {
        return UserDefaults(suiteName: Utils.userDefaultsSuite)?.object(forKey: key) as Any
    }
    
    class func setObjectDefaultsForKey(key: String, withValue value: Any) {
        let defaults = UserDefaults(suiteName: Utils.userDefaultsSuite)
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        defaults?.set(data, forKey: key)
        defaults?.synchronize()
    }
    
    class func getObjectDefaultsForKey(key: String) -> Any {
        if let data = UserDefaults(suiteName: Utils.userDefaultsSuite)?.object(forKey: key) as? Data {
            let value = NSKeyedUnarchiver.unarchiveObject(with: data)
            return value as Any
        }
        
        return UserDefaults(suiteName: Utils.userDefaultsSuite)?.object(forKey: key) ?? ""
    }
    
    class func removeDefaultsForKey(key: String) {
        let defaults = UserDefaults(suiteName: Utils.userDefaultsSuite)
        defaults?.removeObject(forKey: key)
    }
    
    class func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    
    class func getRandomColor() -> UIColor {
        
        let colors = [UIColor.BMS.red, UIColor.BMS.green, UIColor.BMS.blue, UIColor.BMS.orange, UIColor.BMS.pink , UIColor.BMS.purple]
        
        let rand = arc4random_uniform(UInt32(colors.count))
        return colors[Int(rand)]
        
    }
    
    static func readJSONFromFile(fileName: String) -> Any?
    {
        var json: Any?
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                // Getting data from JSON file using the file URL
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                json = try? JSONSerialization.jsonObject(with: data)
            } catch {
                // Handle error here
            }
        }
        return json
    }
    
    class func getJsonStringFromDictionary(dict : [String : Any]) -> String{
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let theJSONText = String(data: jsonData,
                                     encoding: .ascii)
            
            return theJSONText != nil ? "\(theJSONText!)" : ""
        } catch {
            print(error.localizedDescription)
        }
        return ""
    }

    class func getJsonFromString(string: String) -> [String: Any]? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String:Any]
            return json
        } catch let error as NSError {
            print(error)
            return nil
        }
    }

    //MARK: Encryption and Decryption
    
    func decryptData(encryptdata:String) -> String{
        var decryptJSONString:String = ""
        do {
            let aes = try AES(key: Array("(y6er1@n$1234567".utf8), blockMode:CBC(iv: Array("0001000100010001".utf8)),padding: .pkcs5) // AES256
            let decryptText = try aes.decrypt(Array(base64:encryptdata))
            decryptJSONString =  String(data: Data(decryptText), encoding: .utf8) ?? ""
        }
        catch{
            print(error)
        }
        
        return decryptJSONString
    }
    
    func encryptData(json:Any)-> String{
        var encryptedString:String = ""
        do {
            
            let aes = try AES(key: Array("(y6er1@n$1234567".utf8), blockMode:CBC(iv: Array("0001000100010001".utf8)),padding: .pkcs5) // AES256
            let encryptText = try aes.encrypt(String(describing:json).bytes)
            print(String(data: Data(encryptText), encoding: .utf8) )
            encryptedString = Array(encryptText).toBase64()
            
            
        }catch{
            print(error) 
        }
        
        return encryptedString
    }
    
    //MARK: JSON Converter
    
    func convertToJSON(obj:Any){
//        let jsonData = try JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
//        print(jsonData)
//        let json = String(data: jsonData, encoding: .utf8)
//        return json!
    }
    
}


extension String {
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func formatDateString() -> String {
        if let myInteger = Int(self) {
            let myNumber = NSNumber(value:myInteger)
            let formatter = NumberFormatter()
            formatter.numberStyle = .ordinal
            return formatter.string(from: myNumber)!
        }
        return ""
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func getHeightInLabel(font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:width, height:CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func toDate(_ format : String = "EEE, dd-MMM-yy 'at' hh:mm aa" , timezone:TimeZone = TimeZone.current) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if !format.contains("zzz") {
            dateFormatter.timeZone = timezone
        }
        
        let date = dateFormatter.date(from: self)
        return date!
    }
    
    func pluralizeForInt(_ value: Int) -> String {
        let stringValue = self
        if value == 1 {
            return stringValue
        } else {
            return stringValue + "s"
        }
    }
    
    func getInitials() ->String {
        
        var trimString = self
        
        while true{
            if trimString.contains("  "){
                trimString = trimString.replacingOccurrences(of: "  ", with: " ")
            }else{
                break
            }
        }
        
        let names = trimString.components(separatedBy: " ")
        
        guard names.count > 0 else{
            return ""
        }
        
        if names.count == 1{
            if let initial = names.first?.first{
                return String(initial).uppercased()
            }
            return ""
        }else{
            return names.reduce("") {($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }.uppercased()
        }
    }
    
    func getUnderlined(textColor: UIColor, font: UIFont) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: self)
        
        attributedString.setUnderlineAttributes(color: textColor, font: font, foregroundColor: textColor, underlineStyle: NSUnderlineStyle.single.rawValue)
        
        return attributedString
        
    }
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func canOpenUrl() -> Bool{
        guard let url = URL(string: self) else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
    
}

extension Array {
    
    func filterDuplicates(_ isIncluded: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return isIncluded(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}


extension UITableView {
    
    func registerNibs(_ cellIdentifiers: [String]) {
        
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
        
    }
    
    func registerNib(_ cellIdentifier: String) {
        self.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    func registerHeaderNibs(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier,bundle:nil), forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    /**
     Toggles navigation style if the screen's navbar according to scroll
     - Parameter viewController: UIViewController whose style needs to be changed
     - Parameter topOffset: CGFloat value for comparing scroll margin
     - Parameter defaultNavigationStyle: NavigationStyle which needs to be restored when page gets back to original position.
     - Parameter scrolledNavigationStyle: NavigationStyle which needs to be applied when page gets scrolled.
     - Note:
     1. Call this function from target controller's tableview delegate method - 'scrollViewDidScroll'
     2. Change default values for styles according to project here. And pass them from controller if you need controller specific styling.
     */
    func toggleNavigationStyleOnTableViewScroll(_ viewController: UIViewController, topOffset: CGFloat = 5.0, defaultNavigationStyle: BaseNavigationViewController.NavigationStyle = .transparentNavBlackTint, scrolledNavigationStyle: BaseNavigationViewController.NavigationStyle = .whiteNavBlackTint) {
        /// Proceed only iff viewController has navigationController
        guard let navigationController = viewController.navigationController as? BaseNavigationViewController else {
            return
        }
        
        /// Get table view's content offset value on y axis indicating scroll
        let yPos = self.contentOffset.y
        
        if yPos > topOffset {
            /// Page has scrolled beyond offset so change style.
            navigationController.setNavigationBarStyle(scrolledNavigationStyle, shouldSave: true)
        } else {
            /// Restore default style as page has scrolled back.
            navigationController.setNavigationBarStyle(defaultNavigationStyle, shouldSave: true)
        }
    }
    
    func getBlankHeaderFooterView(width: CGFloat, height: CGFloat, backgroundColor: UIColor = UIColor.BMS.clear) -> UIView {
        let footerView = UITableViewHeaderFooterView()
        footerView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        footerView.contentView.backgroundColor = backgroundColor
        return footerView
    }
    
    func updateHeightForCells() {
        
        // Disabling animations gives us our desired behaviour
        UIView.setAnimationsEnabled(false)
        /* These will causes table cell heights to be recaluclated,
         without reloading the entire cell */
        self.beginUpdates()
        self.endUpdates()
        // Re-enable animations
        UIView.setAnimationsEnabled(true)
        
    }
    
    /**
     Adds refresh control to UITableView.
     - parameter refreshControl: UIRefreshControl instance that you want to add to your tableview.
     */
    func addRefreshControl(_ refreshControl: UIRefreshControl) {
        if OperatingSystem.isHigherThan10 {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
    }
}

extension UIView{
    
    //General
    
    //FooterView for TableViews
    
    class func getFooterViewForListings(height:CGFloat = 10.0) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenBounds.width, height: height))
    }
    
    class func getTableFooterViewLoading() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenBounds.width, height: 50.0))
        //view.addSubview(TTReusableFooterLoadingView(frame: view.frame))
        return view
    }
    
    //Layout Constraints
    
    func layoutAllConstraints(parentView: UIView, topConstant: CGFloat = 0.0, bottomConstant: CGFloat = 0.0, leadingConstant: CGFloat = 0.0, trailingConstant: CGFloat = 0.0, constraintsToLayoutGuide: Bool = false, viewController: UIViewController? = nil) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: leadingConstant).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: trailingConstant).isActive = true
        
        if let vc = viewController, constraintsToLayoutGuide {
            if #available(iOS 11.0, *) {
                self.topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: topConstant).isActive = true
                self.bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: bottomConstant).isActive = true
            }
                
            else {
                self.topAnchor.constraint(equalTo: vc.topLayoutGuide.bottomAnchor, constant: topConstant).isActive = true
                self.bottomAnchor.constraint(equalTo: vc.bottomLayoutGuide.topAnchor, constant: bottomConstant).isActive = true
            }
        }
            
        else {
            self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: topConstant).isActive = true
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: bottomConstant).isActive = true
        }
    }
    
    //Load Nibs
    
    class func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        //https://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
    
//        guard let contentView = UINib(nibName: String(describing: type(of: self)), bundle: Bundle.main).instantiate(withOwner: nil, options: nil).first as? T else{    // 3
//                   // xib not loaded, or its top view is of the wrong type
//                   return nil
//               }
//
//
//        self.addSubview(contentView)
//        contentView.frame = self.bounds
//        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        let bundle = Bundle(for: T.self)
        guard let contentView =  UINib(nibName: String(describing: type(of: self)), bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
else{
            return nil
        }
                    contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
               contentView.frame = bounds
            addSubview(contentView)
        return contentView
    }
    
    
    func initFromNib<T:UIView>()->T?{
        let xib = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self,options: nil)![0] as! T
        xib.frame = self.bounds
        addSubview(xib)
        
        return xib
    }
    //Shadows, Gradients, Corner Radius, Borders
    
    func setupShadow(style: Styler.shadowStyle) {
        self.layoutIfNeeded()
        self.layer.cornerRadius = style.cornerRadius
        self.layer.shadowOffset = style.shadowOffset
        self.layer.shadowRadius = style.shadowRadius
        self.layer.shadowOpacity = style.opacity
        //        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: style.cornerRadius, height: 8)).cgPath
        //        self.layer.shouldRasterize = true
        //        self.layer.rasterizationScale = UIScreen.main.scale
        //        self.layer.masksToBounds = false
        self.layer.shadowColor = style.color.cgColor
        
    }
    
    func addGradient(color : UIColor , viewBounds : CGRect? = nil){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        if viewBounds != nil
        {
            gradientLayer.frame = viewBounds!
        }else{
            gradientLayer.frame = self.bounds
        }
        
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.addSublayer(gradientLayer)
        
    }
    
    func addGradient(start : UIColor , end : UIColor , viewBounds : CGRect? = nil , cornerRadius : CGFloat = 10){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [start.cgColor, end.cgColor]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        if viewBounds != nil
        {
            gradientLayer.frame = viewBounds!
        }else{
            gradientLayer.frame = self.bounds
        }
        
        gradientLayer.cornerRadius = cornerRadius
        
        gradientLayer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
        if let topLayer = self.layer.sublayers?.first, topLayer is CAGradientLayer
        {
            topLayer.removeFromSuperlayer()
        }
        self.layer.addSublayer(gradientLayer)
        
    }
    
    func setAsRounded(cornerRadius: CGFloat = 5.0) {
        self.layoutIfNeeded()
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat = 5.0) {
        //Credit: http://ioscake.com/how-to-set-cornerradius-for-only-top-left-and-top-right-corner-of-a-uiview.html
        self.layoutIfNeeded()
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.clipsToBounds = true
    }
    
    func removeAllSubviewsWithTag(_ tag: Int) {
        
        for subview in self.subviews {
            if subview.tag == tag {
                subview.removeFromSuperview()
            }
        }
        
    }
    
    func removeBorder() {
        removeAllSubviewsWithTag(1001)
    }
    
    @discardableResult func addBorders(edges: UIRectEdge, color: UIColor = UIColor.BMS.separatorGray, thickness: CGFloat = 1.0) -> [UIView] {
        
        removeAllSubviewsWithTag(1001)
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.tag = 1001
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
         
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
          
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
           
            borders.append(bottom)
        }
        
//        let cornr = UIView()
//        cornr.layer.cornerRadius = 14.0
////        cornr.layer.borderColor = UIColor.SORT.black
//        cornr.layer.borderWidth = 1.0
//        borders.append(cornr)
    
      
        return borders
    }
    
   
    
    func setBorder(color: UIColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.05), size: CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = size
    }
    
    func setBorderRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        
    }
    
    
    //For adding and removing children to container views
    
    func add(asChildViewController viewController: UIViewController, parentViewController: UIViewController) {
        // Add Child View Controller
        parentViewController.addChild(viewController)
        
        // Add Child View as Subview
        self.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = self.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: parentViewController)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    func prepareForTableHeader(width: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
        
        self.addConstraint(widthConstraint)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.removeConstraint(widthConstraint)
        
        self.frame.size.height = height
        self.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    //Progress Bar
    
    func showProgressBar(_ percent: CGFloat, height: CGFloat = 0.0, shadowHeight: CGFloat = 0.0,  backgroundColor: UIColor = UIColor.BMS.white, viewBackgroundColor:UIColor = UIColor.BMS.green) {
        
        self.removeAllSubviewsWithTag(1002)
        
        let view = UIView(frame: self.frame)
        
        var frameHeight = self.frame.size.height
        
        if height > 0.0 {
            frameHeight = height
        }
        
        view.frame.size.height = frameHeight
        
        let progressBarBackground = UIView(frame: view.frame)
        progressBarBackground.frame.size.height = frameHeight
        progressBarBackground.backgroundColor = viewBackgroundColor
        
        let progressBar = UIView(frame: progressBarBackground.frame)
        progressBar.frame.size.width = percent * view.frame.size.width
        progressBar.backgroundColor = backgroundColor
        
        view.layer.shadowOffset = CGSize(width: 0, height: shadowHeight)
        view.layer.shadowOpacity = 0.2;
        view.layer.shadowRadius = 1.0;
        
        view.addSubview(progressBarBackground)
        view.addSubview(progressBar)
        
        view.tag = 1002
        
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    //For Clickable Flows
    func setupDemoClickableButton(_ title: String) -> UIButton {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0))
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.backgroundColor = UIColor.lightText
        return button
    }
    
    func styleDemoClickableButtons(_ buttonsArray:[UIButton]) {
        
        let margins:CGFloat = 100
        let space:CGFloat = 0
        let buttonHeight:CGFloat = 50
        
        for (index, button) in buttonsArray.enumerated() {
            
            button.frame.size.height = buttonHeight
            button.frame.origin.y = self.frame.size.height - (margins/2) - ((CGFloat(index + 1) * buttonHeight) - (CGFloat(index + 1) * space))
            self.addSubview(button)
        }
        
    }
    
    func addBadge(title : String , titleStyle : Styler.textStyle  = TextStyles.PlansTabCountStyle, backgroundColor : UIColor = UIColor.BMS.sorttedGreen){
        
        let titleLbl = UILabel()
        titleLbl.textAlignment = .center
        titleLbl.textColor = titleStyle.color
        titleLbl.font = titleStyle.font
        titleLbl.text = title
        titleLbl.backgroundColor = backgroundColor
        self.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.heightAnchor.constraint(equalToConstant: 28).isActive = true
        titleLbl.widthAnchor.constraint(equalToConstant: 28).isActive = true
        titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 12).isActive = true
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: -12).isActive = true
        titleLbl.setAsRounded(cornerRadius: 14)
    }
    
    func addTitle(title : String , titleStyle : Styler.textStyle  = TextStyles.HomeButtonTitleStyle, backgroundColor : UIColor = UIColor.BMS.clear){
        
        let titleLbl = UILabel()
        titleLbl.textAlignment = .center
        titleLbl.textColor = titleStyle.color
        titleLbl.font = titleStyle.font
        titleLbl.text = title
        titleLbl.backgroundColor = backgroundColor
        self.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        titleLbl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 16).isActive = true
    }
    
    func addTitleTag(title : String , titleStyle : Styler.textStyle  = TextStyles.HomeButtonTitleStyle, backgroundColor : UIColor = UIColor.BMS.clear){
        
        let titleLbl = UILabel()
        titleLbl.textAlignment = .center
        titleLbl.textColor = titleStyle.color
        titleLbl.font = titleStyle.font
        titleLbl.text = title
        titleLbl.backgroundColor = backgroundColor
        self.addSubview(titleLbl)
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        titleLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32).isActive = true
        
        titleLbl.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        
        titleLbl.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
        titleLbl.setAsRounded()
    }
    
    
}

extension UICollectionView {
    
    func registerNib(_ cellIdentifier: String) {
        self.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func registerNibs(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        }
    }
    
    func registerReusableHeaderNibs(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        }
    }
    
    func registerReusableFooterNibs(_ cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier,bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
        }
    }
    
    func registerCollectionFooterViewLoading() {
        self.register(UINib(nibName: "TTFooterLoadingCollectionReusableView",bundle:nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "TTFooterLoadingCollectionReusableView")
    }
    
    func getCollectionFooterViewLoading(_ indexPath: IndexPath) -> UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "TTFooterLoadingCollectionReusableView", for: indexPath)
    }
}

extension Date {
    
    var yearsFromNow:   Int { return Calendar.current.dateComponents([.year],       from: self, to: Date()).year        ?? 0 }
    var monthsFromNow:  Int { return Calendar.current.dateComponents([.month],      from: self, to: Date()).month       ?? 0 }
    var weeksFromNow:   Int { return Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear  ?? 0 }
    var daysFromNow:    Int { return Calendar.current.dateComponents([.day],        from: self, to: Date()).day         ?? 0 }
    var hoursFromNow:   Int { return Calendar.current.dateComponents([.hour],       from: self, to: Date()).hour        ?? 0 }
    var minutesFromNow: Int { return Calendar.current.dateComponents([.minute],     from: self, to: Date()).minute      ?? 0 }
    var secondsFromNow: Int { return Calendar.current.dateComponents([.second],     from: self, to: Date()).second      ?? 0 }
    
    var conversationRelativeTime: String {
        if(daysFromNow > 2)
        {
            return self.toString(format: "dd-MMM-yy")
        }
        else if(daysFromNow > 1)
        {
            return "Yesterday"
        }
        else
        {
            return self.toTimeString()
        }
    }
    
    var relativeDate: String {
        
        let days = self.onlyDate.days(from: Date().onlyDate)
        
        if days == -1 {
            return "Yesterday"
        }else if days == 0{
            return "Today"
        }else if days == 1 {
            return "Tommorrow"
        }else{
            return self.toString(format: Constants.displayDateFormat)
        }
        
    }
    
    var relativeTime : String {
        
        if self.onlyTime.hours(from: Date().onlyTime) > 1 {
            return "\(self.onlyTime.hours(from: Date().onlyTime)) hours ago"
        }else if self.onlyTime.minutes(from: Date().onlyTime) > 1{
            return "\(self.onlyTime.minutes(from: Date().onlyTime)) minutes ago"
        }else {
            return "Now"
        }
    }
    
    var relativeMinute : Int {
        return self.onlyTime.minutes(from: Date().onlyTime)
    }
    
    var timeAgo: String {
        if(daysFromNow >= 2)
        {
            return "\(daysFromNow) days ago"
        }
        else if(daysFromNow >= 1)
        {
            return "Yesterday"
        }
        else if (hoursFromNow > 1)
        {
            return "\(hoursFromNow) hours ago"
        }
        else if (minutesFromNow > 1) {
            return "\(minutesFromNow) mins ago"
        }
        else {
            return "Now"
        }
    }
    
    func toTimeString() -> String
    {
        return self.toString(format: "hh:mm aa")
    }
    
    static func getDayBetweenTwoDates(startDate: Date, endDate: Date) -> Int {
        let calendar = NSCalendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
    
    func toString(format:String = "EEE, dd-MMM-yy 'at' hh:mm aa", timezone:TimeZone = TimeZone.current) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timezone
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func toStringInUTCTimeZone(format:String = "EEE, dd-MMM-yy 'at' hh:mm aa") -> String {
        return toString(format: format, timezone: TimeZone(abbreviation: "UTC")!)
    }
    
    func relativeTimeToGo(date : Date , dateTimeFormat : String = "EEE, dd-MMM-yy 'at' hh:mm aa" , timeFormat : String = "hh:mm aa") -> String{
        
    
        var components: DateComponents = DateComponents()
        components.hour = Calendar.current.component(.hour, from: self)
        components.minute = Calendar.current.component(.minute , from: self)
        components.second = 0
        components.day = Calendar.current.component(.day, from: date)
        components.month = Calendar.current.component(.month, from: date)
        components.year = Calendar.current.component(.year, from: date)
        
        guard let newDate = Calendar.current.date(from: components) else{
            return ""
        }
        
        if newDate.days(from: Date()) >= 1{
            return newDate.toString(format: dateTimeFormat)
        }else if newDate.hours(from: Date()) > 1{
            return "\(newDate.hours(from: Date())) hours to go"
        }else if newDate.minutes(from: Date()) > 1 {
            return "\(newDate.minutes(from: Date())) minutes to go"
        }else{
            return "Time exceeds"
        }
        
    }
    
    func replaceTimeInDate(_ time : Date) -> Date{
        
        var components: DateComponents = DateComponents()
        components.hour = Calendar.current.component(.hour, from: time)
        components.minute = Calendar.current.component(.minute , from: time)
        components.second = 0
        components.day = Calendar.current.component(.day, from: self)
        components.month = Calendar.current.component(.month, from: self)
        components.year = Calendar.current.component(.year, from: self)
        
        guard let newDate = Calendar.current.date(from: components) else{
            return Date()
        }
        
        return newDate
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func toServerFormat() -> String {
        return self.toString(format: Constants.serverDateFormat, timezone: TimeZone.current)
        //return "\(self.timeIntervalSince1970)"
    }
    
    func newDateInHours(_ number: Int) -> Date {
        return newDateInTime(hour: number)
    }
    
    func newDateInMinutes(_ number: Int) -> Date {
        return newDateInTime(minute: number)
    }
    
    func newDateInSeconds(_ number: Int) -> Date {
        return newDateInTime(second: number)
    }
    
    func newDateInDays(_ number: Int) -> Date {
        return newDateInTime(day: number)
    }
    
    func newDateInMonths(_ number: Int) -> Date {
        return newDateInTime(month: number)
    }
    
    func newDateInYears(_ number: Int) -> Date {
        return newDateInTime(year: number)
    }
    
    func newDateInTime(hour:Int? = nil, minute:Int? = nil, second:Int? = nil, day:Int? = nil, month:Int? = nil, year:Int? = nil) -> Date {
        
        var components: DateComponents = DateComponents()
        components.hour = hour
        components.minute = minute
        components.second = second
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(byAdding: components, to: self)!
        
    }
    
    //Functions below are from: https://stackoverflow.com/questions/27182023/getting-the-difference-between-two-nsdates-in-months-days-hours-minutes-seconds
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    func addMonthsToDate(_ months:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .month, value: months, to: self, options: [])!
    }
    
    func addDaysToDate(_ days:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .day, value: days, to: self, options: [])!
    }
    
    func addHoursToDate(_ hours:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .hour, value: hours, to: self, options: [])!
    }
    
    func addMinutesToDate(_ minutes:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .minute, value: minutes, to: self, options: [])!
    }
    
    func addSecondsToDate(_ seconds:Int) -> Date {
        return (Calendar.current as NSCalendar).date(byAdding: .second, value: seconds, to: self, options: [])!
    }
    
    func getWeekDay() -> Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: self)
    }
    
    enum WeekDays : Int{
        case sunday  = 1,
        monday = 2,
        tuesday = 3,
        wednesday = 4,
        thursday = 5,
        friday = 6,
        saturday = 7
        
        func getWeekday() -> String{
            switch self{
            case .sunday:
                return "Sunday"
            case .monday:
                return "Monday"
            case .tuesday:
                return "Tuesday"
            case .wednesday:
                return "Wednesday"
            case .thursday:
                return "Thrusday"
            case .friday:
                return "Friday"
            case .saturday:
                return "Saturday"
            }
        }
        
        static func getWeekDays() -> [String]{
            return ["Sunday","Monday","Tuesday","Wednesday","Thrusday","Friday","Saturday"]
        }
        
        static func getWeekDaysCode() -> [String]{
            return ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        }
        
        
        
        static func getWeekDays(weekDays : [String]) -> [WeekDays]{
            var weeks : [WeekDays] = []
            for weekDay in weekDays{
                switch weekDay{
                case "Sunday":
                    weeks.append(.sunday)
                case "Monday":
                    weeks.append(.monday)
                case "Tuesday":
                    weeks.append(.tuesday)
                case "Wednesday":
                    weeks.append(.wednesday)
                case "Thrusday":
                    weeks.append(.thursday)
                case "Friday":
                    weeks.append(.friday)
                case "Saturday":
                    weeks.append(.saturday)
                default:
                    break
                }
            }
            return weeks
        }
        
        static func getWeekDays(weekDays: [WeekDays]) -> [String]{
            var weeks : [String] = []
            for weekDay in weekDays{
                weeks.append(weekDay.getWeekday())
            }
            return weeks
        }
        
        static func getWeekDays(rawValues: [Int]) -> [String]{
            var weeks : [String] = []
            for rawValue in rawValues{
                if let weekDay = WeekDays(rawValue: rawValue + 1){
                    weeks.append(weekDay.getWeekday())
                }
            }
            return weeks
        }
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    var startOfDay: Date {
        let calendar = NSCalendar.current
        let start = calendar.startOfDay(for: self)
        return start
    }
    
    var endOfDay: Date {
        let start = self.startOfDay
        let end = start.newDateInTime(hour: 23, minute: 59, second: 59)
        return end
    }
    
    var onlyDate : Date{
        let dateString = self.toString(format: Constants.dateFormat)
        return dateString.toDate(Constants.dateFormat)
    }
    
    var onlyTime : Date{
        let timeString = self.toString(format: Constants.displayTimeFormat)
        return timeString.toDate(Constants.displayTimeFormat)
    }
    
}

extension UIButton {
    
    func inverseButtonImageWithPadding(_ shouldInverse: Bool = false, inBetweenPadding: CGFloat = 10.0) {
        
        if let value = self.title(for: .normal) {
            let stringWidth = value.width(withConstraintedHeight: self.frame.size.height, font: self.titleLabel!.font)
            
            var buttonImageWidth:CGFloat = 0.0
            if let buttonImage = self.currentImage {
                buttonImageWidth = buttonImage.size.width
            }
            
            if shouldInverse {
                self.contentHorizontalAlignment = .center
                let imageHorizontalInset:CGFloat =  (stringWidth * 2) - (buttonImageWidth / 2)
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0.0, left: imageHorizontalInset, bottom: 0.0, right: 0.0)
                
                let titleHorizontalInset:CGFloat = (buttonImageWidth * 2) + (inBetweenPadding * 2)
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: titleHorizontalInset)
            }
                
            else {
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: inBetweenPadding)
            }
            
        }
    }
    
    func setButtonImageFromLeftWithPadding(_ leftPadding: CGFloat = 0.0, titleRightPadding: CGFloat = 0.0, isTitleCentered: Bool = true, adjustTitleForImagePadding: Bool = false) {
        
        if let value = self.title(for: .normal) {
            let stringWidth = value.width(withConstraintedHeight: self.frame.size.height, font: self.titleLabel!.font)
            let buttonWidth = self.frame.size.width
            
            var buttonImageWidth:CGFloat = 0.0
            if let buttonImage = self.currentImage {
                buttonImageWidth = buttonImage.size.width
            }
            
            self.contentHorizontalAlignment = .left
            
            let imageHorizontalInset:CGFloat = leftPadding
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0.0, left: imageHorizontalInset, bottom: 0.0, right: 0.0)
            
            if !isTitleCentered {
                let titleHorizontalInset:CGFloat = buttonWidth - (stringWidth + buttonImageWidth + titleRightPadding)
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: titleHorizontalInset, bottom: 0.0, right: 0.0)
            }
                
            else if adjustTitleForImagePadding {
                //Sets title in the center accounting for the image on the Left
                let titleHorizontalInset = (buttonWidth - (leftPadding + stringWidth)) / 2
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: titleHorizontalInset, bottom: 0.0, right: 0.0)
            }
                
            else {
                //Sets title in the center WITHOUT accounting for the image on the Left
                let titleHorizontalInset = ((buttonWidth - stringWidth) / 2) - buttonImageWidth
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: titleHorizontalInset, bottom: 0.0, right: 0.0)
            }
            
        }
    }
    
    func setButtonImageFromRightWithPadding(_ rightPadding: CGFloat = 0.0, titleLeftPadding: CGFloat = 0.0,  isTitleCentered: Bool = true, adjustTitleForImagePadding: Bool = false) {
        
        if let value = self.title(for: .normal) {
            let stringWidth = value.width(withConstraintedHeight: self.frame.size.height, font: self.titleLabel!.font)
            let buttonWidth = self.frame.size.width
            
            var buttonImageWidth:CGFloat = 0.0
            if let buttonImage = self.currentImage {
                buttonImageWidth = buttonImage.size.width
            }
            
            self.contentHorizontalAlignment = .left
            let imageHorizontalInset = buttonWidth - (buttonImageWidth) - rightPadding
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0.0, left: imageHorizontalInset, bottom: 0.0, right: 0.0)
            
            if !isTitleCentered {
                //Sets title all the way to the left minus the padding you want
                let titleInsetLeft = titleLeftPadding - buttonImageWidth
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: titleInsetLeft, bottom: 0.0, right: 0.0)
            }
                
            else if adjustTitleForImagePadding {
                //Sets title in the center accounting for the image on the right
                let titleHorizontalInset = (((buttonWidth - buttonImageWidth - rightPadding) - stringWidth) / 2) - buttonImageWidth
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: titleHorizontalInset, bottom: 0.0, right: 0.0)
            }
                
            else {
                //Sets title in the center WITHOUT accounting for the image on the right
                let titleHorizontalInset = ((buttonWidth - stringWidth) / 2) - buttonImageWidth
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: titleHorizontalInset, bottom: 0.0, right: 0.0)
            }
        }
        
    }
    
}

extension UIViewController {
    
    func setupViewToSuperview(_ view: UIView) {
        setUpViewInViewController(view, constraintsToSuperView: true)
    }
    
    func setupViewToSafeArea(_ view: UIView) {
        setUpViewInViewController(view, constraintsToSuperView: false)
    }
    
    private func setUpViewInViewController(_ containerView: UIView, constraintsToSuperView: Bool = false) {
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        
        if constraintsToSuperView {
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        }
            
        else {
            containerView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
            containerView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0.0).isActive = true
        }
        
    }
    
}

extension UIApplication {
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}

extension WKWebView {
    
    private func setAuthorizationHeaderField(_ mutableURLRequest : NSMutableURLRequest) {
        
        if mutableURLRequest.url?.host == URL(string: APIConstants.apiBaseUrl)?.host {
            let headers = Router.getAuthorizationHeaders()
            
            for header in headers {
                mutableURLRequest.setValue(header.value, forHTTPHeaderField: header.HTTPHeaderField)
            }
        }
        
    }
    
    func loadUrlRequest(_ request : NSMutableURLRequest) {
        self.setAuthorizationHeaderField(request)
        self.load(request as URLRequest)
    }
    
    class func getWebViewConfig(scalePagesToFit: Bool = false) -> WKWebViewConfiguration {
        
        let config = WKWebViewConfiguration()
        
        if scalePagesToFit {
            
            // Credit: https://stackoverflow.com/questions/26295277/wkwebview-equivalent-for-uiwebviews-scalespagetofit
            
            let userContentController = WKUserContentController()
            
            let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
            
            let userScript:WKUserScript =  WKUserScript(source: jScript, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(userScript)
            
            config.userContentController = userContentController
            
        }
        
        return config
        
    }
    
    func customizeWebView(allowBackForward:Bool = false) {
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        self.scrollView.backgroundColor = UIColor.clear
        self.scrollView.bounces = false
        self.allowsBackForwardNavigationGestures = allowBackForward
    }
    
}

extension UITextView {
    
    func setTextWithLinks(baseText: String = "",
                          attributedBaseText: NSMutableAttributedString = NSMutableAttributedString(),
                          baseFont: UIFont = TextStyles.TappableBaseStyle.font,
                          baseFontColor: UIColor = TextStyles.TappableBaseStyle.color,
                          linkText: [String] = [],
                          linkValue: [String] = [],
                          linkFont: UIFont = TextStyles.TappableLinkStyle.font,
                          linkColor: UIColor = TextStyles.TappableLinkStyle.color,
                          isUnderlined: Bool = true,
                          textAlignment: NSTextAlignment = .center) {
        
        var attributedString = NSMutableAttributedString()
        
        if baseText.isEmpty{
            attributedString = attributedBaseText
        }else{
            attributedString = NSMutableAttributedString(string: baseText)
        }
        
        //Style Base Font
        
        if !baseText.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle, NSAttributedString.Key.foregroundColor: baseFontColor, NSAttributedString.Key.font : baseFont], range: NSRange(location: 0, length: attributedString.length))
        }
        
        //Style Link
        
        for (index, item) in linkText.enumerated() {
            
            var range = NSRange()
            range = (attributedString.string as NSString).range(of: item)
            
            attributedString.addAttribute(NSAttributedString.Key.link, value: linkValue[index], range: range)
            
            if isUnderlined {
                attributedString.setUnderlineAttributes(color: linkColor, range: range)
            }
            
        }
        
        self.attributedText = attributedString
        
        let linkAttributes:[String : Any] = [NSAttributedString.Key.foregroundColor.rawValue: linkColor, NSAttributedString.Key.font.rawValue : linkFont]
        
        self.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary(linkAttributes)
        
        self.isEditable = false
        self.isSelectable = true
        self.isScrollEnabled = false
        
    }
    
}

extension UIWindow {
    //Credit: https://github.com/hackiftekhar/IQKeyboardManager ~ 5.0.0
    /** @return Returns the current Top Most ViewController in hierarchy.   */
    public func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    /** @return Returns the topViewController in stack of topMostWindowController.    */
    public func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
}


extension UILabel {
    
    func getHeightForLabel() -> CGFloat {
        
        self.frame.size.height = CGFloat.greatestFiniteMagnitude
        self.sizeToFit()
        
        return self.frame.height
        
    }
    
    /**
     Sets text to label.
     - parameter message: String value that needs to be assigned to UILabel's text property
     - Note: If message text is empty it hides the label.
     */
    func setText(to message: String?) {
        
        if let value = message {
            self.text = value
        }
        
        self.isHidden = message == nil || message!.isEmpty
    }
    
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        var insetsWidth: CGFloat = 0.0
        
        if let insets = padding {
            insetsWidth += insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
            textWidth -= insetsWidth
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        contentSize.width = ceil(newSize.size.width) + insetsWidth
        
        return contentSize
    }
}

//Utils Extension for datepicker

//MARK: Platform Struct
struct Platform {
    ///Detects current build platform
    ///True -> Simulator
    ///False -> Device
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

//MARK: Operating System Struct
struct OperatingSystem {
    /// - Note: You can use these properties to check OS version. Benifits - Imroves readability and simplifies usage.
    
    /// Checks whether current OS version is 10 or higher.
    /// Returns 'true' if so else false
    static var isHigherThan10: Bool {
        if #available(iOS 10.0, *) { return true }
        else { return false }
    }
    
    /// Checks whether current OS version is 11 or higher.
    /// Returns 'true' if so else false
    static var isHigherThan11: Bool {
        if #available(iOS 11.0, *) { return true }
        else { return false }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension URL{
    
    func getHeaderData() -> [String : String]{
        var dict = [String:String]()
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        if let queryItems = components.queryItems {
            for item in queryItems {
                dict[item.name] = item.value!
            }
        }
        return dict
    }
}

extension Data {
    /// Size in bytes
    public var sizeInBytes: Int {
        return self.count
    }
    
    /// Size in kilo bytes
    public var sizeInKB: Double {
        return Double(sizeInBytes) / 1024
    }
    
    /// Size in MB
    public var sizeInMB: Double {
        return Double(sizeInBytes) / (1024 * 1024)
    }
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}

extension Double {
    var twoDecimalString:String {
        return String(format: "%.1f", self)
    }
    
    var toString:String {
        return "\(self)"
    }
}


extension UIViewController {
    
    // With this extension you can access the MainViewController from the child view controllers.
    func revealViewController() -> HomeViewController? {
        var viewController: UIViewController? = self
        
        if viewController != nil && viewController is HomeViewController {
            return viewController! as? HomeViewController
        }
        while (!(viewController is HomeViewController) && viewController?.parent != nil) {
            viewController = viewController?.parent
        }
        if viewController is HomeViewController {
            return viewController as? HomeViewController
        }
        return nil
    }
    
}

