//
//  AppStyler.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit

class AppStyler {
    
}

struct TextStyles {
    static let ScreenHeaderTitle: Styler.textStyle = (UIFont.BMS.InterBold.withSize(35), UIColor.BMS.fontBlack)
    static let ScreenSubTitle: Styler.textStyle = (UIFont.BMS.InterSemiBold.withSize(40), UIColor.BMS.fontBlack)

    static let ListItemBlackTitle: Styler.textStyle = (UIFont.BMS.InterRegular.withSize(17), UIColor.BMS.fontBlack)
    static let ListHeaderGreyTitle: Styler.textStyle = (font: UIFont.BMS.InterSemiBold.withSize(15), color: UIColor.BMS.bmsLabelGrey)

    static let TappableBaseStyle: Styler.textStyle = (UIFont.BMS.InterRegular.withSize(12), UIColor.BMS.fontBlack)
    static let TappableLinkStyle: Styler.textStyle = (UIFont.BMS.InterBold.withSize(12), UIColor.BMS.blue)
    static let WhiteHeaderTitle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(14), UIColor.BMS.fontWhite)
    static let WhiteHeaderSubTitle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(12), UIColor.BMS.fontWhite)
    static let ToastMessageStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(14), UIColor.BMS.fontWhite)
    
    //MARK
    
    static let LoginPageLableStyler : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(26), UIColor.BMS.black)
    static let TitleLabelStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(13), UIColor.BMS.titleFont)
    
    static let TutorialTitleLabelStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(19), UIColor.BMS.tutorialTitleFont)
    
    static let TutorialSubitleLabelStyle : Styler.textStyle = (UIFont.BMS.InterLight.withSize(15), UIColor.BMS.titleFont)
    
    static let OptionSelectedLabelStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(9), UIColor.BMS.fontBlack)
    
    static let OptionUnSelectedLabelStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(9), UIColor.BMS.fontBlack)
    
    static let GenderSelectionTitleLabelStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(14), UIColor.BMS.fontBlack)
    
    static let SettingTitleLabelStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack)
    
    static let SettingSubTitleLabelStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(14), UIColor.BMS.fontGray)
    
     static let SearchTextFieldStyle : Styler.textStyle = (UIFont.BMS.InterLight.withSize(14), UIColor.BMS.fontBlack)
    
    static let ProfileNameText : Styler.textStyle = (UIFont.BMS.InterBold.withSize(12), UIColor.BMS.fontBlack)
    
    static let ActiveProfileTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack)
    
    static let ProfilePlanTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack.withAlphaComponent(0.4))
    
    static let ProfilePlanCountStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(12), UIColor.BMS.fontBlack)
    
    static let EditProfileHeaderTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(10), UIColor.BMS.fontBlack.withAlphaComponent(0.5))
    
    static let PlaceVisitedTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(15), UIColor.BMS.fontBlack)
    
    static let PlaceVisitedSubTitleStyle : Styler.textStyle = (UIFont.BMS.InterLight.withSize(9), UIColor.BMS.fontBlack)
    
    static let PlansTabTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(12), UIColor.BMS.fontBlack)
    
    static let PlansTabCountStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(12), UIColor.BMS.fontWhite)
    
    static let PlanDetailsMetaItemStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(9), UIColor.BMS.fontBlack.withAlphaComponent(0.4))
    
    static let PlanDetailsItemTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack.withAlphaComponent(0.4))
    
    static let PlanDetailsItemSubTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(15), UIColor.BMS.fontBlack)
    
    static let FriendCurrentPlanDetailsSectionTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack.withAlphaComponent(0.4))
    static let FriendCurrentPlanDetailsSectionTitleTwoStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(16), UIColor.BMS.fontBlack)
    
    static let SelectFriendsSectionTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack)
    
     static let ContactUsImageTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(10), UIColor.BMS.fontBlack)
    
    static let PlanHistoryTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(16), UIColor.BMS.fontBlack)
    
    static let PlanHistorySubTitleStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(12), UIColor.BMS.fontBlack)
    
     static let UserCurrentPlanMetaLblStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack.withAlphaComponent(0.65))
    
    static let UserCurrentViewMapLblStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(8), UIColor.BMS.fontWhite)
    
    static let UserCurrentPlaceNameLblStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(18), UIColor.BMS.fontBlack)
    
    static let PlacePeekLblStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack)
    
    static let PlaceDetailsRateTitleLblStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(12), UIColor.BMS.fontBlack)
    
    static let PlaceDetailsRateLblStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(16), UIColor.BMS.fontBlack)
    
    static let PlaceDetailsRateSubTitleTitleLblStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.fontBlack)
    static let HomeButtonTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(11), UIColor.BMS.fontWhite)
    static let ActionButtonTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(11), UIColor.BMS.fontWhite)
    static let MapMarkerPinTitle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(11), UIColor.BMS.fontBlack.withAlphaComponent(0.8))
    static let DiscoveViewCellSubTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(12), UIColor.BMS.fontWhite)
    
    static let DiscoveViewCellActionTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(15), UIColor.BMS.fontWhite)
    
    static let DiscoveViewCellActionTwoTitleStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(9), UIColor.BMS.fontWhite)
    
    static let DiscoveViewCellActionOpenTimeStatusStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(12), UIColor.BMS.sorttedGreen)
    
    static let DiscoveViewCellActionCloseTimeStatusStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(12), UIColor.BMS.red)
    
    static let DiscoverViewCellOfferDiscStyle : Styler.textStyle = (UIFont.BMS.InterRegular.withSize(10), UIColor.BMS.red)
    
    static let RespondedStatusStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(6), UIColor.BMS.fontWhite)
    
    static let DashboardHeaderStyle : Styler.textStyle = (UIFont.BMS.InterBold.withSize(24), UIColor.BMS.fontBlack)
}

