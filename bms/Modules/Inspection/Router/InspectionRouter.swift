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
    
    case getInspectorInspections(APIRequestModel)
    case getReviewerInspections(APIRequestModel)
    case getInspectionById(APIRequestModel)
    case saveInspection(APIRequestModel)
    case saveReview(APIRequestModel)
    
    var path: String{
        switch self {
        case .getInspectorInspections:
            return "Inspector/InspectionSummary"
        case .getReviewerInspections:
            return "Reviewer/InspectionSummary"
        case .getInspectionById(_):
            return "Inspector/InspectionById"
        case .saveInspection(_):
            return "Inspector/SaveInspection"
        case .saveReview(_):
            return "Reviewer/SaveInspection"
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
        case .getInspectorInspections(let body),
                .getReviewerInspections(let body),
                .getInspectionById(let body),
                .saveInspection((let body)),
                .saveReview(let body):
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

    func getInspectorInspections(params: [String: Any],
                                 successCompletionHandler: @escaping APISuccessHandler,
                                 errorCompletionHandler: @escaping APIFailureHandler) {
        performInspectionsApiCall(api: .getInspectorInspections(APIRequestModel(params: params)),
                                  successCompletionHandler: successCompletionHandler,
                                  errorCompletionHandler: errorCompletionHandler)
    }

    func getReviewerInspections(params: [String: Any],
                                successCompletionHandler: @escaping APISuccessHandler,
                                errorCompletionHandler: @escaping APIFailureHandler) {
        performInspectionsApiCall(api: .getReviewerInspections(APIRequestModel(params: params)),
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

    func saveInspection(params: [String: Any],
                        successCompletionHandler: @escaping APISuccessHandler,
                        errorCompletionHandler: @escaping APIFailureHandler) {
        performInspectionsApiCall(api: .saveInspection(APIRequestModel(params: params)),
                                  successCompletionHandler: successCompletionHandler,
                                  errorCompletionHandler: errorCompletionHandler)
        
    }

    func saveReview(params: [String: Any],
                    successCompletionHandler: @escaping APISuccessHandler,
                    errorCompletionHandler: @escaping APIFailureHandler) {
        performInspectionsApiCall(api: .saveReview(APIRequestModel(params: params)),
                                  successCompletionHandler: successCompletionHandler,
                                  errorCompletionHandler: errorCompletionHandler)
        
    }
}
