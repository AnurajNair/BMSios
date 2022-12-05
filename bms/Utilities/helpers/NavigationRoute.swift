//
//  NavigationRoute.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit
import Alamofire
import CoreLocation

class NavigationRoute: Navigate {
    
    enum ScreenType {
        case
        
        //Common
        undecided,
        loginScreen,
        forgotPasswordScreen,
        otpScreen,
        resetPasswordScreen,
        passwordResetSuccessScreen,
        webView,
        appFeedbackWebView,
        termsWebView,
        privacyWebView,
        contactUs,
        unknownError,
        serverDownScreen,
        imagePicker,
        imageCropper,
        
        popUpView,
        
        //Onboarding
        phoneNumberScreen,
        tutorialScreen,
        enterNameScreen,
        enterEmailScreen,
        enterDOBScreen,
        enterGenderScreen,
        
        //Home
        homeScreen,
        dashboardScreen,
        inspectionListScreen,
        inventoryListScreen,
        
       
        // Routine Inspection
        routineInspbridgeDetailScreen
        
        
        
        func viewControllerDetails(_ data:[String:Any] = [:], transitionType: Navigate.TransitionType = .undecided) -> (viewController: UIViewController, title: String) {
            switch self {
                
            
            case .loginScreen : return (NavigationRoute.getLoginScreen(), "" )
            case .forgotPasswordScreen : return (NavigationRoute.getForgotPasswordScreen(), "" )
            case .otpScreen :  return (NavigationRoute.getVerifyOTPScreen(), "" )
            case .resetPasswordScreen: return (NavigationRoute.getResetPasswordScreen(), "" )
            case .passwordResetSuccessScreen: return (NavigationRoute.getPasswordSuccessfullScreen(), "" )
            case .homeScreen :return (NavigationRoute.getHomeViewController(), "" )
            case .inspectionListScreen :return (NavigationRoute.getInspectionList(), "" )
                
            case .routineInspbridgeDetailScreen :return (NavigationRoute.getRoutineInspBridgeDetail(data), "")

            case.inventoryListScreen:return (NavigationRoute.getInventoryList(), "" )
            case.popUpView:return (NavigationRoute.getPopUpView(), "" )
//            case .webView: return (NavigationRoute.getBaseWebViewController(data), "")
//            case .appFeedbackWebView: return (NavigationRoute.getBaseWebViewController(data), "App Feedback".localized())
//            case .termsWebView: return (NavigationRoute.getBaseWebViewController(data), "Terms & Conditions".localized())
//            case .privacyWebView: return (NavigationRoute.getBaseWebViewController(data), "Privacy Policy".localized())
//            case .contactUs: return (NavigationRoute.getBaseWebViewController(data), "Contact Us".localized())
            case .unknownError: return (NavigationRoute.getUnknownErrorViewController(data), "".localized())
//            case .serverDownScreen: return (NavigationRoute.getServerDownViewController(data), "".localized())
//            case .imageCropper:return (NavigationRoute.getImageCropperViewController(data), "".localized())
//
//            //Onboarding
//            case .phoneNumberScreen: return (NavigationRoute.getPhoneNumberController(data), "".localized())
//            case .otpScreen: return (NavigationRoute.getOTPController(data), "".localized())
//            case .tutorialScreen: return (NavigationRoute.getTutorialController(data), "".localized())
//            case .enterNameScreen: return (NavigationRoute.getEnterNameController(data),"".localized())
//            case .enterEmailScreen: return (NavigationRoute.getEnterEmailController(data),"".localized())
//            case .enterDOBScreen: return (NavigationRoute.getEnterDOBController(data),"".localized())
//            case .enterGenderScreen: return (NavigationRoute.getEnterGenderController(data),"".localized())
//
//            //Home
//            case .homeScreen: return (NavigationRoute.getHomeController(data),"".localized())
//            case .dashboardScreen: return (NavigationRoute.getDashboardController(data),"".localized())
//            case .mainTabbarScreen: return (NavigationRoute.getMainTabBarViewController(data) , "".localized())
//
//            //Settings
//            case .settingScreen: return (NavigationRoute.getSettingController(data),"SETTINGS".localized())
//            case .accountScreen: return (NavigationRoute.getAccountController(data),"ACCOUNT".localized())
//            case .contactUsScreen: return (NavigationRoute.getContactUsController(data),"CONTACT US".localized())
//            case .privacyScreen: return (NavigationRoute.getPrivacyController(data),"PRIVACY".localized())
//            case .notificationScreen: return (NavigationRoute.getNotificationController(data),"NOTIFICATION".localized())
//            case .termsAndConditionsScreen: return (NavigationRoute.getSettingWebViewController(data),"TERMS OF SERVICES".localized())
//            case .privacyPolicyScreen: return (NavigationRoute.getSettingWebViewController(data),"PRIVACY POLICY".localized())
//
//            //Profile
//            case .profileScreen:
//                return (NavigationRoute.getProfileController(data),"PROFILE".localized())
//            case .editProfileScreen:
//                return (NavigationRoute.getEditProfileController(data),"EDIT PROFILE".localized())
//
//            //Plan
//            case .plannedHistoryScreen :
//                return (NavigationRoute.getPlanHistoryController(data),"PLAN HISTORY".localized())
//            case .planDitchedHistoryScreen: return (NavigationRoute.getPlanHistoryController(data),"DITCHED HISTORY".localized())
//
//            case .planAttendedHistoryScreen:
//                return (NavigationRoute.getPlanHistoryController(data),"ATTEND HISTORY".localized())
//            case .planCanceledHistoryScreen:
//                return (NavigationRoute.getPlanHistoryController(data),"CANCELED HISTORY".localized())
//            case .friendCurrentPlanDetailsScreen:
//                return (NavigationRoute.getFriendCurrentPlanDetailsController(data),"PLAN DETAILS".localized())
//            case .userCurrentPlanDetailsScreen:
//                return (NavigationRoute.getUserCurrentPlanDetailsController(data),"PLAN DETAILS".localized())
//            case .planPreviewScreen:
//                return (NavigationRoute.getPlanPreviewController(data),"PLAN DETAILS".localized())
//            case .planHistoryDetailsScreen:
//                return (NavigationRoute.getPlanHistoryDetailsController(data),"PLAN DETAILS".localized())
//            case .redeemedPlansScreen:
//                return (NavigationRoute.getRedeemedPlansController(data),"CLAIMED OFFERS".localized())
//
//            //Places
//            case .placesVisitedScreen:
//                return (NavigationRoute.getPlacesVisitedController(data),"PLACES VISITED".localized())
//            case .currentPlansScreen:
//                return (NavigationRoute.getCurrentPlansController(data),"".localized())
//            case .placeDetailsScreen:
//                return (NavigationRoute.getPlaceDetailsController(data),"PLACE DETAILS".localized())
//
//                //Friends
//            case .friendsScreen:
//                return (NavigationRoute.getFriendsController(data),"".localized())
//            case .newGroupSelectFriendScreen:
//                 return (NavigationRoute.getNewGroupSelectFriendsController(data),"NEW GROUP".localized())
//            case .selectFriendsScreen:
//                 return (NavigationRoute.getSelectFriendsController(data),"SELECT FRIENDS".localized())
//            case .selectDateAndTimeScreen:
//                 return (NavigationRoute.getSelectDateAndTimeController(data),"SELECT TIME & DATE".localized())
//
//            case .createGroupScreen :return (NavigationRoute.getCreateGroupController(data),"CREATE GROUP".localized())
//            case .trackingScreen :return (NavigationRoute.getTrackingController(data),"TRACK YOUR FRIENDS".localized())
//
//            case .offersListScreen :return (NavigationRoute.getOffersListController(data),"".localized())
//
//            case .qrCodeScreen :return (NavigationRoute.getQRCodeController(data),"CODE".localized())
//
//            case .showOfferScreen :return (NavigationRoute.showOffersViewController(data),"OFFERS".localized())
//            case .gpsEnableScreen :return (NavigationRoute.showGpsEnableScreen(data),"Enable GPS".localized())
//            case .appGpsEnableScreen :return (NavigationRoute.showAppGpsEnableScreen(data),"Enable App GPS".localized())
//            case .contactSynEnableScreen :return (NavigationRoute.showContactSyncEnableScreen(data),"Sync Contacts".localized())
//            case .demoScreen :return (NavigationRoute.showDemoFormScreen(data),"Demo Form".localized())
//            case .areaScreen :return (NavigationRoute.showAreaScreen(data),"Select Location".localized())
//            case .selectOfferScreen :return (NavigationRoute.showOfferSelectScreen(data),"Select Offer".localized())
//             case .customLocationScreen :return (NavigationRoute.showCustomLocationScreen(data),"Select Plan Location".localized())
            //Default
            default: return (UIViewController(), "")
                
            }
        }
    }
    
