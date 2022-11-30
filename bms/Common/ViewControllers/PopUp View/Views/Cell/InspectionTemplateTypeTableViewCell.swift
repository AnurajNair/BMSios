//
//  InspectionTemplateTypeTableViewCell.swift
//  bms
//
//  Created by Naveed on 17/11/22.
//

import UIKit

class InspectionTemplateTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var inspectionTypeCheckboxView: ReusableFormCheckboxField!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    @IBOutlet weak var checklabel: UILabel!
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    var isChecked:Bool = false {
        didSet {
            if isChecked {
                checkImage.image = UIImage(named: FormElementStyler.Checkbox.leftImageSelected)?.withRenderingMode(.alwaysTemplate)
            } else {
                checkImage.image = UIImage(named: FormElementStyler.Checkbox.leftImageDefault)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
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
    
    func configCellView(label:String){
        self.checklabel.text = label
       
    }
    
}

extension InspectionTemplateTypeTableViewCell:TTReusableFormCheckboxFieldDelegate{
   
}
