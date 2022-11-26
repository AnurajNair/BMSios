//
//  SideMenuModel.swift
//  bms
//
//  Created by Naveed on 24/10/22.
//

import UIKit
import Foundation

struct SideMenuModel {
    var icon: String
    var title: String
    var menu: [Self]?
    var route: NavigationRoute.ScreenType
    var transition: Navigate.TransitionType
}
