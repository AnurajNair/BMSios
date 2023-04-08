//
//  InventoryListViewController.swift
//  bms
//
//  Created by Naveed on 02/11/22.
//

import UIKit

class InventoryListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var inventoryList = InventoryListModel.dummyList

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
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