struct ButtonStyles {
    
    static let defaultFabButtonHeight:CGFloat = 52
    static let defaultRegularButtonHeight:CGFloat = 44
    static let defaultLinkButtonHeight:CGFloat = 44
    
    //Base Button for All Buttons
    private static var baseButtonStyle: Styler.buttonBackgroundStyle {
        get {
            var button = Styler.baseButtonStyle
            button.font = UIFont.BMS.InterRegular.withSize(14)
            button.titleColor = UIColor.BMS.fontWhite
            button.tintColor = UIColor.BMS.white
            button.shadowStyle = ShadowStyles.buttonShadowStyle
            return button
        }
    }
    
    //Base Blue Rounded Button
    private static var baseRoundedButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.backgroundColor = UIColor.BMS.white
            button.tintColor = UIColor.BMS.black
            return button
        }
    }
    
    static var continueBtn: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.black
            
            button.cornerRadius = 27.5
            
            return button
        }
    }
    
    static var whiteButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.white
            button.tintColor = UIColor.BMS.white
            return button
        }
    }
    
    static var homeMenuBtn: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.lightGray
            
            button.cornerRadius = 25
            
            button.buttonImage = "sortted_circular_icon"
            
            button.shadowStyle = nil
            
            return button
        }
    }
    
    static var callBtn: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.black
            
            button.tintColor = UIColor.BMS.white
            
            button.cornerRadius = 30
            
            button.buttonImageRenderingMode = .alwaysTemplate
            
            button.buttonImage = "phone_icon"
            
            
            return button
        }
    }
    
    static var myLocationBtn: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.white
            
            button.tintColor = UIColor.BMS.black
            
            button.cornerRadius = 15
            
            button.buttonImage = "current_location"
            
            return button
        }
    }
    
    static var offerButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.white
            
            button.tintColor = UIColor.BMS.black
            
            button.cornerRadius = 22
            
            button.buttonImage = "offer"
            
            return button
        }
    }
    
    
    static var detailsButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.clear
            
            button.borderStyle = (edges: .all, color: UIColor.BMS.separatorGray, thickness: 1)
            
            button.tintColor = UIColor.BMS.black
            
            button.titleColor = UIColor.BMS.black
            
            button.overrideDefaultTextCase = true
    
            button.cornerRadius = 8
            
            button.font = UIFont.BMS.InterRegular.withSize(9)
            
            button.shadowStyle = nil
            
            return button
        }
    }
    static var locationToggleButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.white
            
            button.tintColor = UIColor.BMS.black
            
            button.cornerRadius = 22
            
            button.buttonImage = "locationToggle"
            
            return button
        }
    }
    
    static var locationToggleButtonOn: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            
            button.backgroundColor = UIColor.BMS.sorttedGreen
            
            button.tintColor = UIColor.BMS.white
            
            button.cornerRadius = 22
            
            button.buttonImage = "locationToggle"
            
            return button
        }
    }
    
    static var blackButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.fontWhite
            button.backgroundColor = UIColor.BMS.black
            button.font = UIFont.BMS.InterRegular.withSize(8)
            button.shadowStyle = nil
            return button
        }
    }
    
    static var blackBottomButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.fontWhite
            button.backgroundColor = UIColor.BMS.black
            button.font = UIFont.BMS.InterBold.withSize(14)
            button.shadowStyle = nil
            button.cornerRadius = 0
            return button
        }
    }
    static var greenBottomButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.fontWhite
            button.backgroundColor = UIColor.BMS.gradientEndColor
            button.font = UIFont.BMS.InterBold.withSize(14)
            button.shadowStyle = nil
            button.cornerRadius = 0
            return button
        }
    }
    
    static var barMenuButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseRoundedButton
            button.buttonImage = ""
            button.cornerRadius = 20
            button.shadowStyle = ShadowStyles.CardShadowStyle
            return button
        }
    }
    
    static var inverseBlackButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.black
            button.backgroundColor = UIColor.BMS.white
            button.font = UIFont.BMS.InterBold.withSize(20)
            button.shadowStyle = nil
            return button
        }
    }
    
    //Blue Button with Add Image
    static var blueAddButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseRoundedButton
            button.buttonImage = "navigation-button-add"
            return button
        }
    }
    
    //Blue Button with Done Image
    static var blueDoneButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseRoundedButton
            button.buttonImage = "navigation-button-done"
            return button
        }
    }
    
    //Blue Button with Compose Image
    static var blueComposeButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseRoundedButton
            button.buttonImage = "navigation-button-compose"
            return button
        }
    }
    
    //Blue Button with Next Image
    static var whiteNextButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseRoundedButton
            button.buttonImage = "navigation-next"
            button.cornerRadius = ButtonStyles.defaultFabButtonHeight/2
            return button
        }
    }
    
    //Blue Button with White Text
    static var blueButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.fontWhite
            button.backgroundColor = UIColor.BMS.blue
            return button
        }
    }
    
    //White Button with Blue Text
    static var inverseBlueButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.blue
            button.backgroundColor = UIColor.BMS.white
            return button
        }
    }
    
    //Inverse Blue Button for Empty State
    static var emptyStateButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.inverseBlueButton
            button.contentEdgeInsets = UIEdgeInsets.init(top: 16, left: 30, bottom: 16, right: 30)
            button.cornerRadius = 23
            return button
        }
    }
    
    //Table View Footer Button with Shadow - White Background - Blue Text
    static var tableViewFooterButton: Styler.buttonBackgroundStyle {
        var buttonStyle = ButtonStyles.baseButtonStyle
        buttonStyle.titleColor = UIColor.BMS.blue
        buttonStyle.backgroundColor = UIColor.BMS.white
        buttonStyle.shadowStyle = ShadowStyles.NormalShadowStyle
        buttonStyle.cornerRadius = 0
        return buttonStyle
    }
    
    //White Button with Red Text
    static var inverseRedButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.red
            button.backgroundColor = UIColor.BMS.white
            button.overrideDefaultTextCase = true
            button.shadowStyle = nil
            return button
        }
    }
    
    //Green Button with White Text
    static var greenButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.white
            button.tintColor = UIColor.BMS.white
            button.backgroundColor = UIColor.BMS.sorttedGreen
            button.cornerRadius = 27.5
            
            return button
        }
    }
    
    static var inverseGreenButtonPlain: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.sorttedGreen
            button.tintColor = UIColor.BMS.sorttedGreen
            button.backgroundColor = UIColor.BMS.white
            button.cornerRadius = 27.5
            return button
        }
    }

    
    static var greenDoneButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.white
            button.tintColor = UIColor.BMS.white
            button.buttonImage = "navigation-button-done"
            button.cornerRadius = 27.5
            return button
        }
    }
    
    static var greenThumbsButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.white
            button.tintColor = UIColor.BMS.white
            button.buttonImage = "done_action"
            button.cornerRadius = 27.5
            return button
        }
    }
    
    //Green Button with White Text
    static var greenNextButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.white
            
            button.tintColor = UIColor.BMS.white
            button.buttonImage = "next"
            button.cornerRadius = 27.5
            return button
        }
    }
    
    
    //call button
    
    static var callButton: Styler.buttonBackgroundStyle {
           get {
               var button = ButtonStyles.baseButtonStyle
               button.titleColor = UIColor.BMS.white
               
               button.tintColor = UIColor.BMS.black
               button.buttonImage = "capture"
               button.cornerRadius = 27.5
               return button
           }
       }
    
    //White Button with Green Text
    static var inverseGreenButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.green
            button.backgroundColor = UIColor.BMS.white
            button.tintColor = UIColor.BMS.green
            button.overrideDefaultTextCase = true
            button.shadowStyle = nil
            
            let borderStyle : Styler.borderStyle = (edges: .all, color: UIColor.BMS.green, thickness: 1)
            button.borderStyle = borderStyle
            button.buttonImage = "navigation-button-add"
            button.buttonImageRenderingMode = .alwaysTemplate
            button.cornerRadius = 3
            
            return button
        }
    }
    
    //Link Button with Blue Text
    static var linkBlueButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.blue
            button.backgroundColor = UIColor.BMS.clear
            button.shadowStyle = nil
            return button
        }
    }
    
    //Link Button with Blue Text
    static var linkBlackButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.black
            button.backgroundColor = UIColor.BMS.clear
            button.isUnderlined = false
            button.shadowStyle = nil
            button.overrideDefaultTextCase = true
            return button
        }
    }
    
    //Input Accessory Buttons
    static var inputAccessoryButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.cornerRadius = 0.0
            button.tintColor = UIColor.BMS.black
            button.buttonImageRenderingMode = .alwaysTemplate
            button.shadowStyle = nil
            return button
        }
        
    }
    
    //Task Navigator Button
    static var navigatorButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.titleColor = UIColor.BMS.fontWhite
            button.backgroundColor = UIColor.BMS.purple
            button.isUnderlined = false
            button.shadowStyle = nil
            button.overrideDefaultTextCase = true
            button.cornerRadius = 3
            button.contentEdgeInsets = UIEdgeInsets(top: 3, left: 8, bottom: 3, right: 8)
            //button.buttonImage = "icon-disclosure-next"
            return button
        }
    }
    
    //Base Feedcard Button with image
    static var baseFeedCardButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.backgroundColor = UIColor.BMS.clear
            button.tintColor = UIColor.BMS.white
            button.cornerRadius = 0
            button.shadowStyle = nil
            return button
        }
    }
    
    //Action Buttons
    
    static var planActionButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.tintColor = UIColor.BMS.white
            button.font = UIFont.BMS.InterBold.withSize(12)
            button.cornerRadius = 0
            button.shadowStyle = nil
            return button
        }
    }
    
    static var submitFeedbackButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseFeedCardButton
            button.buttonImage = "icon-submit-feedback"
            return button
        }
    }
    
    static var checkInButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseFeedCardButton
            button.buttonImage = "icon-calendar-next"
            button.backgroundColor = UIColor.BMS.green
            return button
        }
    }
    
    static var checkOutButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseFeedCardButton
            button.buttonImage = "icon-calendar-next"
            button.backgroundColor = UIColor.BMS.pink
            return button
        }
    }
    
    static var inOutActionButton: Styler.buttonBackgroundStyle {
        get {
            var button = ButtonStyles.baseButtonStyle
            button.font = UIFont.BMS.InterBold.withSize(16)
            button.cornerRadius = 27.5
            return button
        }
    }
    
    //More Option Button
    static let moreOptionButton = Styler.buttonImageStyle(normal: "icon-action-more",
                                                          highlighted: "icon-action-more",
                                                          selected: "icon-action-more",
                                                          disabled:"icon-action-more",
                                                          renderingMode: UIImage.RenderingMode.alwaysOriginal,
                                                          imageInsets: UIEdgeInsets(top: 18.5, left: 19, bottom: 18.5, right: 8))
    
    static let homeMenuButton = Styler.buttonImageStyle(normal: "sortted_circular_icon",
                                                          highlighted: "icon_close",
                                                          selected: "icon_close",
                                                          disabled:"sortted_circular_icon",
                                                          renderingMode: UIImage.RenderingMode.alwaysOriginal,
                                                          imageInsets: nil)
    
    static let createPlanButton = Styler.buttonImageStyle(normal: "plan",
                                                        highlighted: "plan",
                                                        selected: "plan",
                                                        disabled:"plan",
                                                        renderingMode: UIImage.RenderingMode.alwaysOriginal,
                                                        imageInsets: nil)
    
    
    
}

