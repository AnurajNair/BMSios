//
//  EmptyStateViewStyler.swift
//  bms
//
//  Created by Naveed on 16/10/22.
//

import Foundation
import UIKit

class EmptyStateViewStyler {
    
    static var emptyViewCenterConstraint: CGFloat = 0.0
    static var emptyTitleFont: UIFont { return UIFont.BMS.InterBold.withSize(24) }
    static var emptyTitleColor: UIColor { return UIColor.BMS.fontBlack }
    static var emptyDescriptionFont: UIFont { return UIFont.BMS.InterBold.withSize(15) }
    static var emptyDescriptionColor: UIColor { return UIColor.BMS.fontBlack }
    static var emptyFirstButtonStyle: Styler.buttonBackgroundStyle  { return ButtonStyles.emptyStateButton }
    static var emptyDefaultImage: String { return "logo-vertical-black" }
    static var emptyImageContentMode: UIView.ContentMode  { return UIView.ContentMode.scaleAspectFit }
    static var emptyBackgroundImageContentMode: UIView.ContentMode  { return UIView.ContentMode.scaleAspectFill }
    static var emptyBackgroundImage: String  { return "background" }
    static var emptyBackgroundImageHeightConstraint: CGFloat = 200.0
    static var emptyTitle: String { return "" }
    static var emptyMessage: String { return "No information yet. We will update you if any.".localized() }
    static var emptySearchMessage: String { return "No search results. Try something different?".localized() }
     static var emptyMyCurrentPlansMessage: String { return "You are missing this out. You don’t have any plans!.".localized() }
    static var emptyStateButtonTitle: String { return "" }
    static var shouldShowUpByDefault: Bool { return false }
    static var shouldShowTitle: Bool { return false }
    
    struct EmptyViewData {
        var image: String
        var title: String
        var message: String
        var buttonTitle: String
        var imageContentMode: UIView.ContentMode
        var backgroundImage: String
        var backgroundImageHeight: CGFloat
        var backgroundImageContentMode: UIView.ContentMode
        var emptyViewCenterConstraint: CGFloat
        var shouldShowUpByDefault: Bool
        var shouldShowTitle: Bool
    }
    
    /// Default empty view data
    static var defaultEmptyViewData: EmptyViewData {
        let data = EmptyViewData(image: emptyDefaultImage,
                                   title: emptyTitle,
                                   message: emptyMessage,
                                   buttonTitle: emptyStateButtonTitle,
                                   imageContentMode: emptyImageContentMode,
                                   backgroundImage: emptyBackgroundImage,
                                   backgroundImageHeight: emptyBackgroundImageHeightConstraint,
                                   backgroundImageContentMode: emptyBackgroundImageContentMode,
                                   emptyViewCenterConstraint: emptyViewCenterConstraint,
                                   shouldShowUpByDefault: shouldShowUpByDefault,
                                   shouldShowTitle: shouldShowTitle)
        return data
    }
    
    /// Empty view data for search results
    static var emptySearchResultsData: EmptyViewData {
        var data = defaultEmptyViewData
        data.message = emptySearchMessage
        return data
    }
    
    /// Empty view data for too many attempts error message
    static var tooManyAttemptsErrorMessageData: EmptyViewData {
        var data = defaultEmptyViewData
        data.title = "Whoopsy Daisy".localized()
        data.shouldShowTitle = true
        data.message = "Too Many Attempts".localized()
        data.buttonTitle = "Retry".localized()
        return data
    }
    
