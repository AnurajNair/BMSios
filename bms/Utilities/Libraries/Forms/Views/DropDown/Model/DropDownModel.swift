//
//  DropDownModel.swift
//  bms
//
//  Created by Naveed on 03/12/22.
//

import Foundation
import SwiftyMenu

struct DropDownModel {
    let id: Any
    let name: String
}

extension DropDownModel: SwiftyMenuDisplayable {
    var displayableValue: String {
        return self.name
    }
    
    var retrievableValue: Any {
        return self
    }
    
   
}