struct ShadowStyles {
    
    private static var baseShadowStyle: Styler.shadowStyle {
        get {
            return (cornerRadius: 0,
                    shadowRadius: 4,
                    opacity: 0.25,
                    color: UIColor.BMS.shadowBlack,
                    shadowOffset: CGSize(width: 0, height: 0),
                    frameOffset: CGSize.zero)
        }
    }
    
     static var clearShadow: Styler.shadowStyle {
        get {
            return (cornerRadius: 0,
                    shadowRadius: 0,
                    opacity: 0,
                    color: UIColor.BMS.clear,
                    shadowOffset: CGSize(width: 0, height: 0),
                    frameOffset: CGSize.zero)
        }
    }
    static var tabShadowStyle: Styler.shadowStyle {
        get {
            let shadowStyle = ShadowStyles.baseShadowStyle
            return shadowStyle
        }
    }
    
    static var NormalShadowStyle: Styler.shadowStyle {
        get {
            var shadowStyle = ShadowStyles.baseShadowStyle
            shadowStyle.cornerRadius = 1
            shadowStyle.shadowRadius = 1
            return shadowStyle
        }
    }
    
    static var CardShadowStyle: Styler.shadowStyle {
        get {
            var shadowStyle = ShadowStyles.baseShadowStyle
            shadowStyle.cornerRadius = 3
            shadowStyle.shadowRadius = 1
            return shadowStyle
        }
    }
    
