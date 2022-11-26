//
//  ApiBaseRequestKeys.swift
//  bms
//
//  Created by Naveed on 15/10/22.
//

import Foundation
import ObjectMapper
import RealmSwift

class ApiBaseRequestKeys : APIRequestBody{
    
    var fromId: Int?
    var limit: Int?
    var direction: String?
    var filter : String?
    var offset : Int?
    
    enum RequestKeys: String{
        case fromId = "from_id"
        case limit = "limit"
        case direction = "direction"
        case filter = "filter"
        case offset = "offset"
    }
    
    enum Direction: String {
        case older = "older"
        case newer = "newer"
    }
    
    init(params : [String : Any]) {
        super.init()
        
        if let value = params[RequestKeys.fromId.rawValue] as? Int {
            self.fromId = value
        }
        
        if let value = params[RequestKeys.limit.rawValue] as? Int, value != 0 {
            self.limit = value
        } else {
            self.limit = Constants.apiResponsePaginationLimit
        }
        
        if let value = params[RequestKeys.direction.rawValue] as? Direction {
            self.direction = value.rawValue
        }
        
        if let value = params[RequestKeys.filter.rawValue] as? [String] {
            self.filter = value.joined(separator: ",")
        }
        
        if let value = params[RequestKeys.filter.rawValue] as? String {
            self.filter = value
        }
        if let value = params[RequestKeys.offset.rawValue] as? Int {
            self.offset = value
        }
        
    }
    
    required init?(map: ObjectMapper.Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: ObjectMapper.Map) {
        fromId        <- map[RequestKeys.fromId.rawValue]
        limit         <- map[RequestKeys.limit.rawValue]
        direction     <- map[RequestKeys.direction.rawValue]
        filter        <- map[RequestKeys.filter.rawValue]
        offset        <- map[RequestKeys.offset.rawValue]
    }
}
