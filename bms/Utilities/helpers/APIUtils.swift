//
//  APIUtils.swift
//  bms
//
//  Created by Sahil Ratnani on 30/04/23.
//

import Foundation
import ObjectMapper

typealias APIRequestParams = [String : Any]
class APIUtils {
    class func createAPIRequestParams(dataObject: APIRequestBody) -> APIRequestParams {
        var params = APIRequestParams()
        params[APIRequestModel.RequestKeys.requestdata.rawValue] = encryptAPIRequestData(dataObject: dataObject)
        return params
    }
    
    class func encryptAPIRequestData(dataObject: APIRequestBody) -> String {
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(dataObject),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        let encrypRequest = Utils().encryptData(json: jsonString! )
       return encrypRequest
    }
}
