//
//  ViewController.swift
//  bms
//
//  Created by Naveed on 14/10/22.
//

import UIKit
import SwiftValidator
import CryptoSwift
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Device

class LoginViewController: UIViewController{
   
    
    @IBOutlet weak var backgrounImg: UIImageView!
  
    @IBOutlet weak var portraitView: UIView!
    

    
    @IBOutlet weak var portraitUserNameFielView: ReusableFormElementView!
    
    @IBOutlet weak var portraitPasswordFieldView: ReusableFormElementView!
    
    @IBOutlet weak var portraitForgotPasswordBtn: UIButton!
    @IBOutlet weak var portraitLoginBtn: UIButton!
    
    @IBOutlet weak var loginCard: UIView!
   
    var userName = ""
    var password = ""
    var encrypRequest = ""
    
    
    @IBOutlet weak var clientNameStack: UIStackView!
    
    @IBOutlet weak var clientNamestackTopAnchor: NSLayoutConstraint!
    
    
    @IBOutlet weak var firstHalfClientNameLabel: UILabel!
    
    @IBOutlet weak var seconHalfClientNameLabel: UILabel!
    
    @IBOutlet weak var logoLabel: UILabel!
    
    
    @IBOutlet weak var poweredByLabel: UILabel!
    
    var errors: [IndexPath: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewStyle()
       
     
    }
    
    
    func setupViewStyle(){
        
        UIView.style([(view: loginCard, style:(backgroundColor:nil, cornerRadius: 18, borderStyle: nil,shadowStyle : nil))])

        poweredByLabel.font = UIFont.BMS.InterSemiBold.withSize(18)
       
        self.portraitLoginBtn.isEnabled = true
       
        
        firstHalfClientNameLabel.text = "Shivam Concrete"
        seconHalfClientNameLabel.text = "Technology & Consultancy Pvt Ltd"
        logoLabel.text = "BMS"
        logoLabel.font = UIFont.BMS.InterSemiBold.withSize(48.0)

        
        if UIDevice.current.orientation.isLandscape {
//               removeCardFromCenter()
            print(self.loginCard.constraints)
            UIView.transition(with: self.portraitView, duration: 1,options: .transitionCurlDown) {
                self.portraitView.isHidden = false
            }
            
        } else {
            setCardInCenter()
            print("Portrait")
            UIView.transition(with: self.portraitView, duration: 1,options: .transitionCurlDown) {
                self.portraitView.isHidden = false
            }
        }
        
      
        loginCard.translatesAutoresizingMaskIntoConstraints = false
        
      
        portraitLoginBtn.addConstraint(portraitLoginBtn.heightAnchor.constraint(equalToConstant: 48.0))
        
        
       

        portraitLoginBtn.addConstraint(portraitLoginBtn.widthAnchor.constraint(equalToConstant: self.portraitUserNameFielView.frame.width))
        setupViewAsPerScreen()
        setupTextFields()
        
                
        
    }
    
