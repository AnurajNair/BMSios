//
//  DummyDataResponse.swift
//  bms
//
//  Created by Naveed on 17/10/22.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm


class DummyResponse : ApiBaseResponse {
    var response : DummyData?
    
    enum ResponseKeys :String{
        case response   = "response"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.response     <- map[ResponseKeys.response.rawValue]
    }
}

class DummyData : RequestBody {
    var recentFriends : [User]?

    enum ResponseKeys :String{
        case recentFriends   = "recent_friends"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.recentFriends     <- map[ResponseKeys.recentFriends.rawValue]
    }
}