    //MARK:- Storyboards

    //Common Storyboards
    class func commonStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Common", bundle: Bundle.main)
    }

    //Onboarding Storyboards
    class func onboardingStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "OnBoard", bundle: Bundle.main)
    }
    
    //Home Storyboard
    class func homeStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Dashboard", bundle: Bundle.main)
    }
    
    //Inspection Storyboard
    class func inspectionsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Inspection", bundle: Bundle.main)
    }
    
    //Inventory Storyboard
    class func inventoryStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Inventory", bundle: Bundle.main)
    }
    
    // Setting Storyboard
    
    class func settingStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: Bundle.main)
    }
    
    class func profileStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Profile", bundle: Bundle.main)
    }
    
    class func planStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Plan", bundle: Bundle.main)
    }
    
    class func placeStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Place", bundle: Bundle.main)
    }
    
    class func friendsStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Friends", bundle: Bundle.main)
    }
    
    class func trackingStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Track", bundle: Bundle.main)
    }

    //MARK:- Common View Controllers
    
    // ///////////////////////////////////////// Common Flow Controllers ///////////////////////////////////////////////////
    
    class func getLoginScreen(_ data:[String:Any] = [:]) -> LoginViewController {
        return onboardingStoryboard().instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
    }
    
    class func getForgotPasswordScreen(_ data:[String:Any] = [:]) -> ForgotPasswordViewController {
        return onboardingStoryboard().instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
    }
    
    class func getVerifyOTPScreen(_ data:[String:Any] = [:]) -> CheckEmailViewController {
        return onboardingStoryboard().instantiateViewController(withIdentifier: "VerifyOTPViewController") as! CheckEmailViewController
    }
    
    class func getResetPasswordScreen(_ data:[String:Any] = [:]) -> ResetPasswordViewController {
        return onboardingStoryboard().instantiateViewController(withIdentifier: "ResetPasswordViewController") as! ResetPasswordViewController
    }
    
    class func getPasswordSuccessfullScreen(_ data:[String:Any] = [:]) -> PasswordResetSuccessfullViewController {
        return onboardingStoryboard().instantiateViewController(withIdentifier: "PasswordResetSuccessfullViewController") as! PasswordResetSuccessfullViewController
    }
    class func getMenuViewController(_ data:[String:Any] = [:]) -> SideMenuViewController {
        return homeStoryboard().instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
    }
    
    class func getHomeViewController(_ data:[String:Any] = [:]) -> DashboardViewController {
        return homeStoryboard().instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
    }
    
    class func getInventoryList(_ data:[String:Any] = [:]) -> InventoryListViewController {
        
        let viewController =  inventoryStoryboard().instantiateViewController(withIdentifier: "InventoryListViewController") as! InventoryListViewController
      
        
        return viewController
        
    }
    
    
    class func getInspectionList(_ data:[String:Any] = [:]) -> InspectionListViewController {
        
        let viewController =  inspectionsStoryboard().instantiateViewController(withIdentifier: "InspectionListViewController") as! InspectionListViewController
      
        
        return viewController
        
    }
    class func getRoutineInspBridgeDetail(_ data:[String:Any] = [:]) -> FormsControlllerViewController {
        let viewController =  inspectionsStoryboard().instantiateViewController(withIdentifier: "FormsControlllerViewController") as! FormsControlllerViewController
        
        if let value = data["BridgeDetail"] as? InspectionBridgeListModel {
            viewController.bridgeData = value
        }
        
        return viewController
        
    }
    
    
    class func getPopUpView(_ data:[String:Any] = [:]) -> PopUpViewController {
        let viewController =  commonStoryboard().instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
//        viewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext

//        if let value = data["BridgeDetail"] as? InspectionBridgeListModel {
//            viewController.bridgeData = value
//        }
        
        return viewController
        
    }
    
