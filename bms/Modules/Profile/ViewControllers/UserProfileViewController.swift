//
//  UserProfileViewController.swift
//  bms
//
//  Created by Sandeep Patil on 03/01/23.
//

import UIKit
import ObjectMapper

class UserProfileViewController: UIViewController {

    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var LastNameLbl: UILabel!
    @IBOutlet weak var employerNameLbl: UILabel!
    @IBOutlet weak var empIDLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var emailAddressLbl: UILabel!
    @IBOutlet weak var userRoleLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setProfileData()
    }
    
    func setProfileData()
    {
        
        firstNameLbl.text = (SessionDetails.getInstance().currentUser?.profile?.firstName) ?? "-"
        LastNameLbl.text = (SessionDetails.getInstance().currentUser?.profile?.lastName) ?? "-"
        employerNameLbl.text = (SessionDetails.getInstance().currentUser?.profile?.company) ?? "-"
        empIDLbl.text = (SessionDetails.getInstance().currentUser?.profile?.employeeId) ?? "-"
        countryLbl.text = (SessionDetails.getInstance().currentUser?.profile?.country) ?? "-"
        stateLbl.text = (SessionDetails.getInstance().currentUser?.profile?.state) ?? "-"
        cityLbl.text = (SessionDetails.getInstance().currentUser?.profile?.city) ?? "-"
        emailAddressLbl.text = (SessionDetails.getInstance().currentUser?.profile?.emailId) ?? "-"
        userRoleLbl.text = (SessionDetails.getInstance().currentUser?.profile?.defaultrolename) ?? "-"
    }
    
//    func encrypUserCred() -> String{
////        let obj:Login = Login()
////        obj.username = self.userName
////        obj.password = self.password
////        if(UIDevice.current.model == "iPad"){
////            obj.device = "Tab"
////        }else{
////            obj.device = "Phone"
////        }
////
////
////        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
////        let jsonString = String(data: jsonData, encoding: .utf8)
////       // self.encrypRequest = Utils().encryptData(json: jsonString! )
////       return Utils().encryptData(json: jsonString! )///encrypRequest
//        return ""
//    }
//    func getParams() -> [String : Any]{
//        var params = [String : Any]()
//        params[PostLogin.RequestKeys.requestdata.rawValue] = self.encrypUserCred()
//        return params
//    }
//
//    func getProfileData()
//    {
//        Utils.showLoadingInView(self.view,withText: "Loading")
//        let router = OnBoardRouterManager()
//        router.verifyUserCredLogin(params: getParams()) { response in
//            print(Utils().decryptData(encryptdata: response.response!))
//            if(response.status == 0){
//                Utils.hideLoadingInView(self.view)
//                if(response.response != ""){
//                    let userprofile = Mapper<Profile>().map(JSONString: Utils().decryptData(encryptdata: response.response!))
//                 //self.afterLogin(userProfile: userprofile!)
//                }else{
//                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
//                }
//            }else{
//                Utils.hideLoadingInView(self.view)
//                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
//            }
//
//
//        } errorCompletionHandler: { error in
//            print(error as Any)
//            Utils.hideLoadingInView(self.view)
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
