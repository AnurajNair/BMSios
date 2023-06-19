//
//  SideMenuViewController.swift
//  bms
//
//  Created by Naveed on 24/10/22.
//

import UIKit

protocol SideMenuCellDelegate  {
    func onSideSubMenuClick(_ selectedItem:Int)

}

protocol SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuViewController: UIViewController {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView!
    @IBOutlet var footerLabel: UILabel!
    @IBOutlet weak var viewStack: UIStackView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    var defaultHighlightedCell: Int = 0

    let dashboard = SideMenuModel(icon:UIImage(named: "dashboardIcon"), title: "Dashboard",menu: [], route: .homeScreen, transition: .rootSlider,isSelected: true, type: .dashboard, index: 0)
    let inventory = SideMenuModel(icon: UIImage(systemName: "cylinder.split.1x2"), title: "Inventory Management",menu: [], route: .inventoryListScreen, transition: .changeSlider,isSelected: false, type: .inventory, index: 1)
    var inspection = SideMenuModel(icon: UIImage(systemName:"display"), title: "Inspection Management",menu: [], route: .inspectionListScreen, transition: .changeSlider,isSelected:false, type: .inspection, index: 2)
    var reviewInspection = SideMenuModel(title: "Review Inspection", route: .inspectionListScreen, transition: .changeSlider, type: .reviewInspection, index: 2)
    var performInspection = SideMenuModel(title: "Perform Inspection", route: .inspectionListScreen, transition: .changeSlider, type: .performInspection, index: 0)
    var selfInspection = SideMenuModel(title: "Self Inspection", route: .selfInspectionScreen, transition: .changeSlider, type: .selfInspection, index: 1)

    var isSubMenuHidden:Bool = true

    var selectedCellIndexPath: IndexPath?
    
    @IBOutlet weak var onLogOutClick: UIView!
    @IBOutlet weak var onProfileClick: UIView!

    var data: [SideMenuModel] = []
    
    var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuData()
        setupTableView()
        
        self.viewStack.bounds.size.width = UIScreen.main.bounds.size.width/4
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLogoutClick))
        self.onLogOutClick.addGestureRecognizer(tap)

        let profiletap = UITapGestureRecognizer(target: self, action: #selector(onProfileClickAction))
        self.onProfileClick.addGestureRecognizer(profiletap)

        data = getSideMenu()

        guard let user = SessionDetails.getInstance().currentUser else { return }
        self.userNameLabel.text = (user.profile?.firstName)! + " " + (user.profile?.lastName)!
    }
    
    func getSideMenu() -> [SideMenuModel] {
        guard let role = SessionDetails.getInstance().currentUser?.role else {
            return []
        }
        let components = role.distinctComponents

        var menu: [SideMenuModel] = []
        var inspectionSubMenu: [SideMenuModel] = []
        components.forEach { component in
            let title = component.ComponentName
            
            switch component.type {
            case .home:
                menu.append(dashboard)
            case .createInventory:
                menu.append(inventory)
            case .performInspection:
                performInspection.title = title ?? performInspection.title
                inspectionSubMenu.append(performInspection)
            case .reviewInspection:
                reviewInspection.title = title ?? performInspection.title
                inspectionSubMenu.append(reviewInspection)
            case .selfInspection:
                inspectionSubMenu.append(selfInspection)
            case .none:
                break
            }
        }
        inspectionSubMenu.sort {
            $0.index < $1.index
        }
        inspection.menu = inspectionSubMenu
        menu.append(inspection)
        menu.sort {
            $0.index < $1.index
        }
        return menu
    }
    func setupMenuData(){
   
    }
    
    @objc func onProfileClickAction() {
        Navigate.routeUserToScreen(screenType: .profile, transitionType: .changeSlider)
    }
    func setupTableView(){
        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.sideMenuTableView.separatorStyle = .none
        

        // Set Highlighted Cell
//        DispatchQueue.main.async {
//            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
//            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
//        }

//        // Footer
//        self.footerLabel.textColor = UIColor.white
//        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        self.footerLabel.text = "Developed by John Codeos"

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
       // self.sideMenuTableView.registerHeaderNibs(["SideMenuFooter"])

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
    }
    func setSelectedSideMenu(indexPath:IndexPath){
        let sectionData = data[indexPath.row]
        
        let change = self.data.map { e -> SideMenuModel in
            var c = e
            if(c.title == sectionData.title){
                c.isSelected = true
               
            }else{
                c.isSelected = false
            }
            
            return c
        }
       
        self.data = change
        print("changed Data",data)
        self.sideMenuTableView.reloadData()
    }
    //UserProfileViewController
    @objc func onLogoutClick(){
      print("click")
        _ = Utils.displayAlertController("Alert", message: "Are you sure to logout?",isSingleBtn: false,cancelButtonTitle: "No",submitButtonTitle: "Yes") {
            SessionDetails.clearInstance()
            Navigate.routeUserToScreen(screenType: .loginScreen, transitionType: .root)
        } cancelclickHandler: {
            
        }

    }
    
    
    
}

// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
               return 200
        }else{
            return 70
        }
           
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.data[indexPath.row] == inspection){
            return 168
        }else{
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // tableView.deselectRow(at: indexPath, animated: false)
        
        
        let sectionData = data[indexPath.row]
        setSelectedSideMenu(indexPath: indexPath)
      
        
        let type = sectionData.type
        if(type != .inspection){
            var data: [String: Any] = [:]
            if type == .performInspection {
                data["component"] = ComponentType.performInspection
            } else if type == .reviewInspection {
                data["component"] = ComponentType.reviewInspection
            }
            Navigate.routeUserToScreen(screenType: sectionData.route, transitionType: sectionData.transition, data: data)
        }else{
            self.selectedCellIndexPath = indexPath
        }
        
        
        tableView.beginUpdates()
        tableView.endUpdates()
      
       
    }
    
    
    
    
    
   
  }


// MARK: - UITableViewDataSource

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        
        let sectionData = self.data[indexPath.row]
        cell.configureCell(image: sectionData.icon, title: sectionData.title,menu: sectionData.menu,isSelected: sectionData.isSelected )
        cell.delegate = self
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = self.sideMenuTableView.dequeueReusableHeaderFooterView(withIdentifier: "SideMenuFooter")  as! SideMenuFooter
//
//
//        return footerView
//    }

}

extension SideMenuViewController:SideMenuCellDelegate{
    func onSideSubMenuClick(_ selectedItem: Int) {
        print("ok",selectedItem)
        
        let sectionData = inspection.menu[selectedItem] 
//        setSelectedSideMenu(indexPath: indexPath)
      
        
        let type = sectionData.type
        var data: [String: Any] = [:]
        if(type == .performInspection || type == .reviewInspection){
            if type == .performInspection {
                data["component"] = ComponentType.performInspection
            } else if type == .reviewInspection {
                data["component"] = ComponentType.reviewInspection
            }
        }
        Navigate.routeUserToScreen(screenType: sectionData.route, transitionType: sectionData.transition, data: data)
    }
    
   
}
