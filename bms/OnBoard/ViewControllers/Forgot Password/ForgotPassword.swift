//
//  ForgotPassword.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import Foundation
import UIKit

class ForgotPasswordViewController:UIViewController{
    
  
    @IBOutlet weak var ForgotPassworEmailView: ReusableFormElementView!
    
    var resetPasswordMail:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        setupViewStyle()
    }
    
  




func setupViewStyle(){
//        loginCard.roundCorners(UIRectCorner, radius: 4)
    
    ForgotPassworEmailView.addConstraint(ForgotPassworEmailView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/6.5))
    ForgotPassworEmailView.addConstraint(ForgotPassworEmailView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width/2))
    
    self.ForgotPassworEmailView.setupTextField(id: 0, fieldTitle: "Email", showFieldTitleByDefault: true, showFieldTitleWhileEditing: true, placeholderTitle: "Enter your email", isEditable: true,fieldSubtype: .email, height: 48.0, isRequired: true,textFieldStyling : TTTextFieldStyler.userDetailsStyle,formStyling : TTFormElementViewStyler.userDetailsStyle)
    

    
}
   
    @IBAction func onSendOTPBtnClick(_ sender: Any) {
        Navigate.routeUserToScreen(screenType: .otpScreen, transitionType: .push)

    }
}

extension ForgotPasswordViewController:ReusableFormElementViewDelegate{
    func setValues(index: Any, item: Any) {
        self.resetPasswordMail = item as! String
    }
}
