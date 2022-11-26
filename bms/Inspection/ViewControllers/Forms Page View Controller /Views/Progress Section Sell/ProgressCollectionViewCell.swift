//
//  ProgressCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 03/11/22.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    
    
    class var identifier: String { return String(describing: self) }

    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//   
        
    }

}
