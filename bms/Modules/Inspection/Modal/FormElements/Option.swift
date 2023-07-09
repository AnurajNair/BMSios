//
//  Option.swift
//  bms
//
//  Created by Sahil Ratnani on 01/05/23.
//

import ObjectMapper

class Option: RequestBody {
    @objc dynamic var key: String?
    @objc dynamic var value: String?
    @objc dynamic var rating: Int = 0

    enum ResponseKeys: String {
        case key = "key"
        case value = "value"
        case rating = "rating"
    }

    override func mapping(map: ObjectMapper.Map) {
        key <- map[ResponseKeys.key.rawValue]
        value <- map[ResponseKeys.value.rawValue]
        rating <- map[ResponseKeys.rating.rawValue]
    }

}
