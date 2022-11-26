//
//  ServerDownViewController.swift
//  bms
//
//  Created by Naveed on 17/10/22.
//

import UIKit

class ServerDownViewController: UIViewController {
    
    var emptyView = ReusableEmptyStateView()
    
    //MARK: Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Setup Functions
    func setupView() {
        setupEmptyView()
        updateEmptyView()
    }
    
    func setupEmptyView() {
        self.view.addSubview(emptyView)
        emptyView.layoutAllConstraints(parentView: self.view)
    }
    
    func updateEmptyView() {
        emptyView.setupView()
        emptyView.updateData(EmptyStateViewStyler.serverDownData,ImageHeight: 250)
    }
}
