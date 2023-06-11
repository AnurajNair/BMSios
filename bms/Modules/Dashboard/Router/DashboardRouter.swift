//
//  DashboardRouter.swift
//  bms
//
//  Created by Sahil Ratnani on 11/06/23.
//

import Foundation
import Alamofire
import ObjectMapper

enum DashboardRouterProtocol: RouterProtocol{
    case dashbordData(APIRequestModel)
    
    var path: String{
        switch self {
        case .dashbordData(_):
            return "Dashboard/Dashboarddata"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .post
        }
    }
    
    var parameters: Any?{
        switch self {
        default:
            return nil
        }
    }
    
    var body: Any?{
        switch self {
        case .dashbordData(let body):
            return body
        }
    }
    
    var header: Any? {
        switch self {
        default:
            return nil
        }
    }
}

class DashboardRouterManager {
    func getInspectionStats(params: [String: Any],
                          successCompletionHandler: @escaping APISuccessHandler,
                          errorCompletionHandler: @escaping APIFailureHandler) {
        RestClient.getAPIResponse(Router.dashboardRouterHandler(.dashbordData(APIRequestModel(params: params)))) { (response) in
            if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response)) {
                successCompletionHandler(apiResponse)
            }
        } errorCompletionHandler: { error in
            errorCompletionHandler(error)
        }
    }
}
