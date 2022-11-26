//
//  ReusableFormCollectionFlowLayout.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//


import Foundation
import UIKit

class ReusableFormCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

