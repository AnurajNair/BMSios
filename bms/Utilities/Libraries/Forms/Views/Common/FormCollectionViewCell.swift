//
//  FormCollectionViewCell.swift
//  bms
//
//  Created by Naveed on 27/11/22.
//

import UIKit

class FormCollectionViewCell: UICollectionViewCell {
    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var collectionFormElement: ReusableFormElementView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
