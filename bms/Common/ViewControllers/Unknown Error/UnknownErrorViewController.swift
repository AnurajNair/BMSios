//
//  UnknownErrorViewController.swift
//  bms
//
//  Created by Naveed on 17/10/22.
//

import UIKit
import Alamofire

class UnknownErrorViewController: UIViewController, ReusableEmptyStateViewDelegate {
    lazy var emptyView: ReusableEmptyStateView = ReusableEmptyStateView()
    var manager: NetworkReachabilityManager? = nil
    var emptyStateData: EmptyStateViewStyler.EmptyViewData?
    
    //MARK: Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let networkManager = manager {
            networkManager.stopListening()
            manager = nil
        }
    }
    
    //MARK: Setup Functions
    func setupView() {
        
    }
    
    func firstButtonTapped() {
        if RestClient.isConnected {
            Navigate.routeUserBack(self) {}
        }
    }
    
    func getEmptyStateData(forScreenType screenType: NavigationRoute.ScreenType) -> EmptyStateViewStyler.EmptyViewData {
        var emptyData = EmptyStateViewStyler.getEmptyViewData(forScreenType: screenType)
        
        if let data = emptyStateData {
            emptyData = data
        }
        
        return emptyData
    }
}
