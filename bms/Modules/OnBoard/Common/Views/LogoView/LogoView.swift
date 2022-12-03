//
//  LogoView.swift
//  bms
//
//  Created by Naveed on 18/10/22.
//

import Foundation
import UIKit

class LogoView:UIView{
    @IBOutlet weak var logoImage:UIImageView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        
    }
    
    
    
}
