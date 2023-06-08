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

    let dashboard = SideMenuModel(icon: "dashboardIcon", title: "Dashboard",menu: [], route: .homeScreen, transition: .rootSlider,isSelected: true, type: .dashboard)
    let inventory = SideMenuModel(icon: "inspectionIcon", title: "Inventory Management",menu: [], route: .inventoryListScreen, transition: .changeSlider,isSelected: false, type: .inventory)
    var inspection = SideMenuModel(icon: "inspectionIcon", title: "Inspection Management",menu: [], route: .inspectionListScreen, transition: .changeSlider,isSelected:false, type: .inspection)
    var reviewInspection = SideMenuModel(icon: "dashboardIcon" , title: "Review Inspection", route: .inspectionListScreen, transition: .changeSlider, type: .reviewInspection)
    var performInspection = SideMenuModel(icon: "dashboardIcon" , title: "Perform Inspection", route: .inspectionListScreen, transition: .changeSlider, type: .performInspection)
    var selfInspection = SideMenuModel(icon: "dashboardIcon" , title: "Self Inspection", route: .selfInspectionScreen, transition: .changeSlider, type: .selfInspection)

    var isSubMenuHidden:Bool = true

    var selectedCellIndexPath: IndexPath?
    
    @IBOutlet weak var onLogOutClick: UIView!
    
    var data: [SideMenuModel] = []
    
    var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuData()
        setupTableView()
        
        self.viewStack.bounds.size.width = UIScreen.main.bounds.size.width/4
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLogoutClick))
        self.onLogOutClick.addGestureRecognizer(tap)
        data = getSideMenu()

        guard let user = SessionDetails.getInstance().currentUser else { return }
        self.userNameLabel.text = (user.profile?.firstName)! + " " + (user.profile?.lastName)!
    }
    
    func getSideMenu() -> [SideMenuModel] {
        guard let role = SessionDetails.getInstance().currentUser?.role else {
            return []
        }
        let components = role.getAllDistinctComponents()

        var menu: [SideMenuModel] = []
        
        components.forEach { component in
            guard component.statusAsEnum == .active else {
                return
            }
            let title = component.ComponentName
            
            switch component.type {
            case .home:
                menu.append(dashboard)
            case .createInventory:
                menu.append(inventory)
            case .performInspection:
                performInspection.title = title ?? performInspection.title
                inspection.menu?.append(performInspection)
            case .reviewInspection:
                reviewInspection.title = title ?? performInspection.title
                inspection.menu?.append(reviewInspection)
            case .selfInspection:
                inspection.menu?.append(selfInspection)
            case .none:
                break
            }
        }
        menu.append(inspection)
        return menu
    }
    func setupMenuData(){
   
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
        let change = self.data.map { e in
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
               return 188
        }else{
            return 70
        }
           
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.data[indexPath.row].title == "Inspection"){
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
        
    
        cell.configureCell(image:sectionData.icon, title: sectionData.title,menu: sectionData.menu,isSelected: sectionData.isSelected )
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
        
        guard let sectionData = inspection.menu?[selectedItem] else { return }
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