    static var FormFieldShadowStyle: Styler.shadowStyle {
        get {
            var shadowStyle = ShadowStyles.baseShadowStyle
            shadowStyle.cornerRadius = 14
            shadowStyle.shadowRadius = 1
            return shadowStyle
        }
    }
    
    /// List item shadow
    /// Use it when you need to drop shadow for last cell in table view or any other listing
    static var lastListItemShadowStyle: Styler.shadowStyle {
        get {
            var shadowStyle = ShadowStyles.baseShadowStyle
            shadowStyle.cornerRadius = 1
            shadowStyle.shadowRadius = 1
            shadowStyle.shadowOffset = CGSize(width: 0, height: 2.5)
            shadowStyle.frameOffset = CGSize(width: 0, height: -2)
            return shadowStyle
        }
    }
    
    static var firstListItemShadowStyle: Styler.shadowStyle {
        get {
            var shadowStyle = ShadowStyles.baseShadowStyle
            shadowStyle.cornerRadius = 1
            shadowStyle.shadowRadius = 1
            shadowStyle.shadowOffset = CGSize(width: 2.5, height: 0)
            shadowStyle.frameOffset = CGSize(width: -2, height: 0)
            return shadowStyle
        }
    }
    
    static var buttonShadowStyle: Styler.shadowStyle {
        get {
            var shadowStyle = ShadowStyles.baseShadowStyle
            shadowStyle.shadowOffset = CGSize(width: 0, height: 3.0)
            return shadowStyle
        }
    }
    