//    class func getBaseWebViewController(_ data:[String:Any] = [:]) -> BaseWebViewController {
//        let viewController = commonStoryboard().instantiateViewController(withIdentifier: "BaseWebViewController") as! BaseWebViewController
//
//        var analyticsData:[String:Any] = [:]
//
//        if let value = data["data"] as? String {
//            viewController.data = value
//            analyticsData["url"] = value
//        }
//
//        else if let value = data["url"] as? String {
//            viewController.data = value
//            analyticsData["url"] = value
//        }
//
//        else if let value = data["slug"] as? String {
//            viewController.slug = value
//            analyticsData["slug"] = value
//        }
//
//        if let value = data["isHtmlContent"] as? Bool {
//            viewController.isHtmlContent = value
//        }
//
//        if let value = data["scalePagesToFit"] as? Bool {
//            viewController.scalePagesToFit = value
//        }
//
//        if let value = data["allowBackForward"] as? Bool {
//            viewController.allowBackForward = value
//        }
//
//        viewController.analyticsData = analyticsData
//
//        return viewController
//    }
    
    class func getUnknownErrorViewController(_ data:[String:Any] = [:]) -> UnknownErrorViewController {
        let viewController = commonStoryboard().instantiateViewController(withIdentifier: "UnknownErrorViewController") as! UnknownErrorViewController
        if let value = data["manager"] as? NetworkReachabilityManager {
            viewController.manager = value
        }
        if let value = data["errorData"] as? EmptyStateViewStyler.EmptyViewData {
            viewController.emptyStateData = value
        }
        return viewController
    }
    
    class func getServerDownViewController(_ data:[String:Any] = [:]) -> ServerDownViewController {
        let viewController = commonStoryboard().instantiateViewController(withIdentifier: "ServerDownViewController") as! ServerDownViewController
        
        return viewController
    }
    
