//
//  BaseNavigationViewController.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit
import LGSideMenuController
import BBBadgeBarButtonItem

@objc protocol BaseNavigationViewControllerDelegate: AnyObject {
    @objc optional func closeClicked()
    @objc optional func skipClicked()
    @objc optional func navigationSetup()
    @objc optional func createClicked()
    @objc optional func checkinClicked()
    @objc optional func moreClicked()
    @objc optional func popMenuItemTapped(_ index: Int)
    @objc optional func profileClicked()
    @objc optional func menuClicked()
    @objc optional func addClicked()
    @objc optional func doneClicked()
    
}

class BaseNavigationViewController: UINavigationController, UINavigationControllerDelegate {
    
    typealias NavigationBarStyle = (barTintColor: UIColor, tintColor: UIColor, backgroundImage: UIImage?, shadowImage: UIImage?, titleTextColor: UIColor, titleFont: UIFont, searchBarTextColor: UIColor)
    
    
    struct NavigationStyles {
        
        private static var baseNavigationStyle: NavigationBarStyle = (barTintColor: UIColor.BMS.white,
                                                                      tintColor: UIColor.BMS.black,
                                                                      backgroundImage: nil,
                                                                      shadowImage: nil,
                                                                      titleTextColor: UIColor.BMS.fontBlack,
                                                                      titleFont: UIFont.BMS.InterBold.withSize(16),
                                                                      searchBarTextColor: UIColor.BMS.fontBlack)
        
        private static var baseTransparentNavigationStyle: NavigationBarStyle {
            get {
                var navStyle = NavigationStyles.baseNavigationStyle
                navStyle.barTintColor = UIColor.BMS.clear
                navStyle.backgroundImage = UIImage()
                navStyle.shadowImage = UIImage().imageWithColor(UIColor.BMS.clear)
                return navStyle
            }
        }
        
        static var whiteNavBlackTint: NavigationBarStyle {
            get {
                let navStyle = NavigationStyles.baseNavigationStyle
                return navStyle
            }
        }
        
        static var whiteNavBlackTintWithoutShadow: NavigationBarStyle {
            get {
                var navStyle = NavigationStyles.baseNavigationStyle
                navStyle.shadowImage = UIImage()
                return navStyle
            }
        }
        
        static var transparentNavBlackTint: NavigationBarStyle {
            get {
                var navStyle = NavigationStyles.baseTransparentNavigationStyle
                navStyle.tintColor = UIColor.BMS.black
                return navStyle
            }
        }
        
        static var transparentNavWhiteTint: NavigationBarStyle {
            get {
                var navStyle = NavigationStyles.baseTransparentNavigationStyle
                navStyle.tintColor = UIColor.BMS.white
                return navStyle
            }
        }
        
        static var basicThemeNav: NavigationBarStyle {
            get {
                var navStyle = NavigationStyles.baseNavigationStyle
                navStyle.barTintColor = UIColor.BMS.theme
//                navStyle.backgroundImage = UIImage()
                navStyle.shadowImage = UIImage().imageWithColor(UIColor.BMS.clear)
                return navStyle
            }
        }
        
    }
    
    enum NavigationStyle {
        case
        whiteNavBlackTint,
        whiteNavBlackTintWithoutShadow,
        transparentNavBlackTint,
        transparentNavWhiteTint,
        baseThemeTint
        
        func getNavigationStyleAttributes() -> NavigationBarStyle {
            
            switch self {
            case .whiteNavBlackTint:
                return NavigationStyles.whiteNavBlackTint
            case .whiteNavBlackTintWithoutShadow:
                return NavigationStyles.whiteNavBlackTintWithoutShadow
            case .transparentNavBlackTint:
                return NavigationStyles.transparentNavBlackTint
            case .transparentNavWhiteTint:
                return NavigationStyles.transparentNavWhiteTint
            case .baseThemeTint:
                return NavigationStyles.basicThemeNav
            }
            
            
        }
    }
    
    enum LeftBarButtons {
        case
        close,
        menu,
        none
    }
    
    enum TitleView {
        case
        title
    }
    
    enum RightBarButtons {
        case
        skip,
        create,
        more,
        checkin,
        profile,
        clientName,
        add,
        done,
        location
       
    }
    
    //MARK:- Parameters
    
    var screenType: NavigationRoute.ScreenType = .undecided
    var transitionType: Navigate.TransitionType = .undecided
    