    static let ClearShadowStyle: Styler.shadowStyle = (cornerRadius: 0,
                                                       shadowRadius: 0,
                                                       opacity: 0,
                                                       color: UIColor.BMS.clear,
                                                       shadowOffset: CGSize(width: 0, height: 0),
                                                       frameOffset: CGSize(width: 0, height: 0))
    
}

extension UIColor {
    
    struct BMS {
        
         static var sorttedGreen: UIColor { return UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1) }
        
        static var bmsLabelGrey: UIColor { return UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1) }
        
        //Brand Colours
        static var black: UIColor { return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1) }
        static var orange: UIColor { return UIColor(red: 255/255, green: 160/255, blue: 0/255, alpha: 1) }
        static var blue: UIColor { return UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1) }
        static var green: UIColor { return UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1) }
        static var pink: UIColor { return UIColor(red: 233/255, green: 30/255, blue: 99/255, alpha: 1) }
        static var red: UIColor { return UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1) }
        static var purple: UIColor { return UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1) }
        static var yellow: UIColor { return UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1) }
        
        //Other Colours
        static var clear: UIColor { return UIColor.clear }
        static var theme: UIColor {return UIColor(red: 90/255, green: 110/255, blue: 129/255, alpha: 1)}
        static var white: UIColor { return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1) }
        static var gray: UIColor { return UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1) }
        static var darkGray: UIColor { return UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1) }
        static var lightGray: UIColor { return UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1) }
        static var dashboardCard: UIColor { return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1) }
        static var textBorderGrey:UIColor { return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1) }
        static var paleGray: UIColor { return UIColor(red: 240/255, green: 240/255, blue: 244/255, alpha: 1) }
        static var backgroundGrey: UIColor { return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1) }
        static var palePink: UIColor { return UIColor(red: 255/255, green: 240/255, blue: 240/255, alpha: 1) }
        
        static var buttonGreen: UIColor { return UIColor(red: 127/255, green: 235/255, blue: 170/255, alpha: 1) }

        //Computed Font Colours
        static var fontBlack: UIColor { return UIColor.BMS.black }
        static var fontWhite: UIColor { return UIColor.BMS.white }
        static var fontGray: UIColor { return UIColor.BMS.gray }
        static var fontDarkGray: UIColor { return UIColor.BMS.darkGray }

        //Computed Other Colours
        static var linkBlue: UIColor { return UIColor.BMS.blue }
        static var imageBackgroundColor: UIColor { return UIColor.BMS.lightGray }
        static var imageBackgroundGreen: UIColor { return UIColor(red: 35/255, green: 193/255, blue: 122/255, alpha: 1)}
        static var separatorGray: UIColor { return UIColor.BMS.lightGray.withAlphaComponent(0.6) }
        static var toastBackgroundColor: UIColor { return UIColor.BMS.black.withAlphaComponent(0.9) }
        
        //Shadow Colours
        static var shadowBlack: UIColor { return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)}
        
        //User Status Colors
        static var statusBusy: UIColor { return UIColor.BMS.green }
        static var statusAvailable: UIColor { return UIColor.BMS.gray }
        
        //Label Font Colors
        static var titleFont: UIColor { return UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1) }
        static var tutorialTitleFont: UIColor { return UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1) }
        
        //Profile Colors
        static var activeStatus: UIColor { return UIColor(red: 121/255, green: 221/255, blue: 12/255, alpha: 1) }
        
        //Gradient Colors
        static var progressStart: UIColor { return UIColor(red: 255/255, green:  200/255, blue: 0/255, alpha: 1) }
        static var progressMiddle: UIColor { return UIColor(red: 255/255, green:  92/255, blue: 0/255, alpha: 1) }
        static var progressEnd: UIColor { return UIColor(red: 255/255, green:  0/255, blue: 0/255, alpha: 1) }
        
        static var gradientStartColor: UIColor { return UIColor(red: 137/255, green:  205/255, blue: 6/255, alpha: 1) }
        
        static var gradientEndColor: UIColor { return UIColor(red: 9/255, green:  182/255, blue: 15/255, alpha: 1) }
        
        
    }
    
}

