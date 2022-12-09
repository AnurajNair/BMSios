//
//  onBoardRouter.swift
//  bms
//
//  Created by Naveed on 24/11/22.
//




import Foundation
import Alamofire
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

enum OnBoardRouterProtocol : RouterProtocol{
    
    case postLogin(PostLogin)
   
    
    var path: String{
        switch self {
        case .postLogin(_):
            return "Authenticate/login"
        }
    }
    
    var method: HTTPMethod{
        switch self {
        case .postLogin(_):
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
        case .postLogin(let body):
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


class PostLogin: APIRequestBody {
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








class OnBoardRouterManager{
    
    func verifyUserCredLogin(params: [String: Any],
                 successCompletionHandler: @escaping (_ response: LoginUserResponse) -> Void,
                 errorCompletionHandler: @escaping (_ error: ApiError?) -> Void) {
        
        RestClient.getAPIResponse(Router.onBoardingRouterHandler(OnBoardRouterProtocol.postLogin(PostLogin(params: params))), successCompletionHandler: { (response) in
           
            if let apiResponse = Mapper<LoginUserResponse>().map(JSONObject: RestClient.getResultValue(response)) {
                print("Response",apiResponse)
//                let currentUser = apiResponse.response?.userData
////                if apiResponse.response?.isProfileComplete ?? false  && currentUser != nil{
//                if currentUser != nil{
//                    SessionDetails.getInstance().saveCurrentUser(user: currentUser!)
//                }
                successCompletionHandler(apiResponse)
            }
            
        }) { (error) in
            errorCompletionHandler(error)
        }
    }

    
 
}
