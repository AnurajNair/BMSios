//
//  VerifyOTP.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import UIKit


class CheckEmailViewController:UIViewController{
    
    @IBOutlet weak var checkMailBtn: UIButton!
    
    @IBOutlet weak var otpTextInputField: UITextField!
    
    @IBOutlet weak var resendStack: UIStackView!
    
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
    
    @IBAction func onVerifyBtnClick(_ sender: Any) {
        Navigate.routeUserToScreen(screenType: .passwordResetSuccessScreen, transitionType: .push)

    }
    
    
}
