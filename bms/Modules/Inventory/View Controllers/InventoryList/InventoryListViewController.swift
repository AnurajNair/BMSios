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
    
    private var inventoryList: [InventoryListObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func getInventoryList() {
        Utils.showLoadingInView(self.view)
        InventoryRouterManager().getInventory(params: getParams()) { response in
            if(response.status == 0){
                if(response.response != ""){
                    if let inventoryList = Mapper<InventoryList>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.inventoryList = inventoryList.inventoryList.map { $0 } as [InventoryListObj]
                        self.setupTableView()
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

    @IBAction func createInventoryDidTap(_ sender: UIButton) {
        Navigate.routeUserToScreen(screenType: .createInventoryScreen, transitionType: .push)
    }
}

extension InventoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inventoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InventoryListTableViewCell.identifier) as? InventoryListTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(srNo: indexPath.row+1, data: inventoryList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: InventoryListHeaderView.identifier)
        return header
    }
}

extension InventoryListViewController: UITableViewDelegate {
    
}
