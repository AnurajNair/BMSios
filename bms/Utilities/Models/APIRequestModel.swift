//
//  APIRequestModel.swift
//  bms
//
//  Created by Sahil Ratnani on 12/04/23.
//
import ObjectMapper

class APIRequestModel: APIRequestBody {
    var requestdata: String?
    
    enum RequestKeys : String{
        case requestdata        = "requestdata"
    }

    init(params: [String: Any]) {
        super.init()
        self.requestdata        = params[RequestKeys.requestdata.rawValue] as? String
        
    }
    
    required init?(map: ObjectMapper.Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.requestdata        <- map[RequestKeys.requestdata.rawValue]
        
    }
}
