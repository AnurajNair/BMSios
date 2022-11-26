//
//  SetNewPassword.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import Foundation
import UIKit

class ResetPasswordViewController:UIViewController{
    
    @IBOutlet weak var confirmPasswordTextInput: UITextField!
    @IBOutlet weak var newPasswordTextInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView(){
        
        newPasswordTextInput.addConstraint(newPasswordTextInput.heightAnchor.constraint(equalToConstant: 50))
        newPasswordTextInput.addConstraint(newPasswordTextInput.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.6))
        confirmPasswordTextInput.addConstraint(confirmPasswordTextInput.heightAnchor.constraint(equalToConstant: 50))
        confirmPasswordTextInput.addConstraint(confirmPasswordTextInput.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.6))
        
    }
    
    @IBAction func onResetBtnClick(_ sender: Any) {
        Navigate.routeUserToScreen(screenType: .passwordResetSuccessScreen, transitionType: .push)

    }
}
