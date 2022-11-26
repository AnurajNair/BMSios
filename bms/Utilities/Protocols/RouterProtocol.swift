//
//  RouterProtocol.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import Alamofire



protocol RouterProtocol {
    
    var path: String { get }
    
    var method: Alamofire.HTTPMethod { get }
    
    var header : Any? { get }
    
    var parameters: Any? { get }
    
    var  body: Any? { get }
    
//    var apiType : APIType { get }
}
