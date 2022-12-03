//
//  VerifyOTP.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import UIKit


class VerifyOTPViewController:UIViewController{
    
    
    @IBOutlet weak var otpTextInputField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewStyle()
    }
    
  




func setupViewStyle(){
//        loginCard.roundCorners(UIRectCorner, radius: 4)

//    otpTextInputField.addConstraint(otpTextInputField.heightAnchor.constraint(equalToConstant: 50))
//    otpTextInputField.addConstraint(otpTextInputField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.6))
}
    
    @IBAction func onVerifyBtnClick(_ sender: Any) {
        Navigate.routeUserToScreen(screenType: .resetPasswordScreen, transitionType: .push)

    }
    
    
}
