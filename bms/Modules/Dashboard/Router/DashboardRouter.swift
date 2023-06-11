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
    case myActivites(APIRequestModel)
    case markActivityRead(APIRequestModel)

    var path: String{
        switch self {
        case .dashbordData(_):
            return "Dashboard/Dashboarddata"
        case .myActivites(_):
            return "Dashboard/MyActivity"
        case .markActivityRead(_):
            return "Dashboard/MarkActivityRead"
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
        case .dashbordData(let body),
                .myActivites(let body),
                .markActivityRead(let body):
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
    func performDashboardApiCall(api: DashboardRouterProtocol,
                                 successCompletionHandler: @escaping APISuccessHandler,
                                 errorCompletionHandler: @escaping APIFailureHandler) {
        RestClient.getAPIResponse(Router.dashboardRouterHandler(api)) { (response) in
            if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response)) {
                successCompletionHandler(apiResponse)
            }
        } errorCompletionHandler: { error in
            errorCompletionHandler(error)
        }
    }

    func getInspectionStats(params: [String: Any],
                            successCompletionHandler: @escaping APISuccessHandler,
                            errorCompletionHandler: @escaping APIFailureHandler) {
        performDashboardApiCall(api: .dashbordData(APIRequestModel(params: params)),
                                successCompletionHandler: successCompletionHandler,
                                errorCompletionHandler: errorCompletionHandler)
    }

    func getMyActivities(params: [String: Any],
                       successCompletionHandler: @escaping APISuccessHandler,
                       errorCompletionHandler: @escaping APIFailureHandler) {
        performDashboardApiCall(api: .myActivites(APIRequestModel(params: params)),
                                successCompletionHandler: successCompletionHandler,
                                errorCompletionHandler: errorCompletionHandler)
    }

    func markActivityRead(params: [String: Any],
                       successCompletionHandler: @escaping APISuccessHandler,
                       errorCompletionHandler: @escaping APIFailureHandler) {
        performDashboardApiCall(api: .markActivityRead(APIRequestModel(params: params)),
                                successCompletionHandler: successCompletionHandler,
                                errorCompletionHandler: errorCompletionHandler)
    }
}
