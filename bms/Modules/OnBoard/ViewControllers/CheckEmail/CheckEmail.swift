//
//  VerifyOTP.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import UIKit
import CryptoSwift
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm


class CheckEmailViewController:UIViewController{
    
    @IBOutlet weak var checkMailBtn: UIButton!
    
    @IBOutlet weak var otpTextInputField: UITextField!
    
    @IBOutlet weak var resendStack: UIStackView!
    
    var encryptedRequest:String = ""
    
var resetPassEmailSendTo:String? = "naveed.lambe@cyberian.consulting.in"
    
    @IBOutlet weak var resetPassLinkEmail: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewStyle()
        print(resetPassEmailSendTo)
    }
    
  




func setupViewStyle(){
    resetPassLinkEmail.text = resetPassEmailSendTo
    checkMailBtn.backgroundColor = .clear
    checkMailBtn.layer.cornerRadius = 5
    checkMailBtn.layer.borderWidth = 1
    checkMailBtn.layer.borderColor = UIColor.black.cgColor
//        loginCard.roundCorners(UIRectCorner, radius: 4)

//    otpTextInputField.addConstraint(otpTextInputField.heightAnchor.constraint(equalToConstant: 50))
    checkMailBtn.addConstraint(checkMailBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2))
    resendStack.addConstraint(resendStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2))

}
    
    
    func encryptUserMail()->String{
        let obj:ForgotPasswordRequest = ForgotPasswordRequest()
        obj.email = self.resetPassEmailSendTo
       
       
        
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
        Utils.showLoadingInView(self.view)
        let router = OnBoardRouterManager()
        router.forgotPassword(params: getParams()) { response in
            print(response)
            if(response.status == 0){
                Utils.hideLoadingInView(self.view)
//                if(response.message == "Successfully resetted password .Please login again !!!"){
//
//                    Utils.displayAlert(title: "Success", message: response.message ?? "Reset password email has been successfully sent to you.")
//                }else{
//                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
//                }
             
                Utils.displayAlert(title: "Success", message: response.message ?? "Reset password email has been successfully sent to you.")

            }else{
                Utils.hideLoadingInView(self.view)
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
          
            
        } errorCompletionHandler: { error in
            print(error as Any)
            Utils.hideLoadingInView(self.view)
        }
    }
    
    @IBAction func onVerifyBtnClick(_ sender: Any) {
       // Navigate.routeUserToScreen(screenType: .passwordResetSuccessScreen, transitionType: .push)

    }
    
    @IBAction func onResendLinkBtnClick(_ sender: Any) {
        forgotPasswordApi()
    }
    
    
}
