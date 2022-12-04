//
//  ReusableDropDown.swift
//  bms
//
//  Created by Naveed on 02/12/22.
//

import UIKit
import SwiftyMenu

class ReusableDropDown: UIView {

    @IBOutlet weak var dropDown: SwiftyMenu!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        fromNib()
       _ = initFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fromNib()
        _ = initFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    func setupView(){
      
        self.dropDown.delegate = self
       
      
        
    }
    func setupDropDown(options:[DropDownModel]?,placeHolder:String?,textColor:UIColor?){
      
        self.dropDown.items = options ?? []
        var codeMenuAttributes = SwiftyMenuAttributes()
        codeMenuAttributes.placeHolderStyle = .value(text: placeHolder ?? "", textColor: textColor ?? UIColor.BMS.black)
        codeMenuAttributes.roundCorners = .all(radius: 5)
        codeMenuAttributes.height  = .value(height: 48)
        codeMenuAttributes.border = .value(color: UIColor.BMS.separatorGray, width: 0.8)
        self.dropDown.configure(with: codeMenuAttributes)
    }

}

extension ReusableDropDown: SwiftyMenuDelegate{
    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
        
    }
    
    
}

