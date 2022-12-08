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
   
    @IBOutlet weak var userNameStack: UIStackView!
    
    @IBOutlet weak var backgrounImg: UIImageView!
  
    @IBOutlet weak var portraitView: UIView!
    
    @IBOutlet weak var landscapeView: UIView!
    @IBOutlet weak var userNameFieldView: ReusableFormElementView!
    
    @IBOutlet weak var portraitUserNameFielView: ReusableFormElementView!
    
    @IBOutlet weak var portraitPasswordFieldView: ReusableFormElementView!
    
    @IBOutlet weak var portraitForgotPasswordBtn: UIButton!
    @IBOutlet weak var portraitLoginBtn: UIButton!
    @IBOutlet weak var bmsLogo: UIImageView!
    @IBOutlet weak var passwordFieldView: ReusableFormElementView!
    @IBOutlet weak var loginCard: UIView!
    @IBOutlet weak var logoImage: LogoView!
    var index: Int?
    
    @IBOutlet weak var mainStack: UIStackView!
    let window = UIWindow?.self
 
    @IBOutlet weak var fieldStackView: UIStackView!
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var landScapeSideImage: UIImageView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var userName = ""
    var password = ""
    var encrypRequest = ""
    
    @IBOutlet weak var clientNameStack: UIStackView!
    
    @IBOutlet weak var clientNamestackTopAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var loginView: UIView!
    
    @IBOutlet weak var firstHalfClientNameLabel: UILabel!
    
    @IBOutlet weak var seconHalfClientNameLabel: UILabel!
    
    @IBOutlet weak var logoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewStyle()
        decryptData()
       
     
    }
    
    
    
    
    func setupViewStyle(){
        
        UIView.style([(view: loginCard, style:(backgroundColor:nil, cornerRadius: 18, borderStyle: nil,shadowStyle : nil))])

  
       
       
        
        firstHalfClientNameLabel.text = "Cyberian Consulting"
        seconHalfClientNameLabel.text = "Cyberian Consulting Pvt. Ltd."
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
//        portraitLoginBtn.setTitle("Login", for: .normal)
//
//        portraitLoginBtn.titleLabel?.font = UIFont.BMS.InterSemiBold.withSize(34.0)
       
        
      
//        fieldStackView.addConstraint(fieldStackView.widthAnchor.constraint(equalToConstant: self.loginCard.frame.size.width/1.5))
//    
//        self.bmsLogo.addConstraint(self.bmsLogo.widthAnchor.constraint(equalToConstant: self.loginCard.frame.size.width/3))
//        self.bmsLogo.addConstraint(self.bmsLogo.heightAnchor.constraint(equalToConstant: 80))
      
       
//
//        userNameFieldView.addConstraint(userNameFieldView.heightAnchor.constraint(equalToConstant: 68))
//        userNameFieldView.addConstraint(userNameFieldView.widthAnchor.constraint(equalToConstant: self.fieldStackView.frame.size.width))
//        passwordFieldView.addConstraint(passwordFieldView.heightAnchor.constraint(equalToConstant: 68))
//        passwordFieldView.addConstraint(passwordFieldView.widthAnchor.constraint(equalToConstant: self.fieldStackView.frame.size.width))
//
//        buttonsStack.addConstraint(buttonsStack.heightAnchor.constraint(equalToConstant: 68))
//        buttonsStack.addConstraint(buttonsStack.widthAnchor.constraint(equalToConstant: self.fieldStackView.frame.size.width))
//


//        userNameTextField.addConstraint(userNameTextField.heightAnchor.constraint(equalToConstant: 48))
//
//        passwordTextField.addConstraint(passwordTextField.heightAnchor.constraint(equalToConstant: 48))

     
    
               
//        if (screenHeight > 9.7){
//            userNameTextField.frame.size.height = 180.0
//        }else{
//            userNameTextField.frame.size.height = 58
//        }
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
            
            forgotPasswordButton.titleLabel?.font = UIFont.BMS.InterRegular.withSize(12)
            loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
            setCardInCenter()
            break
        default:
           
            loginButton.titleLabel?.font = UIFont.BMS.InterSemiBold.withSize(20)
            forgotPasswordButton.titleLabel?.font = UIFont.BMS.InterRegular.withSize(12)
            loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
            loginView.addConstraint(loginView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/2))
            setCardInCenter()
            break
        }
    }
    
   
    
    
    func setupTextFields(){
      
        self.portraitUserNameFielView.delegate = self
        self.portraitPasswordFieldView.delegate = self
//        _ =  self.userNameFieldView.setupTextField(id:0,fieldTitle: "User Name",placeholderTitle: "User Name",fieldValue:self.userName,isEditable: true,fieldSubtype: .email,isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
//
//        _ = self.passwordFieldView.setupTextField(id:1,fieldTitle: "Password",placeholderTitle: "Password",fieldValue: self.password,isEditable: true,fieldSubtype: .password,isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        
        _ =  self.portraitUserNameFielView.setupTextField(id:0,fieldTitle: "User Name",placeholderTitle: "User Name",fieldValue: self.userName,isEditable: true,fieldSubtype: .email,isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        
        _ = self.portraitPasswordFieldView.setupTextField(id:1,fieldTitle: "Password",placeholderTitle: "Password",fieldValue: self.password,isEditable: true,fieldSubtype: .password,isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        
      
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
//        loginCard.translatesAutoresizingMaskIntoConstraints = false
//        loginCard.removeConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2.2))
//        NSLayoutConstraint(item: self.loginCard as Any, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
//
//
//        NSLayoutConstraint(item: self.loginCard as Any, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: self.loginCard as Any, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1.0, constant: -self.view.frame.size.width/2).isActive = true
        NSLayoutConstraint(item: self.backgrounImg as Any, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = false
        
  //  loginCard.addConstraint(loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.height/2))
        //loginCard.heightAnchor.constraint(equalToConstant:  self.view.frame.size.width/1.5).isActive = false

      
        
    }

    
    func decryptData(){
        let obj:Login = Login()
        obj.username = "anuraj.nair@cyberianconsulting.in"
        obj.password = "pass,123"
        obj.device = "Tab"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)

        print("encr",Utils().encryptData(json: jsonString! ))
        print("DEc",Utils().decryptData(encryptdata:Utils().encryptData(json: jsonString! ) ))
    }

    
    @IBAction func onForgotPasswordBtnClick(_ sender: Any) {
        
        Navigate.routeUserToScreen(screenType: .forgotPasswordScreen, transitionType: .push)
    }
    

    @IBAction func onLoginButtonClick(_ sender: UIButton) {
        
        Navigate.routeUserToScreen(screenType: .homeScreen, transitionType: .rootSlider)

        
//        let story = UIStoryboard(name: "Dashboard", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "HomeViewController") as! UIViewController
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    func getParams() -> [String : Any]{
        var params = [String : Any]()
        params[PostLogin.RequestKeys.requestdata.rawValue] = encrypRequest
        return params
    }
    
    func loginUser(){
        let router = OnBoardRouterManager()
        router.verifyUserCredLogin(params: getParams()) { response in
            print(response)
        } errorCompletionHandler: { error in
            print(error as Any)
        }

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
    }
    
    func setError(index: Any, error: String) {
        
    }
}