extension UIFont {
    
    enum BMS : String{
        
        case MontserratLightItalic = "Montserrat-LightItalic",
        MontserratMedium = "Montserrat-Medium",
        MontserratBoldItalic = "Montserrat-BoldItalic",
        InterLight = "Inter-Light",
        MontserratThinItalic = "Montserrat-ThinItalic",
        InterExtraLight = "Inter-ExtraLight",
        MontserratThin = "Inter-Thin",
        InterBold = "Inter-Bold",
        MontserratMediumItalic = "Montserrat-MediumItalic",
        MontserratBlackItalic = "Montserrat-BlackItalic",
        InterSemiBold = "Inter-SemiBold",
        InterMedium = "Inter-Medium",
        MontserratExtraLightItalic = "Montserrat-ExtraLightItalic",
        InterExtraBold = "Montserrat-ExtraBold",
        MontserratBlack = "Montserrat-Black",
        InterRegular = "Inter-Regular",
        MontserratItalic = "Montserrat-Italic",
        MontserratSemiBoldItalic = "Montserrat-SemiBoldItalic",
        MontserratExtraBoldItalic = "Montserrat-ExtraBoldItalic"
        
        func withSize(_ size: CGFloat) -> UIFont {
            if let value = UIFont(name: self.rawValue, size: CGFloat.FontSize.get(size)) {
                return value
            } else {
                return UIFont.systemFont(ofSize: CGFloat.FontSize.get(size))
            }
        }
        
    }
    
}
