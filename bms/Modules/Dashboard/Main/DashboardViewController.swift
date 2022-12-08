//
//  ExViewController.swift
//  bms
//
//  Created by Naveed on 24/10/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    
    @IBOutlet weak var statsCollectionView: UICollectionView!
    
    let itemsPerRow: CGFloat = 3
    
    @IBOutlet weak var activityTable: UITableView!
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    
    var activityList :[ActivityModel] = [ActivityModel(id: "A231", author: "Anuraj Nair", activity: "Routine Inspection", date: "05/12/2022", time: "12:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Zahid Shaikh", activity: "Thurough Inspection", date: "08/12/2022", time: "11:00 AM", status: "Pending"),ActivityModel(id: "A231", author: "Adiba Tirandaz", activity: "Routine Inspection", date: "0/12/2022", time: "12:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Naveed Lambe", activity: "Routine Inspection", date: "01/12/2022", time: "01:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Anuraj Nair", activity: "Routine Inspection", date: "0/12/2022", time: "12:05 PM", status: "Pending"),ActivityModel(id: "A231", author: "Anuraj Nair", activity: "Routine Inspection", date: "0/12/2022", time: "12:05 PM", status: "Pending")]
    
    var statsList:[StatsModel] = [StatsModel(label: "Total Inspections", statsCount: 24),StatsModel(label: "Routine Inspection", statsCount: 20),StatsModel(label: "Thurough Inspection", statsCount: 10),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//setupNavigationTitleView()
        
        setupCollectionView()
        setupTableView()
        // Do any additional setup after loading the view.
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
         let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
             let availableWidth = view.frame.width - paddingSpace
             let widthPerItem = availableWidth / itemsPerRow
             
         return CGSize(width: widthPerItem, height: widthPerItem / 1.8)
     }
    
    
//    // 3
//    func collectionView(
//      _ collectionView: UICollectionView,
//      layout collectionViewLayout: UICollectionViewLayout,
//      insetForSectionAt section: Int
//    ) -> UIEdgeInsets {
//      return sectionInsets
//    }
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.statsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardStatsCollectionViewCell", for: indexPath) as? DashboardStatsCollectionViewCell else{
            return UICollectionViewCell()
        }
        let section = self.statsList[indexPath.row]
        
        cell.configCell(count: section.statsCount, statName: section.label)
        
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
        
        cell.configCell(activity:  self.activityList[indexPath.row])
 
        
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