//    class func getImageCropperViewController(_ data:[String:Any] = [:]) -> ImageCropperViewController {
//        let viewController = commonStoryboard().instantiateViewController(withIdentifier: "ImageCropperViewController") as! ImageCropperViewController
//        return viewController
//    }
    
    //MARK:- Onboarding
    
//    class func getPhoneNumberController(_ data:[String:Any] = [:]) -> PhoneNumberController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "PhoneNumberController") as! PhoneNumberController
//
//        return viewController
//    }
//
//    class func getOTPController(_ data:[String:Any] = [:]) -> OTPViewController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
//
//        if let phone = data["phone"] as? String{
//            viewController.phoneNumber = phone
//        }
//
//        return viewController
//    }
//
//    class func getTutorialController(_ data: [String : Any] = [:]) -> TutorialsViewController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "TutorialsViewController") as! TutorialsViewController
//
//        if let value = data["CreateUserKeys"] as? CreateUserRequestKeys {
//            viewController.createUserRequestKeys = value
//        }
//
//        return viewController
//    }
//
//    class func getEnterNameController(_ data: [String : Any] = [:]) -> EnterNameController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "EnterNameController") as! EnterNameController
//
//        if let value = data["CreateUserKeys"] as? CreateUserRequestKeys {
//            viewController.createUserRequestKeys = value
//        }
//
//        return viewController
//    }
//
//    class func getEnterEmailController(_ data: [String : Any] = [:]) -> EnterEmailController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "EnterEmailController") as! EnterEmailController
//
//        if let value = data["CreateUserKeys"] as? CreateUserRequestKeys {
//            viewController.createUserRequestKeys = value
//        }
//
//        return viewController
//    }
//
//    class func getEnterDOBController(_ data: [String : Any] = [:]) -> EnterDOBController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "EnterDOBController") as! EnterDOBController
//
//        if let value = data["CreateUserKeys"] as? CreateUserRequestKeys {
//            viewController.createUserRequestKeys = value
//        }
//
//        return viewController
//    }
//
//    class func getEnterGenderController(_ data: [String : Any] = [:]) -> EnterGenderController {
//        let viewController = onboardingStoryboard().instantiateViewController(withIdentifier: "EnterGenderController") as! EnterGenderController
//
//        if let value = data["CreateUserKeys"] as? CreateUserRequestKeys {
//            viewController.createUserRequestKeys = value
//        }
//
//        return viewController
//    }
//
//    //MARK:- Home Controllers
//
//    class func getHomeController(_ data: [String : Any] = [:]) -> HomeController {
//        let viewController = homeStoryboard().instantiateViewController(withIdentifier: "HomeController") as! HomeController
//
//        if let value = data["isFirstTime"] as? Bool {
//            viewController.isFirstTime = value
//        }
//
//        return viewController
//    }
//
//    class func getDashboardController(_ data: [String : Any] = [:]) -> DashboardViewController {
//        let viewController = homeStoryboard().instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
//
//        if let value = data["isFirstTime"] as? Bool {
//            viewController.isFirstTime = value
//        }
//
//        return viewController
//    }
//
//    class func getMainTabBarViewController(_ data:[String: Any] = [:]) -> SortMainTabbarViewController {
//        let viewController = SortMainTabbarViewController()
//        return viewController
//    }
//
//
//    //MARK:- Settings Controller
//
//    class func getSettingController(_ data: [String : Any] = [:]) -> SettingMenuController {
//        let viewController = settingStoryboard().instantiateViewController(withIdentifier: "SettingMenuController") as! SettingMenuController
//        return viewController
//    }
//
//    class func getAccountController(_ data: [String : Any] = [:]) -> AccountController {
//        let viewController = settingStoryboard().instantiateViewController(withIdentifier: "AccountController") as! AccountController
//        return viewController
//    }
//
//    class func getContactUsController(_ data: [String : Any] = [:]) -> ContactUsController {
//        let viewController = settingStoryboard().instantiateViewController(withIdentifier: "ContactUsController") as! ContactUsController
//        return viewController
//    }
//
//    class func getPrivacyController(_ data: [String : Any] = [:]) -> PrivacyController {
//        let viewController = settingStoryboard().instantiateViewController(withIdentifier: "PrivacyController") as! PrivacyController
//        return viewController
//    }
//
//    class func getNotificationController(_ data: [String : Any] = [:]) -> NotificationController {
//        let viewController = settingStoryboard().instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
//        return viewController
//    }
//
//    class func getSettingWebViewController(_ data:[String:Any] = [:]) -> SettingsWebViewController {
//        let viewController = settingStoryboard().instantiateViewController(withIdentifier: "SettingsWebViewController") as! SettingsWebViewController
//
//        if let value = data["url"] as? String {
//            viewController.data = value
//        }
//
//        return viewController
//    }
//
//    class func getProfileController(_ data: [String : Any] = [:]) -> ProfileController {
//        let viewController = profileStoryboard().instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
//        if let user = data["user"] as? User {
//            viewController.currentUser = user
//        }
//
//        return viewController
//    }
//
//    class func getEditProfileController(_ data: [String : Any] = [:]) -> EditProfileController {
//        let viewController = profileStoryboard().instantiateViewController(withIdentifier: "EditProfileController") as! EditProfileController
//        return viewController
//    }
//
//    class func getPlanHistoryController(_ data: [String : Any] = [:]) -> PlannedHistoryController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "PlannedHistoryController") as! PlannedHistoryController
//
//        if let planHistoryStatus = data["status"] as? PlanHistoryStatus {
//            viewController.planHistorystatus = planHistoryStatus
//        }
//
//        return viewController
//    }
//
//    class func getCurrentPlansController(_ data: [String : Any] = [:]) -> CurrentPlansController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "CurrentPlansController") as! CurrentPlansController
//
//        if let currentLocation = data["currentLocation"] as? CLLocation {
//            viewController.currentLocation = currentLocation
//        }
//
//        return viewController
//    }
//
//    class func getPlaceDetailsController(_ data: [String : Any] = [:]) -> PlaceDetailsController {
//        let viewController = placeStoryboard().instantiateViewController(withIdentifier: "PlaceDetailsController") as! PlaceDetailsController
//
//        if let place = data["place"] as? Place {
//            viewController.placeId = place.placeId ?? ""
//        }
//
//        return viewController
//    }
//
//    class func getPlacesVisitedController(_ data: [String : Any] = [:]) -> PlacesVisitedController {
//        let viewController = placeStoryboard().instantiateViewController(withIdentifier: "PlacesVisitedController") as! PlacesVisitedController
//        return viewController
//    }
//
//    class func getFriendCurrentPlanDetailsController(_ data : [String : Any] = [:]) -> FriendCurrentPlanDetailsController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "FriendCurrentPlanDetailsController") as! FriendCurrentPlanDetailsController
//        if let plan = data["plan"] as? Plan {
//            viewController.plan = plan
//        }
//
//        if let planId = data["plan_id"] as? String {
//            viewController.planId = planId
//        }
//
//        if let isOn = data["is_on"] as? Bool {
//            viewController.isOn = isOn
//        }
//
////        if let currentLocation = data["currentLocation"] as? CLLocation {
////            viewController.currentLocation = currentLocation
////        }
//
//        return viewController
//    }
//
//    class func getUserCurrentPlanDetailsController(_ data : [String : Any] = [:]) -> UserCurrentPlanDetailsController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "UserCurrentPlanDetailsController") as! UserCurrentPlanDetailsController
//
//        if let plan = data["plan"] as? Plan {
//            viewController.plan = plan
//        }
//
////        if let currentLocation = data["currentLocation"] as? CLLocation {
////            viewController.currentLocation = currentLocation
////        }
//
//        return viewController
//    }
//
//    class func getPlanHistoryDetailsController(_ data : [String : Any] = [:]) -> PlanHistoryDetailsController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "PlanHistoryDetailsController") as! PlanHistoryDetailsController
//
//        if let plan = data["plan"] as? Plan {
//            viewController.plan = plan
//        }
//
//        return viewController
//    }
//
//    class func getRedeemedPlansController(_ data : [String : Any] = [:]) -> RedeemedPlansViewController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "RedeemedPlansViewController") as! RedeemedPlansViewController
//        return viewController
//    }
//
//    class func getPlanPreviewController(_ data : [String : Any] = [:]) -> PlanPreviewController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "PlanPreviewController") as! PlanPreviewController
//
//        if let place = data["place"] as? Place {
//            viewController.place = place
//        }
//
//        if let selectedContact = data["contact"] as? [User] {
//            viewController.selectedContact = selectedContact
//        }
//
//        return viewController
//    }
//
//    class func getFriendsController(_ data : [String : Any] = [:]) -> FriendsController {
//        let viewController = friendsStoryboard().instantiateViewController(withIdentifier: "FriendsController") as! FriendsController
//        return viewController
//    }
//
//    class func getNewGroupSelectFriendsController(_ data : [String : Any] = [:]) -> NewGroupSelectFriendsController {
//        let viewController = friendsStoryboard().instantiateViewController(withIdentifier: "NewGroupSelectFriendsController") as! NewGroupSelectFriendsController
//        return viewController
//    }
//
//    class func getSelectFriendsController(_ data : [String : Any] = [:]) -> SelectFriendsController {
//        let viewController = friendsStoryboard().instantiateViewController(withIdentifier: "SelectFriendsController") as! SelectFriendsController
//
//        if let place = data["place"] as? Place {
//            viewController.place = place
//        }
//
//        if let isInstant  = data["isInstant"] as? Bool {
//            viewController.isInstant = isInstant
//        }
//
//        return viewController
//    }
//
//    class func getSelectDateAndTimeController(_ data : [String : Any] = [:]) -> SelectDateAndTimeController {
//        let viewController = friendsStoryboard().instantiateViewController(withIdentifier: "SelectDateAndTimeController") as! SelectDateAndTimeController
//        return viewController
//    }
//
//    class func getCreateGroupController(_ data : [String : Any] = [:]) -> CreateGroupController {
//        let viewController = friendsStoryboard().instantiateViewController(withIdentifier: "CreateGroupController") as! CreateGroupController
//
//        if let selectedContacts = data["selected"] as? [User] {
//            viewController.selectedUser = selectedContacts
//        }
//
//        return viewController
//    }
//
//    class func getTrackingController(_ data : [String : Any] = [:]) -> TrackingController {
//        let viewController = trackingStoryboard().instantiateViewController(withIdentifier: "TrackingController") as! TrackingController
//
//        if let plan = data["plan"] as? Plan {
//            viewController.plan = plan
//        }
//
//        return viewController
//    }
//
//    class func getOffersListController(_ data : [String : Any] = [:]) -> OffersListViewController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "OffersListViewController") as! OffersListViewController
//
//        return viewController
//    }
//
//    class func getQRCodeController(_ data : [String : Any] = [:]) -> QRCodeViewController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
//
//        if let plan = data["scanModel"] as? ScanCodeModel {
//            viewController.scanCodeModel = plan
//        }
//
//        return viewController
//    }
//
//    class func showOffersViewController(_ data : [String : Any] = [:]) -> OffersViewController {
//        let viewController = placeStoryboard().instantiateViewController(withIdentifier: "OffersViewController") as! OffersViewController
//
//        return viewController
//    }
//
//    class func showGpsEnableScreen(_ data : [String : Any] = [:]) -> EnableGpsViewController {
//           let viewController = commonStoryboard().instantiateViewController(withIdentifier: "EnableGpsViewController") as! EnableGpsViewController
//
//           return viewController
//       }
//
//    class func showAppGpsEnableScreen(_ data : [String : Any] = [:]) -> EnableAppGpsViewController {
//        let viewController = commonStoryboard().instantiateViewController(withIdentifier: "EnableAppGpsViewController") as! EnableAppGpsViewController
//
//        return viewController
//    }
//
//    class func showContactSyncEnableScreen(_ data : [String : Any] = [:]) -> EnableContactSyncViewController {
//        let viewController = commonStoryboard().instantiateViewController(withIdentifier: "EnableContactSyncViewController") as! EnableContactSyncViewController
//        if let value = data["CreateUserKeys"] as? CreateUserRequestKeys {
//            viewController.createUserRequestKeys = value
//        }
//
//        return viewController
//    }
//
//    class func showDemoFormScreen(_ data : [String : Any] = [:]) -> DemoProfileViewController {
//        let viewController = profileStoryboard().instantiateViewController(withIdentifier: "DemoProfileViewController") as! DemoProfileViewController
//
//        return viewController
//    }
//
//
//
//    class func showAreaScreen(_ data : [String : Any] = [:]) -> AreaViewController {
//         let viewController = homeStoryboard().instantiateViewController(withIdentifier: "AreaViewController") as! AreaViewController
//
//        if let delegate = data["delegate"] as? AreaViewControllerDelegate {
//            viewController.delegate = delegate
//        }
//
//        return viewController
//    }
//
//    class func showOfferSelectScreen(_ data : [String : Any] = [:]) -> SelectOfferViewController {
//        let viewController = planStoryboard().instantiateViewController(withIdentifier: "SelectOfferViewController") as! SelectOfferViewController
//
//         if let plan = data["plan"] as? Plan {
//            viewController.plan = plan
//
//         }
//        if  let delegate = data["delegate"] as? SelectOfferViewControllerDelegate{
//            viewController.delegate = delegate
//
//        }
//
//
//        return viewController
//    }
//
//
//    class func showCustomLocationScreen(_ data : [String : Any] = [:]) -> CustomLocationAddViewController {
//           let viewController = homeStoryboard().instantiateViewController(withIdentifier: "CustomLocationAddViewController") as! CustomLocationAddViewController
//
//           return viewController
//       }
}
