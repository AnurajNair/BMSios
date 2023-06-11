//
//  ExViewController.swift
//  bms
//
//  Created by Naveed on 24/10/22.
//

import UIKit
import ObjectMapper

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var statsCollectionView: UICollectionView!
    var inspectionStats: [(role: UserRole, data: InspectionStatsModel)] = []
    let itemsPerRow: CGFloat = 4
    
    @IBOutlet weak var activityTable: UITableView!
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    
    lazy var userRoles = SessionDetails.getInstance().currentUser?.role?.rolesAsEnum ?? []

    var activityList :[ActivityModel] = [ActivityModel(id: "A231", author: "Anuraj Nair", activity: "Routine Inspection", date: "05/12/2022", time: "12:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Zahid Shaikh", activity: "Thurough Inspection", date: "08/12/2022", time: "11:00 AM", status: "Pending"),ActivityModel(id: "A231", author: "Adiba Tirandaz", activity: "Routine Inspection", date: "0/12/2022", time: "12:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Naveed Lambe", activity: "Routine Inspection", date: "01/12/2022", time: "01:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Anuraj Nair", activity: "Routine Inspection", date: "0/12/2022", time: "12:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Anuraj Nair", activity: "Routine Inspection", date: "0/12/2022", time: "12:05 PM", status: "Pending")]
    
    var statsList:[StatsModel] = [StatsModel(label: "Total Inspections", statsCount: 24),StatsModel(label: "Routine Inspection", statsCount: 20),StatsModel(label: "Thurough Inspection", statsCount: 10),]
    
    var routineInspectionCount = 0
    var thuroughInspectionCount = 0
    var countArray : [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//setupNavigationTitleView()
        
        setupCollectionView()
        setupTableView()
        getInspectionStats()
        DataStore.shared.fetchAllPropertiesMaster()
    }
    

    func setupNavigationTitleView(){
        if let navigationController = self.navigationController as? BaseNavigationViewController {
            navigationController.setupSorttedNavigationTitleView(self)
//            navigationController.setUpNavigation(self)
            navigationController.navigationBar.backgroundColor = UIColor.BMS.theme
        }
        
        
    }
    
    func setupCollectionView(){
        self.statsCollectionView.delegate = self
        self.statsCollectionView.dataSource = self
        self.statsCollectionView.registerNibs(["DashboardStatsCollectionViewCell"])
        self.statsCollectionView.layoutIfNeeded()
      
    }
    
    func setupTableView(){
        UIView.style([(view: self.activityTable, style:(backgroundColor:nil, cornerRadius: 10, borderStyle: nil,shadowStyle : nil))])

        self.activityTable.bounces = false
        self.activityTable.separatorStyle = .none
        self.activityTable.delegate = self
        self.activityTable.dataSource = self
      
        self.activityTable.register(ActivityTableViewCell.nib, forCellReuseIdentifier: "ActivityTableViewCell")
        self.activityTable.registerHeaderNibs(["ActivityTableHeader"])
        self.activityTable.rowHeight = UITableView.automaticDimension
        self.activityTable.estimatedRowHeight = 100
        self.activityTable.backgroundColor = .clear
        
    }

}


extension DashboardViewController:UICollectionViewDelegate{
    

  
}

extension DashboardViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(
       _ collectionView: UICollectionView,
       layout collectionViewLayout: UICollectionViewLayout,
       sizeForItemAt indexPath: IndexPath
     ) -> CGSize {
       // 2
         let paddingSpace = (sectionInsets.left+sectionInsets.right) * (itemsPerRow + 1)
             let availableWidth = view.frame.width - paddingSpace
             let widthPerItem = availableWidth / itemsPerRow
             
         return CGSize(width: widthPerItem, height: widthPerItem / 1.8)
     }
    
    
//    // 3
    func collectionView(
      _ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      insetForSectionAt section: Int
    ) -> UIEdgeInsets {
      return sectionInsets
    }
//
//    // 4
//    func collectionView(
//      _ collectionView: UICollectionView,
//      layout collectionViewLayout: UICollectionViewLayout,
//      minimumLineSpacingForSectionAt section: Int
//    ) -> CGFloat {
//      return sectionInsets.left
//    }
}

extension DashboardViewController:UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        inspectionStats.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardStatsCollectionViewCell", for: indexPath) as? DashboardStatsCollectionViewCell else{
            return UICollectionViewCell()
        }
        let sectionData = inspectionStats[indexPath.section].data
        var labelName = ""
        var count = 0
        switch indexPath.row {
        case 0:
            labelName = "Completed Inspection"
            count = sectionData.completed
            
        case 1:
            labelName = "Pending Inspection"
            count = sectionData.pendingForInspection
            
        case 2:
            labelName = "Pending Review"
            count = sectionData.pendingForReview
            
        case 3:
            labelName = "Total Inspection"
            count = sectionData.total
            
        default:
            labelName = "NA"
            count = 0
        }
        cell.configCell(count: count, statName: labelName)
        return cell
    }
        
}


extension DashboardViewController:UITableViewDelegate{
    
}

extension DashboardViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier, for: indexPath) as? ActivityTableViewCell else {
            fatalError("xib doesn't exist")
            
        }
        
        let inspection = self.activityList[indexPath.row]
        
        cell.configCell(activity: inspection)
 
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.activityTable.dequeueReusableHeaderFooterView(withIdentifier: "ActivityTableHeader")  as! ActivityTableHeader

      
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
}

extension DashboardViewController{
    
    
    func getInspectionStats(){
//        Utils.showLoadingInView(self.view)
        let router = DashboardRouterManager()
        
        router.getInspectionStats(params: APIUtils.createAPIRequestParams(dataObject: DashboardDataRequestModel())) { [self] response in
            if(response.status == 0){
                Utils.hideLoadingInView(self.view)
                if(response.response != ""){
                    guard let dashboardData = Mapper<DashboardData>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) else {
                        print("Could not get dashboard data")
                        return
                    }
                    print(dashboardData.toJSON())
                    generateDashboardDataArray(dashboardData)
                    self.statsCollectionView.reloadData()
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
            }else{
                Utils.hideLoadingInView(self.view)
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            print(error as Any)
            Utils.hideLoadingInView(self.view)
        }

        func generateDashboardDataArray(_ data: DashboardData) {
            if userRoles.filter({ $0 == .inspector || $0 == .admin}).count > 0, let data = data.inspectionData {
                inspectionStats.append((.inspector,data))
            }
            if userRoles.filter({ $0 == .reviewer || $0 == .admin}).count > 0, let data = data.reviewData {
                inspectionStats.append((.reviewer,data))
            }
        }

    }
}
