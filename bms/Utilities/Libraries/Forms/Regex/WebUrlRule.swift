//
//  WebUrlRule.swift
//  bms
//
//  Created by Naveed on 19/10/22.
//

import Foundation
import SwiftValidator

/**
 `WebUrlRule` is a subclass of `RegexRule` that represents how pin codes are to be validated.
 */
public class WebUrlRule: RegexRule {
    /**
     Initializes a `WebUrlRule` object.
     
     - parameter message: String that holds error message.
     - returns: An initialized object, or nil if an object could not be created for some reason that would not result in an exception.
     */
    
    //java format for url validation
    //@^(http\:\/\/|https\:\/\/)?([a-z0-9][a-z0-9\-]*\.)+[a-z0-9][a-z0-9\-]*$@i
    
    public convenience init(message : String = "Enter a valid url") {
        
        let regex = "^(?:((?:https?|ftp):\\/\\/)|www?)(?:\\S+(?::\\S*)?@)?(?:(?!(?:10|127)(?:\\.\\d{1,3}){3})(?!(?:169\\.254|192\\.168)(?:\\.\\d{1,3}){2})(?!172\\.(?:1[6-9]|2\\d|3[0-1])(?:\\.\\d{1,3}){2})(?:[1-9]\\d?|1\\d\\d|2[01]\\d|22[0-3])(?:\\.(?:1?\\d{1,2}|2[0-4]\\d|25[0-5])){2}(?:\\.(?:[1-9]\\d?|1\\d\\d|2[0-4]\\d|25[0-4]))|(?:(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)(?:\\.(?:[a-z\\u00a1-\\uffff0-9]-*)*[a-z\\u00a1-\\uffff0-9]+)*(?:\\.(?:[a-z\\u00a1-\\uffff]{2,}))\\.?)(?::\\d{2,5})?(?:[/?#]\\S*)?$"
        
        self.init(regex: regex, message : message)
        
    }
}