    var leftBarButtonItem: LeftBarButtons = LeftBarButtons.none
    var titleView: TitleView = TitleView.title
    var rightBarButtonItems: [RightBarButtons] = []
    
    var routeHistory:[(screenType: NavigationRoute.ScreenType, transitionType: Navigate.TransitionType)] = [(.undecided, .undecided)]
    
    weak var navigationDelegate: BaseNavigationViewControllerDelegate?
    
    var isGoingForward: Bool = false
    
    var screenIndex: Int = 0
    
    var navigationStyle:BaseNavigationViewController.NavigationStyle?
    
    var popMenu: NavigationPopMenu? = nil
    
    //MARK:- Default Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return getStatusBarStyle()
        
    }
    
    //MARK:- Initialization Functions
    func setLeftButtons() {
        
        switch transitionType {
        case .rootSlider, .changeSlider:
            leftBarButtonItem = .menu
        case .modal, .popup:
            switch screenType {
            default:
                leftBarButtonItem = .close
            }
        default:
            switch screenType {
            case .homeScreen :
                leftBarButtonItem = .menu
            default:
                leftBarButtonItem = .none
            }
        }
        
    }
    
    func setRightButtons() {
        switch screenType {
        case .homeScreen,.inspectionListScreen,.inventoryListScreen,.routineInspbridgeDetailScreen, .createInventoryScreen, .selfInspectionScreen:
            rightBarButtonItems = [.skip,.clientName]
//        case .friendsScreen:
//            rightBarButtonItems = [.add]
        case .imageCropper:
            rightBarButtonItems = [.done]
        default:
            rightBarButtonItems = []
        }
    }
    
    func getNavigationStyle() -> BaseNavigationViewController.NavigationStyle {
        switch screenType {
            
        case .dashboardScreen,.inspectionListScreen,.routineInspbridgeDetailScreen, .inventoryListScreen, .createInventoryScreen, .selfInspectionScreen:
            return .baseThemeTint
        case .homeScreen:
            return .baseThemeTint
//                case .tutorials , .enterEmail , .setPassword , .verifyEmail , .enterPassword , .syncScreen , .pushNotificationPermission , .connectToSlack , .projectSetupTutorials , .resetPassword , .checkIfItsYou , .teamSetupTutorials:
//                        return .transparentNavBlackTint
//
//                    case .projectSetupAddUser , .projectSetupAddAdmin , .manageProjectsListing , .manageUsersList:
//                    return .whiteNavBlackTintWithoutShadow
        case .imageCropper:
            return .transparentNavWhiteTint
            
        default:
            return .transparentNavBlackTint
        }
    }
    
    func getNavigationTranslucency() -> Bool {
        switch screenType {
            //        case .projectDetails, .memberDetails, .teamDetails, .teamMemberDetails:
        //            return false
        default:
            return true
        }
    }
    
    func getViewControllerBackgroundColor() -> UIColor {
        
        switch screenType {
        case .loginScreen:
            return UIColor.white
//        case .placeDetailsScreen , .editProfileScreen , .friendCurrentPlanDetailsScreen ,.friendsScreen,.placesVisitedScreen,.planHistoryDetailsScreen ,.planPreviewScreen,.profileScreen,.userCurrentPlanDetailsScreen,.selectFriendsScreen:
//            if let background = UIImage(named: "snazzy_image") {
//                return UIColor(patternImage: background)
//            }
//            return UIColor.white
            
            
        default:
            if let background = UIImage(named: "background") {
                return UIColor(patternImage: background)
            }
            
            return UIColor.white
        }
        
    }
    
    func getStatusBarStyle() -> UIStatusBarStyle {
        let navigationStyle = getNavigationStyle()
        switch navigationStyle {
        default:
            return .default
        }
    }
    
    //MARK:- Setup Functions
    func setUpNavigation(_ viewController: UIViewController) {
        
        self.navigationBar.isTranslucent = getNavigationTranslucency()
        self.navigationBar.barStyle = getNavigationTranslucency() ? .default : .blackOpaque
        
       
        if screenType != .undecided || viewController is ReusablePopupViewController {
            
            let navigationStyle = getNavigationStyle()
            setNavigationBarStyle(navigationStyle)
            
        }
        
        if(screenType == .homeScreen || screenType == .inspectionListScreen  || screenType == .routineInspbridgeDetailScreen  || screenType == .inventoryListScreen || screenType == .createInventoryScreen || screenType == .selfInspectionScreen){
            self.navigationBar.frame.size.height = 58
            self.navigationBar.backgroundColor = UIColor.BMS.theme
        }else{
            self.navigationBar.backgroundColor = UIColor.BMS.clear
        }
       
        
        customizeSideMenu()
        
        if (screenType == .loginScreen || screenType == .tutorialScreen) {
            // && (transitionType == .root || transitionType == .rootSlider)
            self.navigationBar.isHidden = true
        }
            
        else {
            self.navigationBar.isHidden = false
        }
        
    }
    
    func setNavigationBarStyle(_ style: NavigationStyle, shouldSave: Bool = false) {
        
        let navigationStyle = style.getNavigationStyleAttributes()
        
        if shouldSave {
            self.navigationStyle = style
        }
        
        switch style {
        case .whiteNavBlackTint:
            self.navigationBar.barTintColor =  navigationStyle.barTintColor.getColorWithTranslucency(self.navigationBar.isTranslucent)
        default:
            self.navigationBar.barTintColor =  navigationStyle.barTintColor
        }
        
        self.navigationBar.tintColor = navigationStyle.tintColor
        self.navigationBar.setBackgroundImage(navigationStyle.backgroundImage, for: .default)
        self.navigationBar.shadowImage = navigationStyle.shadowImage
        
        let attributes = [ NSAttributedString.Key.foregroundColor : navigationStyle.titleTextColor, NSAttributedString.Key.font :  navigationStyle.titleFont]
        //self.navigationBar.titleTextAttributes = attributes
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue : navigationStyle.searchBarTextColor])
        
    }
    
    func setUpLeftBarButtons(_ viewController: UIViewController) {
        
        var leftButton = UIBarButtonItem()
        
        if leftBarButtonItem == LeftBarButtons.menu {
            leftButton = self.createUIBarButtonItem(image: "menu-white", action: #selector(menuClicked),raised : false)
//            leftButton = self.createUIBarButtonItem(title: "Menu", action: #selector(menuClicked))

        }
            
        else if leftBarButtonItem == LeftBarButtons.close {
            leftButton = self.createUIBarButtonItem(image: "Icon-Close", action: #selector(closeClicked))
        }
        
        if leftBarButtonItem == LeftBarButtons.menu || leftBarButtonItem == LeftBarButtons.close {
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -10
            viewController.navigationItem.leftBarButtonItems = [negativeSpacer, leftButton]
            leftBarButtonItem = .none
        }
        
    }
    
    func setUpRightBarButtons(_ viewController: UIViewController, removeButtons:Bool = false) {
        
        var rightButtons: [UIBarButtonItem] = []
        
        for item in rightBarButtonItems {
            
            if item == RightBarButtons.skip {
                let skipButton = self.createRightSideNameItem(title: "Cyberian Consulting Pvt. Ltd.")
                skipButton.isEnabled = false
     
                rightButtons.append(skipButton)
                
                break
            }
                
            else if item == RightBarButtons.create {
                let createButton = self.createUIBarButtonItem(title: "+ CREATE", action: #selector(createClicked))
                rightButtons.append(createButton)
                break
            }
                
            else if item == RightBarButtons.checkin {
                let checkinButton = self.createUIBarButtonItem(image: "icon-checkin", action: #selector(checkinClicked))
                rightButtons.append(checkinButton)
                break
            }
                
            else if item == RightBarButtons.more {
                let moreButton = self.createUIBarButtonItem(image: "navigation-bar-icon-more", action: #selector(moreClicked))
                rightButtons.append(moreButton)
                
                let popMenuWidth:CGFloat = Constants.screenBounds.width
                let popMenuHeight:CGFloat = Constants.screenBounds.height
                let popMenuOriginY:CGFloat = 0.0
                let popMenuOriginX:CGFloat = 0.0
                
                if popMenu == nil {
                    popMenu = NavigationPopMenu(frame: CGRect(x: popMenuOriginX, y: popMenuOriginY, width: popMenuWidth, height: popMenuHeight))
                    popMenu!.delegate = self
                    self.view.addSubview(popMenu!)
                    popMenu!.isHidden = true
                }
            }
                
            else if item == RightBarButtons.profile {
                let profileButton = self.createUIBarButtonItem(image: "account", action: #selector(profileClicked),raised : false)
                rightButtons.append(profileButton)
                break
            }
            else if item == RightBarButtons.add {
                let addButton = self.createUIBarButtonItem(image: "add_group", action: #selector(addClicked))
                rightButtons.append(addButton)
                break
            }else if item == RightBarButtons.done {
                let doneButton = self.createUIBarButtonItem(title: "Done", action: #selector(doneClicked))
                rightButtons.append(doneButton)
                break
            }
            else if item == RightBarButtons.location {
                let locationBtn = self.createUIBarButtonItemWithLabel(image: "account",action: #selector(doneClicked), withBadge: false, title: "Location")
                rightButtons.append(locationBtn)
                break
            }
            else if item == RightBarButtons.clientName {
                let clientTitle = self.createRightSideNameItem(title: "Cyberian Consulting Pvt. Ltd.")
                clientTitle.isEnabled = false
                rightButtons.append(clientTitle)
                break
            }
            
        }
        
        if rightButtons.count > 0 || removeButtons {
            viewController.navigationItem.rightBarButtonItems = removeButtons ? [] : rightButtons
            rightBarButtonItems = []
        }
        
    }
    
    //MARK:- Update Functions
    
    func updatePopMenuData(_ data:[String]) {
        if popMenu != nil {
            popMenu!.updateData(data)
        }
    }
    
    //MARK:- UINavigation Controller Delegate Methods
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationControllerCustom(navigationController, willShow: viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationControllerCustom(navigationController, didShow: viewController, animated: animated)
    }
    
    //MARK:- UINavigation Controller Delegate Helper Methods
    func navigationControllerCustom(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        setUpNavigation(viewController)
        
        //Set Back Button title as blank
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        if !hasGoneBackward() {
            setLeftButtons()
            setRightButtons()
            customizeButtonsForViewController(viewController)
            setUpLeftBarButtons(viewController)
            setUpRightBarButtons(viewController)
        }
        
        if isFirstRoute() {
            addRoute(viewController)
        }
            
        else if hasGoneForward() {
            addRoute(viewController)
            isGoingForward = true
        }
        
        if transitionType == .modal || transitionType == .popup {
            viewController.enableNavigationDelegate()
        }
        
        customizeViewControllerOnWillShow(viewController)
        
    }
    
    func navigationControllerCustom(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        if isGoingForward {
            self.setNeedsStatusBarAppearanceUpdate()
            isGoingForward = false
        }
        else if hasGoneBackward() {
            resetPreviousState()
            setUpNavigation(viewController)
            self.setNeedsStatusBarAppearanceUpdate()
            removeRoute(viewController)
        }
        
        viewController.enableNavigationDelegate()
        
        customizeViewControllerOnDidShow(viewController)
        
        self.navigationDelegate?.navigationSetup?()
        
    }
    
    func customizeButtonsForViewController(_ viewController: UIViewController) {
        
    }
    
    func customizeViewControllerOnWillShow(_ viewController: UIViewController) {
        viewController.view.backgroundColor = getViewControllerBackgroundColor()
        
        if let controller = viewController as? ReusableEmptyStateViewDelegate {
            controller.setupEmptyView(forScreenType: screenType)
        }
    }
    
    func customizeViewControllerOnDidShow(_ viewController: UIViewController) {
        viewController.view.backgroundColor = getViewControllerBackgroundColor()
    }
    
    func customizeSideMenu() {
        
        self.sideMenuController?.leftViewStatusBarStyle = .default
        
        if let value = self.sideMenuController?.rootViewController as? BaseNavigationViewController {
            self.sideMenuController?.rootViewStatusBarStyle = value.getStatusBarStyle()
        }
        
        self.sideMenuController?.isLeftViewSwipeGestureEnabled = transitionType == .rootSlider || transitionType == .changeSlider
        
    }
    
    //MARK:- Route History Functions
    
    func addRoute(_ viewController: UIViewController) {
        
        let actualVC = Navigate.getViewController(screenType: screenType)
        
        if actualVC.classForCoder == viewController.classForCoder {
            routeHistory.append((screenType: screenType, transitionType: transitionType))
            
            if routeHistory.count > 2 {
                transitionType = .undecided
            }
        }
        
    }
    
    func resetPreviousState() {
        if routeHistory.count > 2 {
            screenIndex = routeHistory.count - 2
            
            // If multiple screens need to be popped
            // (In this scenario, last screen in routeHistory and and the destination screen won't be same)
            if let lastScreenType = routeHistory.last?.screenType, screenType != lastScreenType {
                // Extracts the index of destination screen if present and assigns it to 'screenIndex'
                let index = routeHistory.index { (screenType, _) -> Bool in
                    return screenType == self.screenType
                }
                if let value = index {
                    screenIndex = value
                }
            }
            
            // Extract the details for destination screen at 'screenIndex' in 'routeHistory'
            let newScreen = routeHistory[screenIndex]
            screenType = newScreen.screenType
            transitionType = newScreen.transitionType
        }
    }
    
    func removeRoute(_ viewController: UIViewController) {
        
        let actualVC = Navigate.getViewController(screenType: screenType)
        
        if actualVC.classForCoder == viewController.classForCoder {
            
            let endIndex = routeHistory.endIndex - 1
            // Using removeSubrange instead of removeLast to handle case when multiple screens need to be popped at once
            routeHistory.removeSubrange(ClosedRange(uncheckedBounds: (lower: (screenIndex + 1), upper: endIndex)))
            transitionType = .undecided
            
        }
    }
    
    func isFirstRoute() -> Bool {
        return routeHistory.count == 1
    }
    
    func hasGoneForward() -> Bool {
        return transitionType == .push
    }
    
    func hasGoneBackward() -> Bool {
        return transitionType == .undecided && self.routeHistory.count > 2
    }
    
    
    //MARK:- Action Functions
    
    @objc func menuClicked() {
        //self.toggleLeftViewAnimated(nil)
        sideMenuController?.showLeftView()
        //self.navigationDelegate?.menuClicked?()
    }
    
    @objc func closeClicked() {
        self.navigationDelegate?.closeClicked?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func moreClicked() {
        if self.popMenu != nil {
            UIView.animate(withDuration: 0.5) {
                self.popMenu!.isHidden = !self.popMenu!.isHidden
            }
        }
        self.navigationDelegate?.moreClicked?()
    }
    
    @objc func profileClicked(){
        self.navigationDelegate?.profileClicked?()
    }
    
    @objc func skipClicked() {
        self.navigationDelegate?.skipClicked?()
    }
    
    @objc func createClicked() {
        self.navigationDelegate?.createClicked?()
    }
    
    @objc func checkinClicked() {
        self.navigationDelegate?.checkinClicked?()
    }
    
    @objc func addClicked(){
        self.navigationDelegate?.addClicked?()
    }
    
    @objc func doneClicked(){
        self.navigationDelegate?.doneClicked?()
    }
    
    
    
    //MARK:- Helper Functions
    func createUIBarButtonItem(image: String, action: Selector?, withBadge: Bool = false, imageRenderingMode: UIImage.RenderingMode = .alwaysOriginal , raised : Bool = false) -> UIBarButtonItem {
        
        let barButton: UIButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        barButton.setImage(UIImage(named: image)?.withRenderingMode(imageRenderingMode), for: .normal)
        barButton.addTarget(self, action: action!, for: .touchUpInside)
        
        
        if(raised){
            var btnStyle = ButtonStyles.barMenuButton
            
            btnStyle.buttonImage = image
            
            UIButton.style([(view: barButton, title: "", style: btnStyle)])
        }
        
        var barButtonItem = UIBarButtonItem(customView: barButton)
        
        if withBadge {
            if let badgeButtonItem = BBBadgeBarButtonItem(customUIButton: barButton) {
                badgeButtonItem.badgeFont = UIFont.BMS.InterBold.withSize(10)
                badgeButtonItem.badgeBGColor = UIColor.BMS.green
                badgeButtonItem.badgeValue = "1"
                badgeButtonItem.badgeMinSize = 10
                badgeButtonItem.badgeTextColor = UIColor.clear
                badgeButtonItem.shouldHideBadgeAtZero = true
                badgeButtonItem.shouldAnimateBadge = true
                badgeButtonItem.badgeOriginX += 7
                badgeButtonItem.badgeOriginY += 10
                badgeButtonItem.badgePadding = 0
                barButtonItem = badgeButtonItem
            }
        }
        
        return barButtonItem
    }
    
    func createUIBarButtonItemWithLabel(image: String, action: Selector?, withBadge: Bool = false, imageRenderingMode: UIImage.RenderingMode = .alwaysTemplate , raised : Bool = false,title :String) -> UIBarButtonItem {
        
        let barButton: UIButton = UIButton(type: .custom)
        barButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        barButton.setImage(UIImage(named: image)?.withRenderingMode(imageRenderingMode), for: .normal)
        barButton.setTitle(title, for: .normal)
        barButton.addTarget(self, action: action!, for: .touchUpInside)
//        let label :UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
//
//        label.font = UIFont(name: "Arial-BoldMT", size: 13)
//        label.text = title
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        label.backgroundColor = UIColor.clear
//
//        barButton.addSubview(label)
        
        if(raised){
            var btnStyle = ButtonStyles.barMenuButton
            
            btnStyle.buttonImage = image
            
            UIButton.style([(view: barButton, title: "", style: btnStyle)])
        }
        
        var barButtonItem = UIBarButtonItem(customView: barButton)
        
        if withBadge {
            if let badgeButtonItem = BBBadgeBarButtonItem(customUIButton: barButton) {
                badgeButtonItem.badgeFont = UIFont.BMS.InterBold.withSize(10)
                badgeButtonItem.badgeBGColor = UIColor.BMS.green
                badgeButtonItem.badgeValue = "1"
                badgeButtonItem.badgeMinSize = 10
                badgeButtonItem.badgeTextColor = UIColor.clear
                badgeButtonItem.shouldHideBadgeAtZero = true
                badgeButtonItem.shouldAnimateBadge = true
                badgeButtonItem.badgeOriginX += 7
                badgeButtonItem.badgeOriginY += 10
                badgeButtonItem.badgePadding = 0
                barButtonItem = badgeButtonItem
            }
        }
        
        return barButtonItem
    }
    
    
    func createUIBarButtonItem(title: String, action: Selector?) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.BMS.InterBold.withSize(12.0)], for: .normal)
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.BMS.InterBold.withSize(12.0)], for: .highlighted)
        return barButtonItem
    }
    
    func createRightSideNameItem(title: String) -> UIBarButtonItem {
        let barButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)

        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.BMS.InterBold.withSize(36.0),NSAttributedString.Key.foregroundColor: UIColor.BMS.white], for: .normal)
   
        
        barButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.BMS.white], for: .disabled)
        return barButtonItem
    }
    
    
    func setupSorttedNavigationTitleView(_ viewController: UIViewController , title : String = "") {
        
        guard let navigation = viewController.navigationController else{
            return
        }
        

        let navigationStyle = getNavigationStyle().getNavigationStyleAttributes()
        
       // let titleView = CustomNavigationTitleView(frame: navigation.navigationBar.bounds)
        
//        let baseView = ReusableTitleView()
//
//        if viewController.title?.isEmpty ?? false{
//            baseView.titleLabel.setText(to: title)
//            baseView.titleImageView.isHidden = !title.isEmpty
//        }else{
//            baseView.titleLabel.setText(to: viewController.title)
//            baseView.titleImageView.isHidden = true
//        }
//
//        let attributes = [ NSAttributedString.Key.foregroundColor : navigationStyle.titleTextColor, NSAttributedString.Key.font :  navigationStyle.titleFont]
//
//        let attributedTitle = NSAttributedString(string: title , attributes : attributes)
//
//        baseView.titleLabel.attributedText = attributedTitle
        
       // titleView.addSubview(baseView)
        
//        baseView.layoutAllConstraints(parentView: titleView, topConstant: 5, bottomConstant: -5, leadingConstant: 5, trailingConstant: -8)
        let navBarTitle = UILabel(frame: CGRect(x: 14.0, y: 0, width: 40, height: 40))
        navBarTitle.contentMode = .right
        navBarTitle.text = "Cyberian Consulting Pvt. Ltd."
//        navBarTitle.text
        navBarTitle.textColor = UIColor.BMS.white
        navBarTitle.textAlignment = .right
        viewController.navigationItem.titleView = navBarTitle
        viewController.navigationItem.titleView?.contentMode = .right
        
        
        
//        viewController.navigationItem.titleView = baseView
        //titleView.layoutIfNeeded()
        
    }

}

extension BaseNavigationViewController: NavigationPopMenuDelegate {
    func popMenuItemTapped(_ index: Int) {
        self.popMenu!.isHidden = true
        self.navigationDelegate?.popMenuItemTapped?(index)
    }
}

extension UIViewController {
    func enableNavigationDelegate() {
        if let navigation = self.navigationController as? BaseNavigationViewController {
            
            if let vc = self as? BaseNavigationViewControllerDelegate {
                navigation.navigationDelegate = vc
            }
                
            else {
                navigation.navigationDelegate = nil
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
