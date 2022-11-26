//
//  ReusablePopupSelectionView.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import UIKit

class ReusablePopupSelectionView: UIView {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectAllClearButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    weak var delegate: ReusablePopupFieldSelectionViewDelegate?
    var data:[String] = []
    var minCount: Int = 0
    var maxCount: Int = 0
    
    var selectedItems: [Int] = []
    var shouldShowSave = true
    var shouldShowSelectAll = false
    var shouldShowClear = false
    var isMultiSelect = false
    var allowsDeselectDuringSingleSelect = true
    
    enum CellNames: String {
        case selectableCell = "ReusableSelectableTableViewCell"
    }
    
    let cellIdentifiers:[String] = [CellNames.selectableCell.rawValue]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    //MARK:- Setup Functions
    func setupView() {
        
        self.selectAllClearButton.isHidden = true
        self.saveButton.isHidden = true
        
        self.headerView.backgroundColor = FormElementStyler.Popup.headerViewBackgroundColor
        
        self.headerTitle.font = FormElementStyler.Popup.headerViewFont
        self.headerTitle.textColor = FormElementStyler.Popup.headerViewTextColor
        
        self.setupTableView()
    }
    
    func setupSaveButton() {
        if shouldShowSave {
            self.saveButton.isHidden = false
            UIButton.style([(view: saveButton, title: "Save", style: FormElementStyler.Popup.saveButtonStyle)])
        } else {
            self.saveButton.isHidden = true
        }
    }
    
    func isSelectAll() -> Bool {
        if selectedItems.count == 0 && self.maxCount == 0 && self.shouldShowSelectAll {
            return true
        }
        return false
    }
    
    func setupSelectAllClearButton() {
        
        if self.isMultiSelect && self.shouldShowClear {
            self.selectAllClearButton.isHidden = false
            
            if self.isSelectAll() {
                UIButton.style([(view: selectAllClearButton, title: "Select All", style: FormElementStyler.Popup.selectAllClearButtonStyle)])
            } else {
                UIButton.style([(view: selectAllClearButton, title: "Clear", style: FormElementStyler.Popup.selectAllClearButtonStyle)])
            }
            
        } else {
            self.selectAllClearButton.isHidden = true
        }
    }
    
    func setupTableView() {
        
        self.tableView.bounces = false
        self.tableView.separatorInset.left = 0.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNibs(cellIdentifiers)
        self.tableView.rowHeight = 52.0
        
    }
    
    //MARK:- Update Functions
    
    func updateData(title: String = "",
                    value: [String],
                    selectedItems:[Int] = [],
                    minCount: Int = 0,
                    maxCount: Int = 0,
                    isSaveVisible: Bool = true,
                    showSelectAll: Bool = true,
                    showClear: Bool = true,
                    isEditable: Bool = true,
                    allowsDeselect: Bool = true) {
        
        self.data = value
        self.selectedItems = selectedItems
        self.allowsDeselectDuringSingleSelect = allowsDeselect
        self.shouldShowSelectAll = showSelectAll
        self.shouldShowClear = isEditable ? showClear : false
        
        self.minCount = minCount
        self.maxCount = maxCount
        self.updateSelectionType()
        
        if isEditable && isMultiSelect {
            self.shouldShowSave = true
        } else if isEditable {
            self.shouldShowSave = isSaveVisible
        } else {
            self.shouldShowSave = false
        }
        
        self.setupSaveButton()
        self.setupSelectAllClearButton()
        
        if !title.isEmpty {
            self.headerTitle.text = title
        } else {
            self.headerView.isHidden = true
        }
        
        self.tableView.reloadData()
        
        for index in self.selectedItems {
            self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
        }
        
        self.tableView.allowsSelection = isEditable
        
    }
    
    func updateSelectionType() {
        
        if self.maxCount == 1 {
            self.isMultiSelect = false
            self.tableView.allowsMultipleSelection = false
        } else {
            self.isMultiSelect = true
            self.tableView.allowsMultipleSelection = true
        }
        
    }
    
    //MARK:- Action Functions
    @IBAction func selectAllClearButtonTapped() {
        
        if self.isSelectAll()  {
            for index in 0..<self.tableView.numberOfRows(inSection: 0) {
                self.addToSelectedItems(value: index)
                self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
            }
        }
            
        else {
            self.selectedItems = []
            self.tableView.reloadData()
        }
        
        self.setupSelectAllClearButton()
        
    }
    
    @IBAction func saveButtonTapped() {
        
        if self.minCount > 0 && self.selectedItems.count < self.minCount {
            
            let stringValue = "\(minCount) value".pluralizeForInt(self.minCount)
            Utils.displayAlert(title: "Error", message: "You must select atleast " + stringValue)
            
        }
            
        else {
            self.delegate?.saveButtonTapped?(self.selectedItems)
        }
    }
    
    //MARK:- Helper Functions
    
    func addToSelectedItems(value: Int) {
        
        if isValueInSelectedItems(value).count == 0 {
            self.selectedItems.append(value)
        }
        
        completedSelection()
    }
    
    func removeFromSelectedItems(value: Int) {
        self.selectedItems = isValueInSelectedItems(value, wantMatches: false)
        completedSelection()
    }
    
    func completedSelection() {
        
        if !shouldShowSave && !self.isMultiSelect {
            self.delegate?.saveButtonTapped?(self.selectedItems)
        }
        self.setupSelectAllClearButton()
    }
    
    func isValueInSelectedItems(_ value: Int, wantMatches: Bool = true) -> [Int] {
        
        let isPresent = self.selectedItems.filter { (selectedValue) -> Bool in
            
            if selectedValue == value {
                return wantMatches
            } else {
                return !wantMatches
            }
            
        }
        
        return isPresent
        
    }
    
}

//MARK:- Table View Delegate and Data Source Methods
extension ReusablePopupSelectionView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellNames.selectableCell.rawValue) as? ReusableSelectableTableViewCell else {
            return UITableViewCell()
        }
        
        if !self.isMultiSelect {
            
            cell.updateData(nameLabelValue: data[indexPath.row], rightAccessoryDefaultValue: "Form-Radiobutton-Default", rightAccessorySelectedValue: "Form-Radiobutton-Selected")
            
        } else {
            
            cell.updateData(nameLabelValue: data[indexPath.row], rightAccessoryDefaultValue: "Form-Checkbox-Default", rightAccessorySelectedValue: "Form-Checkbox-Selected")
            
        }
        
        cell.isSelected = isValueInSelectedItems(indexPath.row).count > 0
        
        return cell
        
    }
    
}

extension ReusablePopupSelectionView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        
        if allowsDeselectDuringSingleSelect && !self.isMultiSelect && tableView.indexPathForSelectedRow == indexPath {
            
            self.removeFromSelectedItems(value: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            return false
            
        }
        
        if self.isMultiSelect && self.maxCount > 0 && self.selectedItems.count >= self.maxCount {
            
            let cell = tableView.cellForRow(at: indexPath)
            
            if let value = cell?.isSelected, value {
                return true
            } else {
                let stringValue = "\(maxCount) value".pluralizeForInt(self.maxCount)
                Utils.displayAlert(title: "Maximum Limit Reached", message: "You can select a maximum of \(stringValue)")
                return false
            }
        }
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.addToSelectedItems(value: indexPath.row)
        self.delegate?.itemSelected?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        self.removeFromSelectedItems(value: indexPath.row)
        self.delegate?.itemDeselected?(indexPath.row)
        
    }
    
}

