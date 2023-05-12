//
//  SideMenuModel.swift
//  bms
//
//  Created by Naveed on 24/10/22.
//

import UIKit
import Foundation

struct SideMenuModel {
    enum SideMenuType {
        case dashboard
        case inventory
        case inspection
        case performInspection
        case reviewInspection
        case selfInspection
    }
    var icon: String
    var title: String
    var menu: [Self]?
    var route: NavigationRoute.ScreenType
    var transition: Navigate.TransitionType
    var isSelected:Bool?
    var type: SideMenuType
}
