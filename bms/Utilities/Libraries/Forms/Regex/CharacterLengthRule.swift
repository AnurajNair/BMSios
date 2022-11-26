//
//  CharacterLengthRule.swift
//  bms
//
//  Created by Naveed on 18/10/22.
//

import Foundation
import SwiftValidator

/**
 `CharacterLengthRule` is a subclass of `RegexRule` that represents how pin codes are to be validated.
 */
public class CharacterLengthRule: RegexRule {
    /**
     Initializes a `CharacterLengthRule` object.
     
     - parameter message: String that holds error message.
     - returns: An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    
    public convenience init(minLength: Int = 0, maxLength: Int = 0, message : String = "Should be %ld characters long") {
        
        var regex = ""
        var errorMessage = ""
        
        
        if minLength != 0 || maxLength != 0 {
            
            if minLength == maxLength {
                regex = "^.{\(minLength)}$"
                errorMessage = String(format: "Should be %ld characters", minLength)
            }
                
            else if minLength > 0 && maxLength > 0 {
                regex = "^.{\(minLength),\(maxLength)}$"
                errorMessage = String(format: "Should be between %ld and %ld characters", minLength, maxLength)
            }
                
            else if minLength > 0 {
                regex = "^.{\(minLength),}$"
                errorMessage = String(format: "Should be atleast %ld characters", minLength)
            }
                
            else if maxLength > 0 {
                regex = "^.{0,\(maxLength)}$"
                errorMessage = String(format: "Should be less than %ld characters", maxLength)
                
            }
            
        }
        
        self.init(regex: regex, message: errorMessage)
        
    }
    
    public convenience init(minLength: Int = 0, minMessage : String = "Should be atleast %ld characters long") {
        
        var regex = ""
        var errorMessage = ""
        
        if minLength != 0 {
            if minLength > 0 {
                regex = "^.{\(minLength),}$"
                errorMessage = String(format: minMessage, minLength)
            }
        }
        
        self.init(regex: regex, message: errorMessage)
    }
    
    public convenience init(maxLength: Int = 0, maxMessage : String = "Should be equal to or less than %ld characters long") {
        
        var regex = ""
        var errorMessage = ""
        
        if maxLength != 0 {
            
            if maxLength > 0 {
                regex = "^.{0,\(maxLength)}$"
                errorMessage = String(format: maxMessage , maxLength)
            }
            
        }
        
        self.init(regex: regex, message: errorMessage)
    }
    
    
}










