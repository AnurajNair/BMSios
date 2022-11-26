//
//  PincodeRule.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import Foundation
import SwiftValidator

/**
 `PincodeRule` is a subclass of `RegexRule` that represents how pin codes are to be validated.
 */
public class PincodeRule: RegexRule {
    /**
     Initializes a `PincodeRule` object.
     
     - parameter message: String that holds error message.
     - returns: An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public convenience init(message : String = "Enter a valid 6 digit pincode"){
        self.init(regex: "\\d{6}", message : message)
    }
}
