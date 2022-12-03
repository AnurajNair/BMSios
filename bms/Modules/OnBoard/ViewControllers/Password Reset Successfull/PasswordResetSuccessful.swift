//
//  PasswordResetSuccessful.swift
//  bms
//
//  Created by Naveed on 22/10/22.
//

import UIKit


class PasswordResetSuccessfullViewController:UIViewController{
    
    @IBOutlet weak var tologinBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    func setupView(){
        tologinBtn.addConstraint(tologinBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.6))
    }
    
    
    @IBAction func onLoginBtnClick(_ sender: Any) {
        Navigate.routeUserToScreen(screenType: .homeScreen, transitionType: .root)

    }
}
