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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var selectedBridge:Inspection?
    var inspectionType: InspectionType?

    var inspectionList: [Inspection] = [] {
        didSet {
            updateFilteredInspections()
        }
    }
    var filteredInspectionList: [Inspection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        titleLabel.text = inspectionType == .review ? "Review Inspection List" : "Assigned Inspection List"
        self.navigationController?.navigationBar.backgroundColor = UIColor.BMS.theme
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

    func updateFilteredInspections() {
        searchBar(searchBar, textDidChange: searchBar.text ?? "")
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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension InspectionListViewController:UITableViewDelegate{
    
    
    
}


extension InspectionListViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let noRecordMessage = inspectionType == .inspect ? "No Inspections are assigned yet" : "No Review Inspections are assigned yet"
        filteredInspectionList.count == 0 ? tableView.setNoDataPlaceholder(noRecordMessage) : tableView.removeNoDataPlaceholder()

        return self.filteredInspectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InspectionListTableViewCell.identifier, for: indexPath) as? InspectionListTableViewCell else {
            fatalError("xib doesn't exist")
            
        }
        let data = filteredInspectionList[indexPath.row]
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

extension InspectionListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredInspectionList = []
        if searchText == "" {
            filteredInspectionList = inspectionList
            searchBar.resignFirstResponder()
            tableView.reloadData()
            return
        }
        
        filteredInspectionList = inspectionList.filter {
            let lowerCasedSearchString = searchText.lowercased()
            let contains =  $0.buid?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.inspectionName?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.bridgeName?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.startDateAsString?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.startDateAsString?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.inspectionStatusEnum?.text.lowercased().contains(lowerCasedSearchString) ?? false
            
            return contains
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
