//
//  AnalyticsHelper.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation


class AnalyticsHelper {
    
    enum AppStateType: String {
        case Launch = "AppLaunch"
    }
    
    enum ScreenType: String {
        case webview = "WebView"
    }
    
    enum ActionType: String {
        case home = ""
    }
    
    class func logEventWithName(eventName: Any, parameters: [String: Any] = [:]) {
        
        var event = ""
        
        if let name = eventName as? AppStateType {
            event = "App_\(name)"
        }
        
        else if let name = eventName as? ScreenType {
            event = "Page_\(name)"
            
        }
        
        else if let name = eventName as? ActionType {
            event = "Click_\(name)"
        }
        
        else if let name = eventName as? String {
            event = name
        }
        
//        if event != "" {
//            sendEventsToProviders(eventName: event, parameters: parameters)
//        }
    }
    
//    private class func sendEventsToProviders(eventName: String, parameters: [String: Any]?) {
//        Analytics.logEvent(eventName, parameters: parameters)
//        //Answers.logCustomEvent(withName: eventName,
//                         //      customAttributes: parameters)
//        //Branch.getInstance().userCompletedAction(eventName)
//    }
//
}
