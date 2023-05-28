//
//  InspectionListViewController.swift
//  bms
//
//  Created by Naveed on 25/10/22.
//

import UIKit
import ObjectMapper

enum InspectionType {
    case inspect
    case review
}

class InspectionListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var unRegisterBtn: UIButton!
    
    var selectedBridge:Inspection?
    var inspectionType: InspectionType?

    var inspectionList: [Inspection] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        UIButton.style([(view: unRegisterBtn, title: "Unregister Inspection".localized(), style: ButtonStyles.greenButton)])
        filterBtn.layer.cornerRadius = 8
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.BMS.theme
        filterBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft

    }

    override func viewWillAppear(_ animated: Bool) {
        getInspection()
    }

    func getInspection() {
        Utils.showLoadingInView(self.view)
        getInspection(type: inspectionType) { response in
            if(response.status == 0){
                if(response.response != ""){
                    let responseJson = Utils.getJsonFromString(string:  Utils().decryptData(encryptdata: response.response!))
                    if let list = responseJson?["inspections"] as? [[String: Any]] {
                        self.inspectionList = []
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
        } failureHandler: { error in
            Utils.showLoadingInView(self.view)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }

    func getInspection(type: InspectionType?, successHandler: @escaping APISuccessHandler, failureHandler: @escaping APIFailureHandler) {
        switch type {
        case .inspect:
            InspctionRouterManager().getInspectorInspections(params: getInspectionReqParams(), successCompletionHandler: successHandler, errorCompletionHandler: failureHandler )
        case .review:
            InspctionRouterManager().getReviewerInspections(params: getInspectionReqParams(), successCompletionHandler: successHandler, errorCompletionHandler: failureHandler )

        case .none:
            break
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
        let data = inspectionList[indexPath.row]
        let buttonaProperties = getButtonPropertiesFor(status: data.inspectionStatusEnum)
        cell.configTableRow(srNo: indexPath.row+1, tableData: data, inspectionButtonTitle: buttonaProperties.title, inspectionButtonState: buttonaProperties.state)
        cell.delegate = self
        
        return cell
    }
    
    func getButtonPropertiesFor(status: InspectionStatus?) -> (title: String, state: UIButton.State) {
        guard let status = status else { return ("", .disabled) }
        //Assigned and draft status isn't valid for reviewer list.
        switch status {
        case .assigned:
            return ("Start Inspection", .normal)
        case .draft:
            return ("Resume", .normal)
        case .submitted:
            return inspectionType == .inspect ?  (status.text, .disabled)  : ("Start Review", .normal)
        case .reviewed:
            return (status.text, .disabled)
        }
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
            var data: [String: Any] = ["inspectionQues" : inspectionQues]
            if let inspectionType = inspectionType {
                data["inspectionType"] = inspectionType
            }
            Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .push,data: data)

        }
    }

    func getInspectionByIdParams(_ inspection: Inspection) -> APIRequestParams {
        let obj = InspectionByIdRequestModel()
        obj.inspectionId = inspection.id
        let params = APIUtils.createAPIRequestParams(dataObject: obj)
        return params
    }
}
