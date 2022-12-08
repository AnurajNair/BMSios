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
    
    private let sectionInsets = UIEdgeInsets(
      top: 20.0,
      left: 20.0,
      bottom: 20.0,
      right: 20.0)
    
    var statsList:[StatsModel] = [StatsModel(label: "Total Inspections", statsCount: 24),StatsModel(label: "Routine Inspection", statsCount: 20),StatsModel(label: "Thurough Inspection", statsCount: 10),StatsModel(label: "Special Inspection", statsCount: 10),StatsModel(label: "Completed Inspection", statsCount: 10),]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//setupNavigationTitleView()
        
        setupCollectionView()
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
