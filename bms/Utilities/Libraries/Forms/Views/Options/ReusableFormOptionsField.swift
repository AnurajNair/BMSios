//
//  ReusableFormOptionField.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import UIKit

@objc protocol ReusableFormOptionsFieldDelegate:class {
    @objc optional func itemSaved(_ selectedItems: [Int])
    @objc optional func itemSelected(_ selectedItems: Int)
    @objc optional func itemDeselected(_ selectedItems: Int)
    @objc optional func optionsFieldDidChangeHeight(height: CGFloat)
}

class ReusableFormOptionsField: UIView {
    
    @IBOutlet weak var headerView: ReusableFormOptionsHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var optionsDelegate: ReusableFormOptionsFieldDelegate?
    
    enum CellNames: String {
        case selectableView = "ReusableSelectableCollectionViewCell"
    }
    
    let cellIdentifiers:[String] = [CellNames.selectableView.rawValue]
    
    var verticalSectionSpacing: CGFloat = 0.0
    var lineSpacing: CGFloat = 0.0
    var interItemSpacing: CGFloat = 0.0
    
    var id: Any = ""
    var data:[String] = []
    var title:String = ""
    var selectedItems: [Int] = []
    var maxHeight: CGFloat = 0.0
    var maxCount: Int = 0
    var numberOfItemsPerRow: CGFloat = 0.0
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var shouldShowSelectAll = false
    var shouldShowClear = false
    var isMultiSelect = false
    var allowsDeselectDuringSingleSelect = true
    var selectAllClearButton: UIButton = UIButton()
    var frameWidth:CGFloat = 0.0
    var asymmetricPadding: CGFloat = 20.0
    var isEqualWidth: Bool = true
    var isEqualHeight: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
        initFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fromNib()
        initFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frameWidth != self.frame.size.width {
            self.frameWidth = self.frame.size.width
            self.updateFrameHeight(true)
        }
        
    }
    
    //MARK:- Setup Functions
    
    func setupView() {
        self.frameWidth = self.frame.size.width
        setupCollectionView()
    }
    
    func setupCollectionView() {
        self.collectionView.backgroundColor = FormElementStyler.Options.fieldBackgroundColor
        self.collectionView.bounces = false
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerNibs(cellIdentifiers)
    }
    
    //MARK:- Update Functions
    
    func layoutCollectionView() {
        
        let layout: UICollectionViewFlowLayout = ReusableFormCollectionViewFlowLayout()
        
        if self.scrollDirection == .vertical {
            lineSpacing = 10
            interItemSpacing = 10
            layout.sectionInset = UIEdgeInsets.init(top: verticalSectionSpacing, left: 0, bottom: verticalSectionSpacing, right: 0)
        }
            
        else if self.scrollDirection == .horizontal {
            interItemSpacing = 0
            lineSpacing = 10
            layout.sectionInset = UIEdgeInsets.init(top: verticalSectionSpacing, left: 0, bottom: verticalSectionSpacing, right: 0)
        }
        
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.scrollDirection = self.scrollDirection
        
        self.collectionView.collectionViewLayout = layout
    }
    
    func setupOptionsField(id:Any = "",
                           title: String = "",
                           values: [String] = [],
                           selectedItems:[Int] = [],
                           isEditable: Bool = true,
                           maxHeight: CGFloat = 0.0,
                           maxCount: Int = 0,
                           scrollDirection: UICollectionView.ScrollDirection = .vertical,
                           numberOfItemsPerRow: CGFloat = 1.0,
                           asymmetricPadding: CGFloat = 20.0,
                           isEqualWidth: Bool = true,
                           isEqualHeight: Bool = false,
                           allowsDeselect: Bool = true,
                           showSelectAll: Bool = true,
                           showClear: Bool = true) {
        
        self.id = id
        self.title = title
        self.data = values
        self.selectedItems = selectedItems
        self.isEqualWidth = isEqualWidth
        self.isEqualHeight = isEqualHeight
        self.asymmetricPadding = asymmetricPadding
        
        self.scrollDirection = scrollDirection
        self.numberOfItemsPerRow = numberOfItemsPerRow
        
        if self.scrollDirection == .vertical {
            self.numberOfItemsPerRow = ceil(numberOfItemsPerRow)
        }
        
        self.allowsDeselectDuringSingleSelect = allowsDeselect
        self.shouldShowSelectAll = showSelectAll
        self.shouldShowClear = isEditable ? showClear : false
        
        self.maxHeight = maxHeight
        self.maxCount = maxCount
        self.updateSelectionType()
        
        layoutCollectionView()
        self.updateFrameHeight()
        
        self.collectionView.allowsSelection = isEditable
        
    }
    
    func getInterItemSpacing() -> CGFloat {
        
        var spacing =  interItemSpacing
        
        if self.scrollDirection == .horizontal {
            spacing = lineSpacing
        }
        
        return spacing
    }
    
    func updateFrameHeight(_ shouldDelegate: Bool = false) {
        
        if self.scrollDirection != .horizontal {
            self.layoutIfNeeded()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        
        var frameHeight = self.maxHeight > 0.0 ? self.maxHeight: self.collectionView.collectionViewLayout.collectionViewContentSize.height
        
        if !self.title.isEmpty || (self.shouldShowClear && self.isMultiSelect) {
            frameHeight += 30
            self.headerView.isHidden = false
            self.headerView.setMessage(message: self.title)
            self.selectAllClearButton = self.headerView.selectClearButton
            setupSelectAllClearButton()
        } else {
            self.headerView.isHidden = true
        }
        
        self.frame.size.height = frameHeight
        
        if shouldDelegate {
            self.optionsDelegate?.optionsFieldDidChangeHeight?(height: frameHeight)
        }
        
        refreshTable()
        
    }
    
    func updateSelectionType() {
        
        if self.maxCount == 1 {
            self.isMultiSelect = false
            self.collectionView.allowsMultipleSelection = false
        } else {
            self.isMultiSelect = true
            self.collectionView.allowsMultipleSelection = true
        }
        
    }
    
    func refreshTable() {
        
        self.collectionView.reloadData()
        
        for index in self.selectedItems {
            self.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .centeredVertically)
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
        
        if isMultiSelect {
            completedSelection()
        }
    }
    
    func completedSelection() {
        self.optionsDelegate?.itemSaved?(self.selectedItems)
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
    
    func isSelectAll() -> Bool {
        if selectedItems.count == 0 && self.maxCount == 0 && self.shouldShowSelectAll {
            return true
        }
        return false
    }
    
    func setupSelectAllClearButton() {
        
        if isMultiSelect && self.shouldShowClear {
            self.selectAllClearButton.isHidden = false
            
            if self.isSelectAll() {
                self.selectAllClearButton.setTitle("Select All".localized(), for: .normal)
            } else {
                self.selectAllClearButton.setTitle("Clear".localized(), for: .normal)
            }
            
            self.selectAllClearButton.addTarget(self, action: #selector(selectAllClearButtonTapped), for: .touchUpInside)
            
        } else {
            self.selectAllClearButton.isHidden = true
        }
        
    }
    
    //MARK:- Action Functions
    @objc func selectAllClearButtonTapped() {
        
        if self.isSelectAll()  {
            for index in 0..<self.collectionView.numberOfItems(inSection: 0) {
                self.addToSelectedItems(value: index)
                self.collectionView.selectItem(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .centeredVertically)
            }
        }
            
        else {
            self.selectedItems = []
            self.collectionView.reloadData()
            completedSelection()
        }
        
    }
    
}

extension ReusableFormOptionsField: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: CellNames.selectableView.rawValue, for: indexPath) as? ReusableSelectableCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if !isMultiSelect {
            
            cell.updateData(nameLabelValue: data[indexPath.item], selectionIconDefaultValue: FormElementStyler.Options.leftImageRadiobuttonDefault, selectionIconSelectedValue: FormElementStyler.Options.leftImageRadiobuttonSelected)
            
        } else {
            
            cell.updateData(nameLabelValue: data[indexPath.item], selectionIconDefaultValue: FormElementStyler.Options.leftImageCheckboxDefault, selectionIconSelectedValue: FormElementStyler.Options.leftImageCheckboxSelected)
            
        }
        
        cell.isSelected = isValueInSelectedItems(indexPath.item).count > 0
        cell.setSelected(cell.isSelected, animated: false)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return self.collectionView.contentOffset
    }
    
}

