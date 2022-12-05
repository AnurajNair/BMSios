//
//  ForgotPassword.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import Foundation
import UIKit
import SwiftyMenu

class ForgotPasswordViewController:UIViewController{
    
    @IBOutlet weak var dropDown: ReusableDropDown!
    
    let arr = ["item","item322","item23","iteemmmm"]
    var options:[DropDownModel]? = nil
    @IBOutlet weak var ForgotPassworEmailView: ReusableFormElementView!
    
    var resetPasswordMail:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        setupViewStyle()
        setArray()
    }
    
    
    
  




func setupViewStyle(){
  
//        loginCard.roundCorners(UIRectCorner, radius: 4)
    
//    ForgotPassworEmailView.addConstraint(ForgotPassworEmailView.heightAnchor.constraint(equalToConstant: self.view.frame.size.height/8))
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
        Navigate.routeUserToScreen(screenType: .otpScreen, transitionType: .push)

    }
}

extension ForgotPasswordViewController:ReusableFormElementViewDelegate{
    func setValues(index: Any, item: Any) {
        self.resetPasswordMail = item as! String
    }
}
