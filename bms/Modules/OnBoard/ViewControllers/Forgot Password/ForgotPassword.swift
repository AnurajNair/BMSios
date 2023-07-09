//
//  ForgotPassword.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import Foundation
import UIKit
import SwiftyMenu
import CryptoSwift
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class ForgotPasswordViewController:UIViewController{
    
    @IBOutlet weak var dropDown: ReusableDropDown!
    
    @IBOutlet weak var sendEmailBtn: UIButton!
    var isFormValid = false
    let arr = ["item","item322","item23","iteemmmm"]
    var options:[DropDownModel]? = nil
    var encryptedRequest:String = ""
    @IBOutlet weak var ForgotPassworEmailView: ReusableFormElementView!
    
    var resetPasswordMail:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        setupViewStyle()
        setArray()
    }
    
    
    
  




func setupViewStyle(){
    sendEmailBtn.addConstraint(sendEmailBtn.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2))
  
//        loginCard.roundCorners(UIRectCorner, radius: 4)
    
//    ForgotPassworEmailView.addConstraint(ForgotPassworEmailView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/8))
    ForgotPassworEmailView.delegate = self
    ForgotPassworEmailView.addConstraint(ForgotPassworEmailView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2))
    
    _ = self.ForgotPassworEmailView.setupTextField(id: 0, fieldTitle: "Email", showFieldTitleByDefault: true, showFieldTitleWhileEditing: true, placeholderTitle: "Enter your email", isEditable: true,fieldSubtype: .email, height: 48.0, isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
    

    
}
    
    func setArray(){
//        self.arr.map { elem in
//            var ob :DropDownModel = DropDownModel(id: elem, name: elem)
//
//            self.options?.append(ob)
//        }
//        print(self.options)
        
    }
   
    @IBAction func onSendOTPBtnClick(_ sender: Any) {
        view.endEditing(true)
        if(self.resetPasswordMail != ""){
            guard isFormValid else {
                return
            }
            self.forgotPasswordApi()
        }else{
            self.ForgotPassworEmailView.formElementErrorStackView.isHidden = false
            self.ForgotPassworEmailView.formElementError.text = "Please enter email"
        }
    }
    
    func encryptUserMail()->String{
        let obj:ForgotPasswordRequest = ForgotPasswordRequest()
        obj.email = self.resetPasswordMail
       
       
        
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        self.encryptedRequest = Utils().encryptData(json: jsonString! )
       return encryptedRequest
    }
    
    func getParams()  -> [String : Any]{
        var params = [String : Any]()
        params[ForgotPasswordBody.RequestKeys.requestdata.rawValue] = self.encryptUserMail()
        return params
    }
    
    
    func forgotPasswordApi(){
        Utils.showLoadingInView(self.view , withText: "Sending")
        let router = OnBoardRouterManager()
        router.forgotPassword(params: getParams()) { response in
            print(response)
            Utils.hideLoadingInView(self.view)

            if(response.status == 0 && response.response != ""){
                self.afterForgotPasswordLink()
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            print(error as Any)
            Utils.hideLoadingInView(self.view)
        }
    }
    
    func afterForgotPasswordLink(){
        print("called",resetPasswordMail)
        Navigate.routeUserToScreen(screenType: .otpScreen, transitionType: .push,data: ["resentLinkTo" : self.resetPasswordMail as Any])
    }
}

extension ForgotPasswordViewController:ReusableFormElementViewDelegate{
    func setValues(index: Any, item: Any) {
        print(item)
        self.resetPasswordMail = item as! String
        isFormValid = true
        print(self.resetPasswordMail)
    }

    func setError(index: Any, error: String) {
        isFormValid =  error.isEmpty
    }
}
