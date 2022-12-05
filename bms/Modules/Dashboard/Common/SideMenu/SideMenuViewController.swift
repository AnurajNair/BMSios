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
    
    var defaultHighlightedCell: Int = 0
    
    var isSubMenuHidden:Bool = true

    var selectedCellIndexPath: IndexPath?
    
    var data: [SideMenuModel] = [SideMenuModel(icon: "dashboardIcon", title: "Dashboard",menu: [], route: .homeScreen, transition: .rootSlider,isSelected: true),SideMenuModel(icon: "inspectionIcon", title: "Inspection",menu: [SideMenuModel(icon: "dashboardIcon" , title: "Inspection", route: .inspectionListScreen, transition: .changeSlider),SideMenuModel(icon: "dashboardIcon" , title: "Custom Inspection", route: .inspectionListScreen, transition: .changeSlider),SideMenuModel(icon: "dashboardIcon" , title: "Review Inspection", route: .inspectionListScreen, transition: .changeSlider)], route: .inspectionListScreen, transition: .changeSlider,isSelected:false),SideMenuModel(icon: "inspectionIcon", title: "Inventory",menu: [], route: .inventoryListScreen, transition: .changeSlider,isSelected: false)]
    
    var delegate: SideMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenuData()
        setupTableView()
        
        self.viewStack.bounds.size.width = UIScreen.main.bounds.size.width/4
     
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
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }

//        // Footer
//        self.footerLabel.textColor = UIColor.white
//        self.footerLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
//        self.footerLabel.text = "Developed by John Codeos"

        // Register TableView Cell
        self.sideMenuTableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        

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
}

// MARK: - UITableViewDelegate

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedCellIndexPath == indexPath {
               return 188
        }else{
            return 48
        }
           
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if(self.data[indexPath.row].title == "Inspection"){
            return 168
        }else{
            return 48
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionData = data[indexPath.row]
        setSelectedSideMenu(indexPath: indexPath)
      
        
      
        if(sectionData.title != "Inspection"){
            Navigate.routeUserToScreen(screenType: sectionData.route, transitionType: sectionData.transition)
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

}

extension SideMenuViewController:SideMenuCellDelegate{
    func onSideSubMenuClick(_ selectedItem: Int) {
        print("ok",selectedItem)
        
        
    }
    
   
}
