//
//  InspectionTemplateTypeTableViewCell.swift
//  bms
//
//  Created by Naveed on 17/11/22.
//

import UIKit

class InspectionTemplateTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var inspectionTypeCheckboxView: ReusableFormCheckboxField!
    
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        initFromNib()
//        configCellView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCellView(){
       
    }
    
}

extension InspectionTemplateTypeTableViewCell:TTReusableFormCheckboxFieldDelegate{
   
}
