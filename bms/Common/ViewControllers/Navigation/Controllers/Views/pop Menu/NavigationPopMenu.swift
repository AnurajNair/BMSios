//
//  NavigationPopMenu.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

@objc protocol NavigationPopMenuDelegate:class {
    @objc optional func popMenuItemTapped(_ index: Int)
}

class NavigationPopMenu: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: NavigationPopMenuDelegate?
    
    var data:[String] = []

    enum CellNames: String {
        case titleView = "NavigationPopMenuCellTableViewCell"
    }
    
    var cellIdentifiers: [String] = [CellNames.titleView.rawValue]
    
    static let cellHeight:CGFloat = 44.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        self.backgroundColor = UIColor.clear
        setupTableView()
    }
    
    func setupTableView() {
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = NavigationPopMenu.cellHeight
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNibs(cellIdentifiers)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.bounces = false
    }
    
    class func getTableViewHeight(_ tableData:[String]) -> CGFloat {
        return cellHeight * CGFloat(tableData.count)
    }
    
    //MARK:- Update Functions
    
    func updateData(_ tableData:[String]) {
        self.data = tableData
        self.tableView.reloadData()
        self.tableViewHeightConstraint.constant = NavigationPopMenu.getTableViewHeight(self.data)
        self.layoutIfNeeded()
    }
    
    //MARK:- Touch Event Functions
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if self.subviews.count > 0 {
            for view in self.subviews[0].subviews[0].subviews {
                if view == self.tableView  && view.point(inside: convert(point, to: view), with: event) {
                    return true
                }
            }
        }
        
        self.isHidden = true
        return true
        
    }

}

extension NavigationPopMenu: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.titleView.rawValue, for: indexPath) as? NavigationPopMenuTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateOptionName(self.data[indexPath.row])
        
        return cell
        
    }
}

extension NavigationPopMenu: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.popMenuItemTapped?(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