    func setupViewAsPerScreen(){
        switch Device.size(){
        case .screen12_9Inch:
            print("got it")
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(44)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(28)
            
           
          
           if( UIDevice.current.orientation.isLandscape){
                loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.width/2.5))
                loginCard.addConstraint(loginCard.widthAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
           }else{
               loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2.5))
               loginCard.addConstraint(loginCard.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width/1.8))
           }
            setCardInCenter()
            break
        case .screen10_9Inch:
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(36)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(22)
           
            if( UIDevice.current.orientation.isLandscape){
                 loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.width/2.5))
                 loginCard.addConstraint(loginCard.widthAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
            }else{
                loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2.2))
                loginCard.addConstraint(loginCard.widthAnchor.constraint(equalToConstant:  self.view.frame.size.width/2))
            }
            loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
            setCardInCenter()
            break
        case .screen10_2Inch:
            if(UIDevice.current.orientation.isLandscape){
                loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.width/2))

            }else{
                loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))

            }
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(26)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(18)
          setCardInCenter()
            break
        case .screen9_7Inch:
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(34)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(22)
            
            loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
            setCardInCenter()
            break
        default:
           
           
            loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
          
            setCardInCenter()
            break
        }
    }
    
   
    
    
    func setupTextFields(){
      
        self.portraitUserNameFielView.delegate = self
        self.portraitPasswordFieldView.delegate = self
        
        _ =  self.portraitUserNameFielView.setupTextField(id:0,fieldTitle: "User Name",placeholderTitle: "User Name",fieldValue: self.userName,isEditable: true,fieldSubtype: .email,isRequired: true,isRequiredMessage: "Please enter user name.",textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        
        _ = self.portraitPasswordFieldView.setupTextField(id:1,fieldTitle: "Password",placeholderTitle: "Password",fieldValue: self.password,isEditable: true,fieldSubtype: .password,isRequired: true,isRequiredMessage: "Please enter password.",textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        
      
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           super.viewWillTransition(to: size, with: coordinator)
           if UIDevice.current.orientation.isLandscape {
//               removeCardFromCenter()
               print(self.loginCard.constraints)
               UIView.transition(with: self.portraitView, duration: 1,options: .transitionCurlDown) {
                   self.portraitView.isHidden = false
               }
               
               landscapeConstraints()
               
              
           } else {
              
               UIView.transition(with: self.portraitView, duration: 1,options: .transitionCurlDown) {
                   self.portraitView.isHidden = false
               }
               
             portraitConstraints()
              
               print(self.loginCard.constraints)
            
              
           }
       }
    
    func landscapeConstraints(){
        
        switch Device.size(){
        case .screen12_9Inch:
           
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(44)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(28)
            self.clientNamestackTopAnchor.constant = 86
            
            break
        case .screen9_7Inch:
            
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(26)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(18)
            self.clientNamestackTopAnchor.constant = 46
            break
        case .screen10_2Inch:
           
            firstHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(26)
            seconHalfClientNameLabel.font = UIFont.BMS.InterSemiBold.withSize(18)
            self.clientNamestackTopAnchor.constant = 50
            break
        default:
            
            break
        }
        
        
    }
    
    func portraitConstraints(){
        switch Device.size(){
        case .screen12_9Inch:
            self.clientNamestackTopAnchor.constant = 145
            
            break
        case .screen9_7Inch:
            self.clientNamestackTopAnchor.constant = 120
            break
        case .screen10_2Inch:
            self.clientNamestackTopAnchor.constant = 120
            break
        default:
            self.clientNamestackTopAnchor.constant = 120
            break
        }
    }
    
    
    func setCardInCenter(){

       
        NSLayoutConstraint(item: self.loginCard as Any, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.loginCard as Any, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true

    }
    
    func removeCardFromCenter(){

        NSLayoutConstraint(item: self.backgrounImg as Any, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = false
  
    }

    
   
    
    func encrypUserCred() -> String{
        let obj:Login = Login()
        obj.username = self.userName
        obj.password = self.password
        if(UIDevice.current.model == "iPad"){
            obj.device = "Tab"
        }else{
            obj.device = "Phone"
        }
       
        
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        self.encrypRequest = Utils().encryptData(json: jsonString! )
       return encrypRequest
    }

    
    @IBAction func onForgotPasswordBtnClick(_ sender: Any) {
        
//        Navigate.routeUserToScreen(screenType: .forgotPasswordScreen, transitionType: .push)
    }
    
    func validate(){
        self.errors = ReusableFormElementView.validateRequiredFormField(isRequired: true, fieldValue: self.userName, fieldIndexRow: 0, errorsArray: self.errors)
        self.errors = ReusableFormElementView.validateRequiredFormField(isRequired: true, fieldValue: self.password, fieldIndexRow: 1, errorsArray: self.errors)
    }
    

    @IBAction func onLoginButtonClick(_ sender: UIButton) {
        

        if(self.userName == "" && self.password == ""){
            self.portraitUserNameFielView.formElementErrorStackView.isHidden = false
            self.portraitPasswordFieldView.formElementErrorStackView.isHidden = false
            self.portraitUserNameFielView.formElementError.text = "Please enter user name. "
            self.portraitPasswordFieldView.formElementError.text = "Please enter password."
            
        }else if(self.userName != "" && self.password == ""){
            self.portraitUserNameFielView.formElementErrorStackView.isHidden = true
            self.portraitPasswordFieldView.formElementErrorStackView.isHidden = false
            self.portraitUserNameFielView.formElementError.text = "Please enter user name. "
            self.portraitPasswordFieldView.formElementError.text = "Please enter password."
            
          
            
          
            
        }else if(self.userName == "" && self.password != ""){
            self.portraitUserNameFielView.formElementErrorStackView.isHidden = false
            self.portraitPasswordFieldView.formElementErrorStackView.isHidden = true
            self.portraitUserNameFielView.formElementError.text = "Please enter user name. "
            self.portraitPasswordFieldView.formElementError.text = "Please enter password."
            
          
            
          
            
        }else{
            loginUser()
            //self.portraitUserNameFielView.showError(true)
            
           // Utils.displayAlert(title: "Error", message: "Please fill the data.")
        }

    }
    
    func getParams() -> [String : Any]{
        var params = [String : Any]()
        params[PostLogin.RequestKeys.requestdata.rawValue] = self.encrypUserCred()
        return params
    }
    
    func loginUser(){
        Utils.showLoadingInView(self.view)
        let router = OnBoardRouterManager()
        router.verifyUserCredLogin(params: getParams()) { response in
            print(Utils().decryptData(encryptdata: response.response!))
            if(response.status == 0){
                Utils.hideLoadingInView(self.view)
                if(response.response != ""){
                    let userprofile = Mapper<Profile>().map(JSONString: Utils().decryptData(encryptdata: response.response!))
                 self.afterLogin(userProfile: userprofile!)
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
            }else{
                Utils.hideLoadingInView(self.view)
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
          
            
        } errorCompletionHandler: { error in
            print(error as Any)
            Utils.hideLoadingInView(self.view)
        }

    }
    
    func afterLogin(userProfile:Profile){
        let session = SessionDetails.getInstance()
        session.saveCurrentUser(user: userProfile)
        Navigate.routeUserToScreen(screenType: .homeScreen, transitionType: .rootSlider)
    }
    
    
    
}


extension LoginViewController:ReusableFormElementViewDelegate{
    func setValues(index: Any, item: Any) {
      
        if(index as? Int == 0){
            self.userName = item as? String ?? ""
            print(userName)
        }else{
            self.password = item as? String ?? ""
        }
        
//        if(self.userName != "" && self.password != ""){
//            self.portraitLoginBtn.isEnabled = true
//        }else{
//            self.portraitLoginBtn.isEnabled = false
//        }
    }
    
    func setError(index: Any, error: String) {
        print(error)
        if let value = index as? IndexPath {
            
            if(value.item == 0){
                if error.isEmpty {
                    self.errors.removeValue(forKey: value)
                } else {
                    self.errors[value] = error
                }
                print(self.errors)
            }else{
                if error.isEmpty {
                    self.errors.removeValue(forKey: value)
                } else {
                    self.errors[value] = error
                }
            }
            
        }
       
    }
}





