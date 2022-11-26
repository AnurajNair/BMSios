//
//  ViewController.swift
//  bms
//
//  Created by Naveed on 14/10/22.
//

import UIKit
import SwiftValidator

class LoginViewController: UIViewController{
   
    @IBOutlet weak var userNameStack: UIStackView!
    
    @IBOutlet weak var textField: ReusableFormElementView!
    
    @IBOutlet weak var userNameFieldView: ReusableFormElementView!
    
    @IBOutlet weak var passwordFieldView: ReusableFormElementView!
    @IBOutlet weak var loginCard: UIView!
    @IBOutlet weak var logoImage: LogoView!
    var index: Int?
    
    let window = UIWindow?.self
 
    @IBOutlet weak var fieldStackView: UIStackView!
    
    @IBOutlet weak var buttonsStack: UIStackView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    var userName = ""
    var password = ""
    var encrypRequest = ""
    
    enum CellNames: String {
        case formCell = "ExampleTableCell"
    }
    
    let cellIdentifiers:[String] = [CellNames.formCell.rawValue]
    
    var errors: [IndexPath: String] = [:]
    
    enum Section {
        case userName
        case password
       
        
        func getSectionTitle() -> String {
            switch self {
                
            case .userName:
                return "User Name"
            case .password:
                return "Password"
           
            }
        }
        
//        func getSetionIcon() -> String {
//            switch self {
//
//            case .planPlace:
//                return "location_item"
//            case .invitedPeople:
//                return "account"
//            case .dateAndTime:
//                return "timeline"
//            case .deadline:
//                return "time_item"
//            case .action:
//                return ""
//            case .planName:
//                return "time_item"
//            case .planDescription:
//                return  "time_item"
//            }
//        }
        
        func getSectionHeaderView() -> UIView{
            
            let cell = UITableViewCell()
            
            cell.textLabel?.text = self.getSectionTitle()
//            cell.imageView?.image = UIImage(named: self.getSetionIcon())
//            cell.imageView?.contentMode = .scaleAspectFill
            cell.contentView.layoutMargins = .init(top: 0.0, left: 80, bottom: 0.0, right: 0.0)


            UILabel.style([(view: cell.textLabel, style: TextStyles.LoginPageLableStyler)])
            
            return cell
        }
        
        func getCellTitle() -> String {
            switch self {
                
            case .userName:
                return "User Name"
            case .password:
                return "Password"
           
            }
        }
        
        func getPlaceHolderText() -> String{
            switch self {
            case .userName:
                return "User Name"
            case .password:
                return "Password"
           
            }
        }
        func getSectionHeaderHeight() -> CGFloat {
//            if self == .action {
//                return .leastNormalMagnitude
//            }
            return 56
        }
        
        func getSectionFooterHeight() -> CGFloat {
            return .leastNormalMagnitude
        }
        
    }
    
    var sections : [Section] = [.userName,.password]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewStyle()
     
    }
    
    
    
    
    func setupViewStyle(){
//        loginCard.roundCorners(UIRectCorner, radius: 4)
        
      
       
        UIView.style([(view: loginCard, style:(backgroundColor:nil, cornerRadius: 16, borderStyle: nil,shadowStyle : nil))])

        fieldStackView.addConstraint(fieldStackView.heightAnchor.constraint(equalToConstant: self.loginCard.frame.size.height/2))
        fieldStackView.addConstraint(fieldStackView.widthAnchor.constraint(equalToConstant: self.loginCard.frame.size.width/1.6))
        
        
        NSLayoutConstraint(item: self.fieldStackView as Any, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loginCard, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.fieldStackView as Any, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: loginCard, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0).isActive = true
      
        userNameFieldView.addConstraint(userNameFieldView.heightAnchor.constraint(equalToConstant: self.fieldStackView.frame.size.height/2.7))
        passwordFieldView.addConstraint(passwordFieldView.heightAnchor.constraint(equalToConstant: self.fieldStackView.frame.size.height/2.7))
        
        buttonsStack.addConstraint(buttonsStack.heightAnchor.constraint(equalToConstant: self.fieldStackView.frame.size.height/3))
        


//        userNameTextField.addConstraint(userNameTextField.heightAnchor.constraint(equalToConstant: 48))
//
//        passwordTextField.addConstraint(passwordTextField.heightAnchor.constraint(equalToConstant: 48))

     
      //  loginButton.frame.size.width = userNameStack.frame.size.width
               
//        if (screenHeight > 9.7){
//            userNameTextField.frame.size.height = 180.0
//        }else{
//            userNameTextField.frame.size.height = 58
//        }
        
        setupTextFields()
                
        
    }
    
    func setupTextFields(){
        self.passwordFieldView.delegate = self
        self.userNameFieldView.delegate = self
        self.userNameFieldView.setupTextField(id:0,fieldTitle: "User Name",placeholderTitle: "User Name",isEditable: true,fieldSubtype: .email,isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
        self.passwordFieldView.setupTextField(id:1,fieldTitle: "Password",placeholderTitle: "Password",isEditable: true,fieldSubtype: .password,isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
      
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
        }else{
            self.password = item as? String ?? ""
        }
    }
}





