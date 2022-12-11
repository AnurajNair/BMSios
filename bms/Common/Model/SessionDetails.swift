//
//  SessionDetails.swift
//  bms
//
//  Created by Naveed on 17/10/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import Realm
import GoogleMaps

class SessionDetails : APIRequestBody {
    fileprivate static var shared : SessionDetails!
    
    var tokenType: String?
    var expiresIn : Int?
    var accessToken : String?
    var refreshToken : String?
    var tokenSyncDate : Date?
    
    var selectedAreaId : String?
    
    var isContactSyncAccess = false
    
    var hasViewedTutorial = false
    var isProfileComplete = false
    
    var currentUser : Profile?
    
    var currentPhoneNumber = ""
    
    var isContactsSyncts = false
    
    var currentLocation : CLLocation = CLLocation(latitude: 0, longitude: 0)
    
    var newPlanCount = 0
    
//    var savePlans : [PlanSave] = []
    
    enum UserDefaultKeys : String {
        case
        token = "token",
        hasViewedTutorial = "hasViewedTutorial",
        isProfileComplete = "isProfileComplete",
        currentPhoneNumber = "phone_number",
        isContactsSyncts = "isContactsSyncts",
        currentUser = "currentUser",
        newPlanCount = "newPlanCount",
        isContactsSyncAccess = "isContactsSyncAccess",
        selectedAreaId = "selectedAreaId"
    }
    
    //MARK:- Get Session Details Functions
    class func getInstance() -> SessionDetails {
        if SessionDetails.shared == nil {
            SessionDetails.shared = SessionDetails()
        }
        SessionDetails.shared.pullData()
        return SessionDetails.shared
    }
    
    class func isLoggedIn() -> Bool {
        
        if  SessionDetails.isTokenPresent() {
            return true
        }
        
        return false
    }
    
    //MARK:- Save Methods
    
    func saveToken(token: String) {
        
        Utils.setDefaultsForKey(key: UserDefaultKeys.token.rawValue, withValue: token)
        
        SessionDetails.shared.pullData()
    }
    
//    func saveNewPlanCount(count: Int) {
//
//        Utils.setDefaultsForKey(key: UserDefaultKeys.newPlanCount.rawValue, withValue: count)
//
//        SessionDetails.shared.pullData()
//    }
    
    func saveHasViewedTutorial() {
        Utils.setDefaultsForKey(key: UserDefaultKeys.hasViewedTutorial.rawValue, withValue: true)
        SessionDetails.shared.pullData()
    }
    
    func saveIsContactsSyncts() {
        Utils.setDefaultsForKey(key: UserDefaultKeys.isContactsSyncts.rawValue, withValue: true)
        SessionDetails.shared.pullData()
    }
    
    
    func saveIsContactsSyncAccess(isAccess:Bool) {
           Utils.setDefaultsForKey(key: UserDefaultKeys.isContactsSyncAccess.rawValue, withValue: isAccess)
           SessionDetails.shared.pullData()
       }
       
    
    func saveProfileStatus(isComplete : Bool){
        Utils.setDefaultsForKey(key: UserDefaultKeys.isProfileComplete.rawValue, withValue: isComplete)
        SessionDetails.shared.pullData()
    }
    
    func saveCurrentPhoneNumber(phone : String){
        Utils.setDefaultsForKey(key: UserDefaultKeys.currentPhoneNumber.rawValue, withValue: phone)
        SessionDetails.shared.pullData()
    }
    
    func saveCurrentUser(user : Profile) {
        Utils.setDefaultsForKey(key: UserDefaultKeys.currentUser.rawValue, withValue: user.toJSONString() ?? "")
        SessionDetails.shared.pullData()
    }
    
    
    func saveSelectedAreaId(areaId : String) {
           Utils.setDefaultsForKey(key: UserDefaultKeys.selectedAreaId.rawValue, withValue: areaId)
           SessionDetails.shared.pullData()
       }
    
    
//    func savePlan(plan : Plan , isIn : Bool){
//
//        if isIn {
//            let savePlan = PlanSave()
//            savePlan.planId = plan.planId
//            savePlan.dateAndTime = plan.datetime
//            savePlan.lat = plan.place?.latitude
//            savePlan.long = plan.place?.longitude
//
//            BaseModelManager.commitChange(savePlan,update: false)
//
//            SessionDetails.shared.pullData()
//        }else{
//            let plans = BaseModelManager.getData(object: PlanSave.self)
//
//            for savePlan in plans {
//                if savePlan.planId == plan.planId {
//                    BaseModelManager.delete(savePlan)
//                    break
//                }
//            }
//        }
//
//
//    }
    
    
    //MARK:- Helper Methods
    
    class func isTokenPresent() -> Bool {
        
        if SessionDetails.getInstance().accessToken != nil {
            return true
        } else {
            return false
        }
    }
    
    class func isTokenExpired() -> Bool {
        return false
    }
    
//    class func syncSavePlans(){
//        let plans = BaseModelManager.getData(object: PlanSave.self)
//
//        for savePlan in plans {
//            if (savePlan.dateAndTime ?? Date()).addHoursToDate(1) < Date() {
//                BaseModelManager.delete(savePlan)
//            }
//        }
//    }
    
    //MARK:- Retrieve Methods
    private func pullData() {
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.newPlanCount.rawValue) as? Int {
            self.newPlanCount = value
        }
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.hasViewedTutorial.rawValue) as? Bool {
            self.hasViewedTutorial = value
        }
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.isContactsSyncts.rawValue) as? Bool {
            self.isContactsSyncts = value
        }
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.isProfileComplete.rawValue) as? Bool {
            self.isProfileComplete = value
        }
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.token.rawValue) as? String {
            self.accessToken = value
        }
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.currentPhoneNumber.rawValue) as? String {
            self.currentPhoneNumber = value
        }
        
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.currentUser.rawValue) as? String {
            if !value.isEmpty {
                self.currentUser = Profile(JSONString: value)
            }
        }
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.isContactsSyncAccess.rawValue) as? Bool {
                self.isContactSyncAccess = value
        }
        if let value = Utils.getDefaultsForKey(key: UserDefaultKeys.selectedAreaId.rawValue) as? String {
            if !value.isEmpty{
                self.selectedAreaId = value
            }
        }
        
//        let value = BaseModelManager.getData(object: PlanSave.self)
//
//        savePlans =  Array(value)
    
    }
    
    //MARK:- Clear Session Details
    class func clearInstance() {
                
        Utils.removeDefaultsForKey(key: UserDefaultKeys.token.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.hasViewedTutorial.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.isProfileComplete.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.currentPhoneNumber.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.isContactsSyncts.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.currentUser.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.newPlanCount.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.isContactsSyncAccess.rawValue)
        Utils.removeDefaultsForKey(key: UserDefaultKeys.selectedAreaId.rawValue)
        
//        BaseModelManager.delete(ContactsResponse.self)
//        BaseModelManager.delete(PlanSave.self)
        
        self.shared = nil
        
    }
    
}
