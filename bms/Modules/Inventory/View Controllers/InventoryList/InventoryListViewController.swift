//
//  InventoryListViewController.swift
//  bms
//
//  Created by Naveed on 02/11/22.
//

import UIKit
import ObjectMapper

class InventoryListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    private var inventoryList: [InventoryListObj] = [] {
        didSet {
            updateFilteredInventoryList()
        }
    }

    private var filteredInventoryList: [InventoryListObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        getInventoryList()
    }

    func setupTableView() {
        self.tableView.bounces = false
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(InventoryListTableViewCell.identifier)
        self.tableView.registerHeaderNibs([InventoryListHeaderView.identifier])
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
    }

    func setupSearchBar() {
        searchBar.delegate = self
    }

    func getInventoryList() {
        Utils.showLoadingInView(self.view)
        InventoryRouterManager().getInventory(params: getParams()) { response in
            if(response.status == 0){
                if(response.response != ""){
                    if let inventoryList = Mapper<InventoryList>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.inventoryList = inventoryList.inventoryList.map { $0 } as [InventoryListObj]
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

    func getParams() -> [String : Any] {
        var params = [String : Any]()
        params[PostInventoryListModel.RequestKeys.requestdata.rawValue] = encrypInventoryReq()
        return params
    }

    func encrypInventoryReq() -> String {
        let obj = InventoryListRequestModel()
        obj.authId = SessionDetails.getInstance().currentUser?.profile?.authId
        
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        let encrypRequest = Utils().encryptData(json: jsonString! )
       return encrypRequest
    }

    func updateFilteredInventoryList() {
        searchBar(searchBar, textDidChange: searchBar.text ?? "")
    }

    @IBAction func createInventoryDidTap(_ sender: UIButton) {
        Navigate.routeUserToScreen(screenType: .createInventoryScreen, transitionType: .push)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension InventoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredInventoryList.count == 0 ? tableView.setNoDataPlaceholder("No Inventory Found") : tableView.removeNoDataPlaceholder()

        return filteredInventoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InventoryListTableViewCell.identifier) as? InventoryListTableViewCell else {
            return UITableViewCell()
        }
        let inventoryObj = filteredInventoryList[indexPath.row]
        cell.configure(srNo: indexPath.row+1, data: inventoryObj)
        cell.onTapEdit = { [weak self] in
            self?.performEditAction(on: inventoryObj)
        }
        cell.onTapRemove = { [weak self] in
            self?.removeInventory(inventoryObj, indexPath: indexPath)
        }
        cell.onStatusChange = { [weak self] isActive in
            self?.updateStatusOf(inventoryObj, status: isActive, indexPath: indexPath)
        }
        return cell
    }

    func performEditAction(on inventoryObj: InventoryListObj) {
        getInventoryData(inventoryObj: inventoryObj)
    }

    func updateStatusOf(_ inventoryObj: InventoryListObj, status: Bool, indexPath: IndexPath) {
        let statusKey = status ? Status.active.rawValue : Status.inActive.rawValue
        let obj = InventoryDataRequestModel()
        obj.mode = Mode.change.rawValue
        obj.id = inventoryObj.id
        obj.status = statusKey
        let param = APIUtils.createAPIRequestParams(dataObject: obj)
        updateInventoryBridge(params: param) { [weak self] success in
            if success {
                inventoryObj.status = statusKey
            }
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func removeInventory(_ inventoryObj: InventoryListObj, indexPath: IndexPath) {
        let obj = InventoryDataRequestModel()
        obj.mode = Mode.delete.rawValue
        obj.id = inventoryObj.id
        let param = APIUtils.createAPIRequestParams(dataObject: obj)
        updateInventoryBridge(params: param) { [weak self] status in
            guard let self = self else { return }
            self.filteredInventoryList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.inventoryList.removeAll {
                $0 == inventoryObj
            }
        }
    }

    func getInventoryData(inventoryObj: InventoryListObj) {
        Utils.showLoadingInView(self.view)
        InventoryRouterManager().getInventoryData(params: getInventoryDataParams(inventoryObj: inventoryObj)) { response in
            if(response.status == 0){
                if(response.response != ""){
                    if let inventory = Mapper<Inventory>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        Navigate.routeUserToScreen(screenType: .createInventoryScreen, transitionType: .push, data: ["inventory": inventory])
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

    func getInventoryDataParams(inventoryObj: InventoryListObj) -> [String : Any] {
        let obj = InventoryDataRequestModel()
        obj.authId = SessionDetails.getInstance().currentUser?.profile?.authId
        obj.mode = "S"
        obj.id = inventoryObj.id
        return APIUtils.createAPIRequestParams(dataObject: obj)
    }

    func updateInventoryBridge(params: APIRequestParams, completion: @escaping ((Bool)->())) {
        Utils.showLoadingInView(self.view)
        InventoryRouterManager().performInventoryCRUD(params: params) { response in
            if(response.status == 0){
                    completion(true)
                Utils.hideLoadingInView(self.view)
            } else {
                Utils.hideLoadingInView(self.view)
                completion(false)
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            Utils.showLoadingInView(self.view)
            completion(false)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }
}
extension InventoryListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: InventoryListHeaderView.identifier)
        return header
    }
}

extension InventoryListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredInventoryList = []
        if searchText == "" {
            filteredInventoryList = inventoryList
            searchBar.resignFirstResponder()
            tableView.reloadData()
            return
        }
        
        filteredInventoryList = inventoryList.filter {
            let lowerCasedSearchString = searchText.lowercased()
            let contains =  $0.projectName?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.projectId.description.lowercased().contains(lowerCasedSearchString) ||
            $0.buid?.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.saveStatusEnum?.text.lowercased().contains(lowerCasedSearchString) ?? false ||
            $0.bridgeId.description.lowercased().contains(lowerCasedSearchString) ||
            $0.bridgeName?.lowercased().contains(lowerCasedSearchString) ?? false
            
            return contains
        }
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
