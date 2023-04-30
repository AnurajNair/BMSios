//
//  InspectionListTableViewCell.swift
//  bms
//
//  Created by Naveed on 26/10/22.
//

import UIKit



protocol InspectionListTableViewCellDelegate: AnyObject {
      func onInspectbtnClick(selectedItem:Inspection)
 
}

class InspectionListTableViewCell: UITableViewCell {
        
    @IBOutlet weak var srNoLabel: UILabel!
    @IBOutlet weak var buidLabel: UILabel!
    @IBOutlet weak var inspectionNameLabel: UILabel!
    @IBOutlet weak var bridgeNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak internal var inspectButton: UIButton!

    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var delegate: InspectionListTableViewCellDelegate? 
    
    var tableData:Inspection?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Mark: functions
    
    func configTableRow(srNo: Int, tableData:Inspection){
        self.tableData = tableData;
        self.srNoLabel.text = srNo.description
        self.buidLabel.text = tableData.buid
        self.inspectionNameLabel.text = tableData.inspectionName
        self.bridgeNameLabel.text = tableData.bridgeName
        self.startDateLabel.text = tableData.startDateAsString
        self.endDateLabel.text = tableData.endDateAsString
        self.statusLabel.text = tableData.inspectionStatusName
        
        guard let status = tableData.inspectionStatusEnum else {
            return
        }
        let inspectButtonTitle = getInspectionButtonTitle(status: status)
        inspectButton.setTitle(inspectButtonTitle, for: .normal)
        inspectButton.isEnabled = status == .assigned || status == .draft
    }
    
    func getInspectionButtonTitle(status: InspectionStatus) -> String {
        switch status {
        case .assigned:
            return "Start Inspection"
        case .reviewed, .submitted:
            return "Reviewed"
        case.draft:
            return "Resume"
        }
    }
    @IBAction func onInspectbtnClick(_ sender: Any) {
      
        self.delegate?.onInspectbtnClick(selectedItem: self.tableData!)
//        Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .changeSlider,data: ["BridgeDetail" : self.tableData as Any])
    }
    
}
