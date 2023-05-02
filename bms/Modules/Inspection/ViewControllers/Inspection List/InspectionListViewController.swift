//
//  InspectionListViewController.swift
//  bms
//
//  Created by Naveed on 25/10/22.
//

import UIKit
import ObjectMapper

class InspectionListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var unRegisterBtn: UIButton!
    
    var selectedBridge:Inspection?
    
    let tableList = [1,2,4,5,6]
    
    let inspectionData :[InspectionBridgeListModel] = [InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),InspectionBridgeListModel(id: "#24351", project_name: "Project Name 1", project_code: "23324NM23456", location: "Location "),]

    var inspectionList: [Inspection] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTableView()
        
        getInspection()
        
        UIButton.style([(view: unRegisterBtn, title: "Unregister Inspection".localized(), style: ButtonStyles.greenButton)])
//        UIView.style([(view: loginCard, style:(backgroundColor:nil, cornerRadius: 16, borderStyle: nil,shadowStyle : nil))])
        filterBtn.layer.cornerRadius = 8
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.BMS.theme
        filterBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

    }
    
    func getInspection() {
        Utils.showLoadingInView(self.view)
        InspctionRouterManager().getInspections(params: getInspectionReqParams()) { response in
            if(response.status == 0){
                if(response.response != ""){
                    let responseJson = Utils.getJsonFromString(string:  Utils().decryptData(encryptdata: response.response!))
                    if let list = responseJson?["inspections"] as? [[String: Any]] {
                        list.forEach { item in
                            print(item)
                            if let inspection =  Mapper<Inspection>().map(JSON: item ) {
                                self.inspectionList.append(inspection)
                            }
                        }
                        self.tableView.reloadData()
                    }
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
                Utils.hideLoadingInView(self.view)
            } else {
                Utils.hideLoadingInView(self.view)
                
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            Utils.showLoadingInView(self.view)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }

    func getInspectionReqParams() -> APIRequestParams {
        let obj = InspectionListRequestModel()
        let params = APIUtils.createAPIRequestParams(dataObject: obj)
        return params
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
        return self.inspectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InspectionListTableViewCell.identifier, for: indexPath) as? InspectionListTableViewCell else {
            fatalError("xib doesn't exist")
            
        }
        
        cell.configTableRow(srNo: indexPath.row+1, tableData: self.inspectionList[indexPath.row])
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
    func onInspectbtnClick(selectedItem: Inspection) {
        self.selectedBridge = selectedItem
        prepareForInspection(selectedItem)
    }

    func prepareForInspection(_ inspection: Inspection) {
        InspctionRouterManager().getInspectionById(params: getInspectionByIdParams(inspection)) { response in
            Utils.hideLoadingInView(self.view)
            self.handleInspectionByIdSuccess(response: response)
        } errorCompletionHandler: { error in
            Utils.showLoadingInView(self.view)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }

    func handleInspectionByIdSuccess(response: APIResponseModel) {
        guard response.status == 0, response.response != "" else {
            Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            return
        }
        if let inspectionQues =  Mapper<InspectionQuestionnaire>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
        Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .push,data: ["BridgeDetail" : inspectionQues])

        }
        let responseJson = Utils.getJsonFromString(string:  Utils().decryptData(encryptdata: response.response!))
    }

    func getInspectionByIdParams(_ inspection: Inspection) -> APIRequestParams {
        let obj = InspectionByIdRequestModel()
        obj.inspectionId = inspection.id
        let params = APIUtils.createAPIRequestParams(dataObject: obj)
        return params
    }
}