extension ReusableFormOptionsField: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing =  getInterItemSpacing()
        
        let totalInterItemSpacing = (spacing * (numberOfItemsPerRow - 1))
        var blockSize = (collectionView.frame.size.width - totalInterItemSpacing) / self.numberOfItemsPerRow
        
        var cellHeight:CGFloat = 0.0
        var labelHeight:CGFloat = 0.0
        let name = self.data[indexPath.item]
        
        let font = isValueInSelectedItems(indexPath.item).count == 0 ? FormElementStyler.Options.fieldSelectedFont : FormElementStyler.Options.fieldDefaultFont
        
        if self.scrollDirection == .horizontal && !isEqualWidth {
            let nameWidth = name.size(withAttributes: [NSAttributedString.Key.font: font])
            blockSize = nameWidth.width + 20 + 10 + self.asymmetricPadding // 20 for the left button + 10 for the spacing + 40 for general padding
            labelHeight = name.getHeightInLabel(font: font, width: blockSize)
        }
            
        else {
            let nameWidth = blockSize - 30 //Padding for cell
            labelHeight = name.getHeightInLabel(font: font, width: nameWidth)
        }
        
        cellHeight = self.isEqualHeight || labelHeight <= 24.0 ? 24.0 : labelHeight
        
        if self.scrollDirection == .horizontal && cellHeight > collectionView.frame.size.height {
            collectionView.frame.size.height = cellHeight
        }
        
        return CGSize(width: blockSize, height: cellHeight)
        
    }
    
}

extension ReusableFormOptionsField: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        if allowsDeselectDuringSingleSelect && !isMultiSelect && (self.collectionView.indexPathsForSelectedItems?.contains(indexPath))! {
            
            self.removeFromSelectedItems(value: indexPath.item)
            self.collectionView.deselectItem(at: indexPath, animated: true)
            self.optionsDelegate?.itemSaved?(self.selectedItems)
            return false
            
        }
        
        if isMultiSelect && self.maxCount > 0 && self.selectedItems.count >= self.maxCount {
            
            let cell = self.collectionView.cellForItem(at: indexPath)
            
            if let value = cell?.isSelected, value {
                return true
            } else {
                Utils.displayAlert(title: "Maximum Limit Reached", message: "You can select a maximum of \(maxCount) values")
                return false
            }
        }
        
        return true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.addToSelectedItems(value: indexPath.item)
        self.optionsDelegate?.itemSelected?(indexPath.item)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        self.removeFromSelectedItems(value: indexPath.item)
        self.optionsDelegate?.itemDeselected?(indexPath.item)
        
    }
    
}
