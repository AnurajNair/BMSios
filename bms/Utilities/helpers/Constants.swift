//
//  Constants.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit
import CoreLocation

class Constants {
    
     static let osType = "iOS"
    
    //MARK:- API Helpers
    static let apiBaseUrl = Utils.getSchemeKey("API_BASE_URL")
   

    //MARK:- Third Party Helpers
    
//    static let googlePlacesClientApiKey = Utils.getSchemeKey("GOOGLE_GMS_PLACES_CLIENT_API_KEY")
//    static let googleServicesApiKey = Utils.getSchemeKey("GOOGLE_GMS_SERVICES_API_KEY")
////    static let googleSignInClientKey = Utils.getSchemeKey("GOOGLE_SIGNIN_CLIENT_KEY")
//    static let googleServiceInfoPlist = Utils.getSchemeKey("GOOGLE_SERVICE_INFO_PLIST")
    

    //MARK:- General Helpers
    static let cardRadiusGeneral = CGFloat(10)
    
    
    static var badgeValue: Int = 0 {
        didSet {
            UIApplication.shared.applicationIconBadgeNumber = Constants.badgeValue
        }
    }
    
    static let defaultHeaderHeight : CGFloat = 12
    static let serverTimeoutInterval = 100.0
    static let screenBounds = UIScreen.main.bounds.size
    static let statusBarHeight = UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive }
        .map {$0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter({ $0.isKeyWindow }).first?
        .windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    static let popupBounds = CGSize(width: Constants.screenBounds.width - 40, height: Constants.screenBounds.height - 160)
    static let bundleVersion = Utils.getSchemeKey("CFBundleShortVersionString")
    static let bundleBuildNumber = Utils.getSchemeKey("CFBundleVersion")
    static let appDisplayName = Utils.getSchemeKey("CFBundleName")
    static let apiResponseInitialLimit = 5
    static let apiResponsePaginationLimit = 10
    static let apiListingPaginationLimit = 15
    static let infiniteFetchThreshold = 1
    static let showValidityLabelThreshold = 5
    static let linkAttributeName = "LinkAttributeName"
    static let dateFormat = "dd MMM yyyy"
    static let serverDateFormat = "yyyy-MM-dd"
    static let serverDateTimeFormat = "yyyy-MM-dd HH:mm:ss"
    static let pythonServerDateTimeFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    static let displayDateFormat = "dd/MM/yyyy"
    static let displayDateTimeFormat = "dd MMM yyyy | hh:mm aa"
    static let attachmentDateTimeFormat = "dd-MMM-yy '-' hh:mm:ss aa"
    static let displayDayDateTimeFormat = "EEE, dd-MMM-yy 'at' hh:mm aa"
    static let serverTimeFormat = "hh:mm aa"
    static let displayTimeFormat = "hh:mm aa"
    
    //MARK:- Messages
    struct Messages{
        static let unknownError = "There seems to be some problem. Please hang on while we resolve it".localized()
        static let overallValidationError = "Oops! Something's not filled in correctly on this page, please address it to proceed.".localized()
        static let selectProfilePicture = "Please upload your photo to complete your profile."
        static let invalidOtp = "Please enter valid OTP."
        
        static let rateInfo = "This is an approx cost,it might change depending on your appetite,or with changes in restaurant menu prices.\n\n"
        
        static let contactPermission = "Syncing contacts is necessary to use Sortted.\n"
        
         static let locationPermission = "Enabling location is necessary to use Sortted.\n"
        
    }
    
    struct Post{
        static let postError = "Not able to find out this post.\nSeems like the post has been deleted by the poster.".localized()
    }
    
    //MARK:- Notification observer
    static let pushNotificationEnabled = "com.snapteam.enable.push.notification"
    
    struct URI {
        
//        static let slackRedirectUri = "\(apiBaseUrl)mobile-slack-login"
//        static let connectToSlack = "\(slackRedirectUri)?slackLoginType=connectSlack&redirect_uri=\(slackRedirectUri)"
//        static let loginToSlack = "\(slackRedirectUri)?slackLoginType=loginSlack&redirect_uri=\(slackRedirectUri)"
    }
    
    struct PermissionMessage {
        static let contactPermission = "Provide the accss to your Contacts to provide you more accurate result regarding your friends list."
         static let appLocationPermission = "Provide the accss to your Location to provide you more accurate result and near by Restaurant."
    }
    
    struct DiscoverView {
        static let cellWidth = ((Constants.screenBounds.width) )
        static let cellHeight = (Constants.screenBounds.width * 0.3)
    }
    
    
    struct StaticWebPages {
    
    }
    
    struct InvitationAction {
        static let ACCEPT_ACTION_IDENTIFIER = "ACCEPT_ACTION"
        static let DECLINE_ACTION_IDENTIFIER = "DECLINE_ACTION"
        
        static let ACCEPT_ACTION_TITLE = "IN"
        static let DECLINE_ACTION_TITLE = "OUT"
    }
    
    struct Tracking {
        static let START_TIME_MINUTES = -15
        static let STOP_TIME_MINUTES = 30
        static let MINIMUM_DISTANCE_TO_ATTEND : CLLocationDistance = 500
    }
    
//    static let appStoreLocation : String = "itms://itunes.apple.com/us/app/apple-store/sortted/id1462857356?ls=1"
    
    
 
    
}
