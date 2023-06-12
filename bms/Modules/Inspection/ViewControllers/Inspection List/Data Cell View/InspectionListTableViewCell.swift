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
        inspectButton.setTitleColor(UIColor.BMS.fontWhite, for: .normal)
        inspectButton.setTitleColor(UIColor.BMS.fontDarkGray, for: .disabled)
        inspectButton.setAsRounded(cornerRadius: 5)
        
        setup()
    }

    func setup() {
        let labelStyle = TextStyles.ListItemBlackTitle
        UILabel.style([(view: srNoLabel, style: labelStyle),
                       (view: buidLabel, style: labelStyle),
                       (view: inspectionNameLabel, style: labelStyle),
                       (view: bridgeNameLabel, style: labelStyle),
                       (view: startDateLabel, style: labelStyle),
                       (view: endDateLabel, style: labelStyle),
                       (view: statusLabel, style: labelStyle)])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Mark: functions
    
    func configTableRow(srNo: Int, tableData:Inspection, inspectionButtonTitle: String, inspectionButtonState: UIButton.State){
        self.tableData = tableData;
        self.srNoLabel.text = srNo.description
        self.buidLabel.text = tableData.buid
        self.inspectionNameLabel.text = tableData.inspectionName
        self.bridgeNameLabel.text = tableData.bridgeName
        self.startDateLabel.text = tableData.startDateAsString
        self.endDateLabel.text = tableData.endDateAsString
        self.statusLabel.text = tableData.inspectionStatusName
        
        inspectButton.setTitle(inspectionButtonTitle, for: inspectionButtonState)
        inspectButton.isEnabled = inspectionButtonState != .disabled
        inspectButton.backgroundColor = inspectionButtonState == .disabled ? .BMS.backgroundGrey : .BMS.buttonGreen
        
    }

    @IBAction func onInspectbtnClick(_ sender: Any) {
      
        self.delegate?.onInspectbtnClick(selectedItem: self.tableData!)
//        Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .changeSlider,data: ["BridgeDetail" : self.tableData as Any])
    }
    
}
