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
   
    
    var path: String{
        switch self {
        case .getInspection:
            return "Inspector/InspectionSummary"
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .getInspection:
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
        default:
            return nil
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








class InspctionRouterManager{
    
    func getInspections(params: [String: Any],
                        successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                        errorCompletionHandler: @escaping (_ error: ApiError?) -> Void) {
            RestClient.getAPIResponse(Router.inspectionRouterHandler(InspectionRouterProtocol.getInspection(APIRequestModel(params: params))),
                                      successCompletionHandler: { (response) in
                if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response)) {
                    successCompletionHandler(apiResponse)
                }
            }) { (error) in
                errorCompletionHandler(error)
            }
        }
    
 
}
