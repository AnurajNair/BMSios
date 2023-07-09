//
//  LeftMenuViewController.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit
import Localize_Swift

class LeftMenuViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userProfileView: UIView!
    
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutImage: UIImageView!
    @IBOutlet weak var logoutLabel: UILabel!
    
    let cellIdentifier = "LeftMenuItemTableViewCell"
    var logoutText = "Logout".localized()

    var data = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMenuData()
        setupTableView()
        
        //For Language Changes
//        NotificationCenter.default.addObserver(self, selector: #selector(updateText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Setup Functions
    
    func setupMenuData() {
        
        var title = ["Home", "Sample Form", "About TT"]
        var image = ["Icon-Home", "Icon-Home", "Icon-Home"]
        var description = ["routes to Sample View Controller", "routes to Sample Form View Controller", "routes to tailoredtech.in"]
        //var route:[NavigationRoute.ScreenType] = [.mainTabbar, .webView, .webView]
        var route:[NavigationRoute.ScreenType] = [.webView, .webView]
        var transition:[Navigate.TransitionType] = [.changeSlider, .changeSlider, .changeSlider]
        
        data.append(["name": "",
                     "title": title,
                     "image": image,
                     "description": description,
                     "route": route,
                     "transition": transition,
                     ]);
        
        title = ["Styleguide", "Empty State"]
        image = ["Icon-Home", "Icon-Home"]
        description = ["routes to styleguide", "routes to empty state"]
        route = [.webView, .webView]
        transition = [.changeSlider, .changeSlider]
        
        data.append(["name": "Other",
                     "title": title,
                     "image": image,
                     "description": description,
                     "route": route,
                     "transition": transition,
                    ]);
        
    }
    
    func setupTableView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 48
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
        registerCells()
        self.tableView.register(SideMenuCell.nib, forCellReuseIdentifier: SideMenuCell.identifier)
        self.tableView.reloadData()
    }
    
    func registerCells() {
      
    }
    
    //MARK:- Update Functions

    
    //MARK:- Navigation Functions

}

extension LeftMenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionData = data[section]
        
        if let rowData = sectionData["title"] as? [String] {
            return rowData.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionData = data[section]
        
        if let rowData = sectionData["name"] as? String, !rowData.isEmpty {
            return 35
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionData = data[section]
        
        if let sectionName = sectionData["name"] as? String, !sectionName.isEmpty {
        
            let headerView = UITableViewHeaderFooterView()
            headerView.contentView.backgroundColor = UIColor.clear
            headerView.backgroundView = UIView()
            headerView.backgroundView?.backgroundColor = UIColor.clear
            headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
            
            let separator = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
            separator.backgroundColor = UIColor.BMS.separatorGray
            headerView.addSubview(separator)
            
            let titleLabel = UILabel(frame: CGRect(x: 15, y: 15, width: self.view.frame.width, height: 15))
            titleLabel.font = UIFont.BMS.InterRegular.withSize(12.5)
            titleLabel.textColor = UIColor.BMS.blue
            titleLabel.text = sectionName
            headerView.addSubview(titleLabel)
            
            return headerView
        }
        
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.identifier, for: indexPath) as? SideMenuCell else {
            return UITableViewCell()
            
        }
        
        let sectionData = data[indexPath.section]
        
        var title = ""
        var description = ""
        var image = ""
        
        if let value = sectionData["title"] as? [String] {
            title = value[indexPath.row].localized()
        }
        
        if let value = sectionData["image"] as? [String] {
            image = value[indexPath.row]
        }
        
        if let value = sectionData["description"] as? [String] {
            description = value[indexPath.row]
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.BMS.green.withAlphaComponent(0.1)
        cell.selectedBackgroundView = backgroundView
        
       // cell.configureCell(image: image, name: title, description: description)
        
        return cell
    }
}

extension LeftMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sectionData = data[indexPath.section]
        
        var route: NavigationRoute.ScreenType = .webView
        var transition: Navigate.TransitionType = .changeSlider
        
        if let value = sectionData["route"] as? [NavigationRoute.ScreenType] {
            route = value[indexPath.row]
        }
        
        if let value = sectionData["transition"] as? [Navigate.TransitionType] {
            transition = value[indexPath.row]
        }
        
        Navigate.routeUserToScreen(screenType: route, transitionType: transition)
        
    }
}
