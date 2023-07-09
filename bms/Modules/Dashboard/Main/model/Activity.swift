//
//  Activity.swift
//  bms
//
//  Created by Sahil Ratnani on 11/06/23.
//

import Foundation
import ObjectMapper

class Activity: APIRequestBody {
    @objc dynamic var activityId : Int = 0
    @objc dynamic var publisherName : String?
    @objc dynamic var activityDesc : String?
    @objc dynamic var publishedDate : String?
    @objc dynamic var publishedTime : String?

    enum ResponseKeys :String{
        case activityId  = "activityid"
        case publisherName  = "publishername"
        case activityDesc  = "activitydesc"
        case publishedDate  = "publisheddate"
        case publishedTime  = "publishedtime"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.activityId              <- map[ResponseKeys.activityId.rawValue]
        self.publisherName              <- map[ResponseKeys.publisherName.rawValue]
        self.activityDesc              <- map[ResponseKeys.activityDesc.rawValue]
        self.publishedDate              <- map[ResponseKeys.publishedDate.rawValue]
        self.publishedTime              <- map[ResponseKeys.publishedTime.rawValue]
    }
}
