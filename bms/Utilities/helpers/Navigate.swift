//
//  Navigate.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import UIKit
import LGSideMenuController
import Localize_Swift
import MZAppearance
import MZFormSheetPresentationController

class Navigate {
    
    enum TransitionType {
        case push,
        modal,
        popup,
        root,
        rootSlider,
        changeSlider,
        undecided
    }
    
    class func parseWebViewUrl(_ url: URL, oldUrl: URL?, title: String, urlScheme: String = "ttstarter", authorisedURLCheck: String = "tailoredtech.in") -> Bool {
        
        if url.scheme == urlScheme {
            
            Navigate.parseUrl(url)
            return false
            
        } else {
            
            if  oldUrl != nil && oldUrl?.absoluteString != nil && oldUrl?.absoluteString != url.absoluteString && isAuthorisedUrl(url, urlToCheck: authorisedURLCheck) {
                let data = ["url" : "\(url.absoluteString)",
                    "title" : title]
                routeUserToScreen(screenType: .webView, transitionType: .push, data: data)
                return false
            } else if oldUrl != nil && oldUrl?.absoluteString != nil && oldUrl?.absoluteString == url.absoluteString {
                return false
            }
        }
        
        return true
    }
    
    class func parseUrl(_ url: URL, shouldReset:Bool = false) {
        
        let URLComponents = NSURLComponents(string: url.absoluteString)
        if let URLComponentsValue = URLComponents {
            var data: [String: String] = [:]
            if let queryItemsArrayValue = URLComponentsValue.queryItems {
                
                for queryItem in queryItemsArrayValue {
                    data[queryItem.name] = queryItem.value
                }
            }
        }
        
    }
    
    class func authorizedScreenType(_ screenType: NavigationRoute.ScreenType) -> NavigationRoute.ScreenType {
        
         //To be used if you want to force the login screen to appear
//        if !SessionDetails.isLoggedIn() {
//            return .login
//        }
        
        return screenType
    }
    
    class func authorizedTransitionType(_ transitionType: Navigate.TransitionType) -> Navigate.TransitionType {
        
        //To be used if you want to force the login screen to appear
//        if !SessionDetails.isLoggedIn() {
//            return .modal
//        }
        
        return transitionType
    }
    
    class func getViewController(screenType: NavigationRoute.ScreenType = .undecided, transitionType: Navigate.TransitionType = .undecided, data:[String:Any] = [:], screenTitle:String = "") -> UIViewController {
        
        var viewController:UIViewController = UIViewController()
       
        //Sets Destination View Controller
        let (destinationController, title) = screenType.viewControllerDetails(data, transitionType: transitionType)
        
        if screenTitle.isEmpty {
            destinationController.title = title
        } else {
            destinationController.title = screenTitle
        }
        
        viewController = destinationController
        
        return viewController
        
    }
    
    class func routeUserToScreen(screenType: NavigationRoute.ScreenType = .undecided, transitionType: Navigate.TransitionType = .undecided, data:[String:Any] = [:], screenTitle:String = "", contentSize: CGSize = CGSize.zero, addNavigationController:Bool = true, handleNotificationRouting: Bool = false, hideTabBarWhenPushed:Bool = true) {
        
        var viewController:UIViewController = UIViewController()
        viewController = Navigate.getViewController(screenType: screenType, transitionType: transitionType, data: data, screenTitle: screenTitle)
                
        transitionToScreen(destinationViewController: viewController, transitionType: transitionType, screenType: screenType, contentSize: contentSize, addNavigationController: addNavigationController, handleNotificationRouting: handleNotificationRouting, hideTabBarWhenPushed: hideTabBarWhenPushed)
    }
    
    class func transitionToScreen(destinationViewController: UIViewController, transitionType: Navigate.TransitionType = .undecided, screenType: NavigationRoute.ScreenType = .undecided, contentSize: CGSize = CGSize.zero, addNavigationController:Bool = true, handleNotificationRouting: Bool = false, hideTabBarWhenPushed:Bool = true) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        if transitionType == .root {
            
            var rootNavigationController = destinationViewController
            
            if addNavigationController {
                rootNavigationController = BaseNavigationViewController()
                
                if let value = rootNavigationController as? BaseNavigationViewController {
                    value.screenType = screenType
                    value.transitionType = transitionType
                    value.setViewControllers([destinationViewController], animated: false)
                }
                
            }
            
            delegate.window?.rootViewController = rootNavigationController
        }
            
        else if transitionType == .rootSlider || transitionType == .changeSlider {
            
            let rootNavigationController = BaseNavigationViewController()
            rootNavigationController.screenType = screenType
            rootNavigationController.transitionType = transitionType
            rootNavigationController.setViewControllers([destinationViewController], animated: false)
            
            if transitionType == .rootSlider {
                
                let sideMenuController = Navigate.getMenuViewController(viewController: rootNavigationController)
                delegate.window?.rootViewController = sideMenuController
                
                // Added these lines for handling navigation styling issue when coming from push notification tap
                if handleNotificationRouting {
                    rootNavigationController.navigationControllerCustom(rootNavigationController, willShow: destinationViewController, animated: true)
                    rootNavigationController.navigationControllerCustom(rootNavigationController, didShow: destinationViewController, animated: true)
                }
                
            }
                
            else if transitionType == .changeSlider {
                
                let topController = delegate.window?.topMostWindowController()
                if let topMostController = topController as? LGSideMenuController {
                    
                    if let value = topMostController.rootViewController as? BaseNavigationViewController {
                        if screenType == .inspectionListScreen || value.viewControllers[0].classForCoder != destinationViewController.classForCoder {
                            topMostController.rootViewController = rootNavigationController
                        }
                    }
                    else {
                        topMostController.rootViewController = rootNavigationController
                    }
                    
                    topMostController.hideLeftViewAnimated(sender: delegate)
                }
            }
            
        }
            
