//
//  InspectionRouter.swift
//  bms
//
//  Created by Naveed on 15/11/22.
//


import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

enum InspectionRouterProtocol : RouterProtocol{
    
    case getInspection(APIRequestModel)
    case getInspectionById(APIRequestModel)

    
    var path: String{
        switch self {
        case .getInspection:
            return "Inspector/InspectionSummary"
        case .getInspectionById(_):
            return "Inspector/InspectionById"
        }
    }
    
    var method: HTTPMethod{
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
        case .getInspection(let body):
            return body
        case .getInspectionById(let body):
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


//class GetInspection: APIRequestBody {
//    var userId: String?
//
//    enum RequestKeys : String{
//        case userId        = "user_id"
//    }
//
//    init(params: [String: Any]) {
//        super.init()
//        self.userId        = params[RequestKeys.userId.rawValue] as? String
//    }
//
//    required init?(map: Map) {
//        fatalError("init(map:) has not been implemented")
//    }
//
//    override func mapping(map: Map) {
//        self.userId        <- map[RequestKeys.userId.rawValue]
//    }
//}








class InspctionRouterManager {

    func performInspectionsApiCall(api: InspectionRouterProtocol,
                        successCompletionHandler: @escaping APISuccessHandler,
                        errorCompletionHandler: @escaping APIFailureHandler) {
        RestClient.getAPIResponse(Router.inspectionRouterHandler(api)) { (response) in
            if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response)) {
                successCompletionHandler(apiResponse)
            }
        } errorCompletionHandler: { (error) in
            errorCompletionHandler(error)
        }
    }

    func getInspections(params: [String: Any],
                        successCompletionHandler: @escaping APISuccessHandler,
                        errorCompletionHandler: @escaping APIFailureHandler) {
        performInspectionsApiCall(api: .getInspection(APIRequestModel(params: params)),
                                  successCompletionHandler: successCompletionHandler,
                                  errorCompletionHandler: errorCompletionHandler)
    }

    func getInspectionById(params: [String: Any],
                           successCompletionHandler: @escaping APISuccessHandler,
                           errorCompletionHandler: @escaping APIFailureHandler) {
        performInspectionsApiCall(api: .getInspectionById(APIRequestModel(params: params)),
                                  successCompletionHandler: successCompletionHandler,
                                  errorCompletionHandler: errorCompletionHandler)

    }
}
