//
//  InspectionListTableViewCell.swift
//  bms
//
//  Created by Naveed on 26/10/22.
//

import UIKit



 protocol InspectionListTableViewCellDelegate: class {
      func onInspectbtnClick(selectedItem:InspectionBridgeListModel)
 
}

class InspectionListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moreActionsPopu: UIButton!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var projectNumberLabel: UILabel!
    
    @IBOutlet weak var projectNameLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var delegate: InspectionListTableViewCellDelegate? 
    
    var tableData:InspectionBridgeListModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPopup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Mark: functions
    
    func setupPopup(){
        
        let optionClosure = {(action: UIAction) in print("hello")}
        
        moreActionsPopu.menu = UIMenu(children: [UIAction(title:"First Item", state: .on ,handler: optionClosure),UIAction(title:"Second Item" ,handler: optionClosure)])
        
        moreActionsPopu.showsMenuAsPrimaryAction = true
        moreActionsPopu.changesSelectionAsPrimaryAction = true
    }
    
    func configTableRow(tableData:InspectionBridgeListModel){
        
        self.tableData = tableData;
        self.idLabel.text = tableData.id
        self.projectNumberLabel.text = tableData.project_code
        self.projectNameLabel.text = tableData.project_name
        self.locationLabel.text = tableData.location
    }
    
    
    @IBAction func onInspectbtnClick(_ sender: Any) {
      
        self.delegate?.onInspectbtnClick(selectedItem: self.tableData!)
//        Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .changeSlider,data: ["BridgeDetail" : self.tableData as Any])
    }
    
}