    static var emptyMyCurrentPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyMyPlans"
        data.imageContentMode = .center
        data.message = emptyMyCurrentPlansMessage
        return data
    }
    
    static var emptyFriendsCurrentPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyFriendsPlans"
        data.imageContentMode = .center
        data.message = "Here you will find all the plans you have been invited for by your friends."
        return data
    }
    
    static var emptyOffersPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyOffer"
        data.imageContentMode = .center
        data.message = "Here you can see your offer, after you check-in in the restaurant."
        return data
    }
    
    static var emptyClaimedOffersPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyList"
        data.imageContentMode = .center
        data.message = "No offer claimed, here you see all the offers you claimed."
        return data
    }
    
    static var serverDownData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "serverdown"
        data.imageContentMode = .center
        data.message = "Server is down.\nPlease wait for some time and come again."
        return data
    }
    
    static var emptyCreatedPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyCreatedPlans"
        data.imageContentMode = .center
        data.message = "No plans!\nHere you can see the list of all plans made by you."
        return data
    }
    
    static var emptyDitchedPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyDitched"
        data.imageContentMode = .center
        data.message = "You haven’t ditched any plans yet! Keep this score as low as possible."
        return data
    }
    
    static var emptyAttendedPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyAttended"
        data.imageContentMode = .center
        data.message = "Here you see all the plans you have attended of your friends! "
        return data
    }
    
    static var emptyCanceledPlanData: EmptyViewData {
        var data = defaultEmptyViewData
        data.image = "emptyCancel"
        data.imageContentMode = .center
        data.message = "Here you see all the plans you canceled."
        return data
    }
    
    
    /**
     Returns emtpy view data according to screen type.
     - parameter forScreenType: NavigateRoute.ScreenType of view controller for which empty view data is needed.
     - returns: TTEmptyViewData consisting all the required data to setup empty view.
     - note: Can be moved inside NavigateRoute.ScreenType enum.
     */
    class func getEmptyViewData(forScreenType screenTye: NavigationRoute.ScreenType) -> EmptyViewData {
        switch screenTye {
//        case .manageProjectsListing:
//            var data = defaultEmptyViewData
//            data.title = "No Projects Added yet!".localized()
//            data.message = "Please add projects.".localized()
//            return data
//
//        case .todoAssignee, .projectSetupAddAdmin, .projectSetupAddUser:
//            var data = defaultEmptyViewData
//            data.title = "No Users Found".localized()
//            data.message = "No users added yet!.".localized()
//            return data
//
//        case .recentCheckins:
//            var data = defaultEmptyViewData
//            data.title = "Recent Checkins".localized()
//            data.message = "No recent checkins yet. We will update you if any.".localized()
//            return data
//
//        case .memberTodoListing, .projectTodoListing:
//            var data = defaultEmptyViewData
//            data.title = "Todos".localized()
//            data.message = "No todos assigned yet. We will update you if any.".localized()
//            return data
//
//        case .teamActivityListing, .memberActivityListing, .projectActivityListing:
//            var data = defaultEmptyViewData
//            data.title = "Activity".localized()
//            data.message = "No activities yet. We will update you if any.".localized()
//            return data
//
//        case .teamReportListing, .memberReportListing, .projectReportListing:
//            var data = defaultEmptyViewData
//            data.title = "Reports".localized()
//            data.message = "No reports yet. We will update you if any.".localized()
//            return data
//
//        case .notificationsListing:
//            var data = defaultEmptyViewData
//            data.title = "Notifications".localized()
//            data.message = "No notifications yet. We will update you if any.".localized()
//            return data
//
//        case .memberMentionsListing:
//            var data = defaultEmptyViewData
//            data.title = "Mentions".localized()
//            data.message = "No mentions yet. We will update you if any.".localized()
//            return data
//
//        case .projectListing:
//            var data = defaultEmptyViewData
//            data.title = "Projects".localized()
//            data.message = "No projects yet. We will update you if any.".localized()
//            return data
//
//        case .teamPeopleListing:
//            var data = defaultEmptyViewData
//            data.title = "People".localized()
//            data.message = "No people yet. We will update you if any.".localized()
//            return data
//
//        case .composeAddAttachment:
//            var data = defaultEmptyViewData
//            data.message = "No attachments yet. Add a new Attachment?".localized()
            //            return data
            
        case .unknownError:
            var data = defaultEmptyViewData
            data.image = "no-internet"
            data.title = "You’re Offline".localized()
            data.shouldShowTitle = true
            data.message = "No internet connection. Please try again after connecting.".localized()
            data.buttonTitle = "Try Again".localized()
            data.shouldShowUpByDefault = true
            return data
            
        case .serverDownScreen:
            var data = defaultEmptyViewData
            data.image = "serverdown"
            data.title = "".localized()
            data.imageContentMode = UIView.ContentMode.scaleAspectFill
            data.shouldShowTitle = true
            data.message = "Server is down.\nPlease wait for some time and come again.".localized()
            data.buttonTitle = "Try Again".localized()
            data.shouldShowUpByDefault = false
            data.shouldShowTitle = false
            return data
            
        default:
            return defaultEmptyViewData
        }
    }
}

