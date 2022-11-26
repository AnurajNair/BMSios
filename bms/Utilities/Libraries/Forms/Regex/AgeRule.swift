//
//  AgeRule.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import Foundation
import SwiftValidator

/**
 `AgeRule` is a subclass of Rule that defines how minimum character length is validated.
 */
public class AgeRule: Rule {
    /// Default minimum age
    private var MINIMUM_AGE: Int = 0
    /// Default maximum age length.
    private var MAXIMUM_AGE: Int = 0
    /// Default date format.
    private var DATE_FORMAT: String = "dd MMM yyyy"
    /// Default error message to be displayed if validation fails.
    private var message : String = "Does not meet the age criteria"
    
    /// - returns: An initialized `MinLengthRule` object, or nil if an object could not be created for some reason that would not result in an exception.
    public init(){}
    
    /**
     Initializes a `AgeRule` object that is to validate the Age of the date entered in the of a field.
     
     - parameter minimumAge: Minimum Age in Years.
     - parameter maximumAge: Maximum Age in Years.
     - parameter dateFormat: Date Format to convert the textfield string to date and validate.
     - parameter message: String of error message.
     - returns: An initialized `AgeRule` object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    public init(minimumAge: Int = 0, maximumAge:Int = 0, dateFormat:String = "dd MMM yyyy", message : String = ""){
        self.MINIMUM_AGE = minimumAge
        self.MAXIMUM_AGE = maximumAge
        self.DATE_FORMAT = dateFormat
        
        if message.isEmpty {
            
            var displayMessage = self.message
            if minimumAge > 0 && maximumAge > 0 {
                displayMessage = "Should be between \(minimumAge) - \(maximumAge) years"
            }
                
            else if minimumAge > 0 {
                displayMessage = "Should be atleast \(minimumAge) years"
            }
                
            else if maximumAge > 0 {
                displayMessage = "Should be under \(maximumAge) years"
            }
            
            self.message = displayMessage
            
        } else {
            self.message = message
        }
        
    }
    
    /**
     Validates a field.
     - parameter value: String to checked for validation.
     - returns: A boolean value. True if validation is successful; False if validation fails.
     */
    public func validate(_ value: String) -> Bool {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.DATE_FORMAT
        
        if let enteredDate = dateFormatter.date(from: value) {
            let difference = Date().years(from: enteredDate)
            
            if self.MINIMUM_AGE > 0 && self.MAXIMUM_AGE > 0 {
                return difference >= self.MINIMUM_AGE && difference < self.MAXIMUM_AGE
            }
                
            else if self.MINIMUM_AGE > 0 {
                return difference >= self.MINIMUM_AGE
            }
                
            else if self.MAXIMUM_AGE > 0 {
                return difference < self.MAXIMUM_AGE
            }
        }
        
        return true
    }
    
    /**
     Displays error message when field has failed validation.
     
     - returns: String of error message.
     */
    public func errorMessage() -> String {
        return message
    }
}