        else {
            
            let topController = delegate.window?.topMostWindowController()
            
            if transitionType == .modal || transitionType == .popup {
                
                var displayViewController: UIViewController = destinationViewController
                var modalNavigationController = UINavigationController()
                
                if addNavigationController {
                    
                    if let controller = destinationViewController as? UINavigationController {
                        modalNavigationController = controller
                    }
                        
                    else {
                        modalNavigationController = BaseNavigationViewController()
                        
                        if let controller = modalNavigationController as? BaseNavigationViewController {
                            controller.screenType = screenType
                            controller.transitionType = transitionType
                            controller.setViewControllers([destinationViewController], animated: false)
                        }
                    }
                    
                    displayViewController = modalNavigationController
                    
                }
                
                if transitionType == .popup {
                    
                    let formSheetController = MZFormSheetPresentationViewController(contentViewController: modalNavigationController)
                    
                    formSheetController.presentationController?.contentViewSize = contentSize == CGSize.zero ? Constants.popupBounds : contentSize
                    formSheetController.presentationController?.shouldCenterVertically = true
                    formSheetController.presentationController?.shouldCenterHorizontally = true
                    formSheetController.presentationController?.shouldDismissOnBackgroundViewTap = true
                    
                    displayViewController = formSheetController
                }
                
                if let value = topController {
                    value.present(displayViewController, animated: true, completion: {})
                }
            } else {
                
                var navigationController = BaseNavigationViewController()
                
                if let topMostController = topController as? BaseNavigationViewController {
                    navigationController = topMostController
                }
                    
                else if let topMostController = topController as? LGSideMenuController {
                    topMostController.hideLeftView()
                    
                    if let navigation = topMostController.rootViewController as? BaseNavigationViewController {
                        navigationController = navigation
                    }
                }
                
                else if let tabbarController = topController as? UITabBarController, let topMostController = tabbarController.selectedViewController as? BaseNavigationViewController {
                    navigationController = topMostController
                    destinationViewController.hidesBottomBarWhenPushed = hideTabBarWhenPushed
                }
                
                navigationController.screenType = screenType
                navigationController.transitionType = transitionType
                navigationController.pushViewController(destinationViewController, animated: true)
                
            }
            
        }
    }
    
    class func routeUserBack(_ viewController: UIViewController, destinationScreenType:NavigationRoute.ScreenType? = nil, toMain: Bool = false, animated: Bool = true,dataToPass : Any? = nil, completion: @escaping () -> Void) {
        
        //Routes user to a specific controller or the main screen prior to the modal or the back to the previous screen
        
        if let screenType = destinationScreenType, !viewController.isFirstScreenInModalView() {
            
            if let navigationController = viewController.navigationController as? BaseNavigationViewController {
                
                for controller in navigationController.viewControllers {
                    if controller.isKind(of: screenType.viewControllerDetails().viewController.classForCoder) {
                        
                        // Changing screenType here so that BaseNavigationViewController gets to know the destination screenType
                        // And accordingly BaseNavigationViewController will take styling decisions based on routeHistory.
                        if let passDataProtocolDelegate = controller as? PassDataProtocolDelegate{
                            passDataProtocolDelegate.getDataFromPassDataProtocol(data: dataToPass,fromViewController: viewController)
                        }
                        
                        navigationController.screenType = screenType
                        navigationController.popToViewController(controller, animated: animated)
                        
                        completion()
                        
                        break
                    }
                }
            }
            
        }
            
        else if toMain ? viewController.isModallyPresented() : viewController.isFirstScreenInModalView() {
            viewController.dismiss(animated: animated, completion: {
                completion()
            })
        }
        
        else {
            if let navigationController = viewController.navigationController as? BaseNavigationViewController, let screenType = destinationScreenType {
                // Changing screenType here so that BaseNavigationViewController gets to know the destination screenType
                // And accordingly BaseNavigationViewController will take styling decisions based on routeHistory.
                navigationController.screenType = screenType
            }
            viewController.navigationController?.popViewController(animated: animated)
            completion()
        }
        
    }
    
    //MARK:- Destination View Controllers

    static func getMenuViewController(viewController: UIViewController) -> LGSideMenuController {

        let menuViewController = NavigationRoute.getMenuViewController()

        let sideMenuController = LGSideMenuController(rootViewController: viewController, leftViewController: menuViewController, rightViewController: nil)

        sideMenuController.leftViewWidth = 320
        sideMenuController.leftViewAnimationDuration = 0.5

        return sideMenuController
    }

    //MARK:- Helper Functions
    
    class func isAuthorisedUrl(_ url: URL, urlToCheck: String) -> Bool {
        if (url.host?.range(of: urlToCheck) != nil) {
            return true
        }
        return false
    }
    
}

extension UIViewController {
    
    func isModallyPresented() -> Bool {
        
        if (self.presentingViewController != nil) {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        
        return false
        
    }
    
    func isFirstScreenInModalView() -> Bool {
        
        if self.navigationController?.viewControllers.count == 1 {
            return true
        }
        return false
    }
    
}

