//
//  InspectionListViewController.swift
//  bms
//
//  Created by Naveed on 25/10/22.
//

import UIKit

class InspectionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var unRegisterBtn: UIButton!
    
    var selectedBridge:InspectionBridgeListModel?
    
    let tableList = [1,2,4,5,6]
    
    let inspectionData :[InspectionBridgeListModel] = [InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTableView()
        
        getInspection()
        
        UIButton.style([(view: unRegisterBtn, title: "Unregister Inspection".localized(), style: ButtonStyles.greenButton)])
//        UIView.style([(view: loginCard, style:(backgroundColor:nil, cornerRadius: 16, borderStyle: nil,shadowStyle : nil))])
        filterBtn.layer.cornerRadius = 8
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.SORT.theme
        filterBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

    }
    
    func getInspection(){
       
        let router = InspctionRouterManager()
        router.getInspections { response in
          
        } errorCompletionHandler: { error in
            print(error)
        }

    }
    
    
    func setupTableView(){
        self.tableView.bounces = false
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(InspectionListTableViewCell.nib, forCellReuseIdentifier: "InspectionListTableViewCell")
        self.tableView.registerHeaderNibs(["TableHeaderView"])
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.backgroundColor = .clear
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }

   
    @IBAction func onUnregisterBtnClick(_ sender: Any) {
        Navigate.routeUserToScreen(screenType: .popUpView, transitionType: .modal)

    }
    
}

extension InspectionListViewController:UITableViewDelegate{
    
    
    
}


extension InspectionListViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      

        return self.inspectionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InspectionListTableViewCell.identifier, for: indexPath) as? InspectionListTableViewCell else {
            fatalError("xib doesn't exist")
            
        }
        
        cell.configTableRow(tableData: self.inspectionData[indexPath.row])
        cell.delegate = self
        
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableHeaderView")  as! TableHeaderView

      
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    
}


extension InspectionListViewController: InspectionListTableViewCellDelegate{
    func onInspectbtnClick(selectedItem: InspectionBridgeListModel) {
      
        self.selectedBridge = selectedItem;
        Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .push,data: ["BridgeDetail" : self.selectedBridge as Any])
        
    }
    
    
}
