//
//  CommonRouter.swift
//  bms
//
//  Created by Naveed on 17/10/22.
//

import Foundation
import Alamofire
import ObjectMapper
import RealmSwift

typealias APISuccessHandler =  (_ response: APIResponseModel) -> Void
typealias APIFailureHandler = (_ response: ApiError?) -> Void

enum CommonRouterProtocol: RouterProtocol {
    
    
    case syncContacts(SyncContactsRequestKeys)
    case upsertGroup
  
    case getGroups(GetRecentFriendsRequestKeys)
    case upsertToken(SyncToken)
    case getProjectMaster(APIRequestModel)
    case getBridgeFromProjectId(APIRequestModel)
    case getBridgeMaster(APIRequestModel)
    case getAllMasters(APIRequestModel)
    case getAddOnBridgeMaster(APIRequestModel)

    var path: String {
        switch self {
        case .syncContacts(_):
            return "syncContacts"
        case .upsertGroup:
            return "upsertGroup"
      
        case .getGroups(_):
            return "getGroups"
        case .upsertToken(_):
            return "upsertToken"

        case .getProjectMaster(_):
            return "Masters/ProjectSummary"

        case.getBridgeFromProjectId(_):
            return "Masters/BridgeFromProjectid"

        case.getBridgeMaster(_):
            return "Bridge/BridgeSummary"

        case.getAllMasters(_):
            return "Masters/AllMasters"

        case.getAddOnBridgeMaster(_):
            return "Masters/AddOnBridgeMasters"

        }
    }
    
    var method: HTTPMethod {
        switch self {
            
        case .syncContacts(_) ,.upsertGroup,.upsertToken(_), .getProjectMaster(_), .getBridgeFromProjectId(_), .getBridgeMaster(_), .getAllMasters(_), .getAddOnBridgeMaster(_):
            return .post
            
        case  .getGroups(_):
            return .get
        }
    }
    
    var parameters: Any? {
        switch self {
        default:
            return nil
        }
    }
    
    var body: Any? {
        switch self {
        case .syncContacts(let body):
            return body
        case .upsertToken(let body):
            return body
        case .getProjectMaster(let body):
            return body
        case .getBridgeFromProjectId(let body):
            return body
        case .getBridgeMaster(let body):
            return body
        case .getAllMasters(let body):
            return body
        case .getAddOnBridgeMaster(let body):
            return body
        default:
            return nil
        }
    }
    
    var header: Any? {
        switch self{
        case .getGroups(let headers):
            return headers
        default :
            return nil
        }
        
    }
    
  
    
}

class SyncToken : APIRequestBody{
    var userId: String?
    var phoneNumber : String?
    var token : String?
    var osType : String?
    
    enum RequestKeys : String{
        case userId  = "user_id"
        case phoneNumber  = "phone_number"
        case token = "token"
        case osType = "os_type"
        
    }
    
    init(params: [String: Any]) {
        super.init()
        self.userId  = params[RequestKeys.userId.rawValue] as? String
        self.phoneNumber  = params[RequestKeys.phoneNumber.rawValue] as? String
        self.token  = params[RequestKeys.token.rawValue] as? String
        self.osType = params[RequestKeys.osType.rawValue] as? String
    }
    
    required init?(map: ObjectMapper.Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.userId  <- map[RequestKeys.userId.rawValue]
        self.phoneNumber  <- map[RequestKeys.phoneNumber.rawValue]
        self.token  <- map[RequestKeys.token.rawValue]
        self.osType <- map[RequestKeys.osType.rawValue]
    }
}

class GetRecentFriendsRequestKeys: APIRequestBody {
    var userId: String?
    
    enum RequestKeys : String{
        case userId  = "user_id"
    }
    
    init(params: [String: Any]) {
        super.init()
        self.userId  = params[RequestKeys.userId.rawValue] as? String
    }
    
    required init?(map: ObjectMapper.Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.userId  <- map[RequestKeys.userId.rawValue]
    }
}


class SyncContactsRequestKeys: APIRequestBody {
    var contacts: [String]?
    
    enum RequestKeys : String{
        case contacts  = "contacts"
    }
    
    init(params: [String: Any]) {
        super.init()
        self.contacts  = params[RequestKeys.contacts.rawValue] as? [String]
    }
    
    required init?(map: ObjectMapper.Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.contacts  <- map[RequestKeys.contacts.rawValue]
    }
}

class GetAddGroupRequestKeys: APIRequestBody {
    var groupId: String?
    var groupName: String?
    var members: [String]?
    var createdBy: String?
    
    enum RequestKeys : String{
        case groupId  = "group_id"
        case groupName  = "group_name"
        case members  = "members"
        case createdBy  = "created_by"
    }
    
    init(params: [String: Any]) {
        super.init()
        self.groupId  = params[RequestKeys.groupId.rawValue] as? String
        self.groupName  = params[RequestKeys.groupName.rawValue] as? String
        self.members  = params[RequestKeys.members.rawValue] as? [String]
        self.createdBy  = params[RequestKeys.createdBy.rawValue] as? String
    }
    
    required init?(map: ObjectMapper.Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.groupId        <- map[RequestKeys.groupId.rawValue]
        self.groupName        <- map[RequestKeys.groupName.rawValue]
        self.members        <- map[RequestKeys.members.rawValue]
        self.createdBy        <- map[RequestKeys.createdBy.rawValue]
    }
}

class GetProjectMasterRequestKeys: APIRequestBody {
    var authId:String?
    
    enum ResponseKeys :String{
        case authId  = "authid"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
    }
}

class BridgeFromProjectIDRequestKeys: APIRequestBody {
    var authId:String?
    var projectId: Int = 0
    enum ResponseKeys :String{
        case authId  = "authid"
        case projectId = "projectid"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.projectId              <- map[ResponseKeys.projectId.rawValue]
    }
}

class MastersRequestKeys: APIRequestBody {
    var authId:String? = SessionDetails.getInstance().currentUser?.profile?.authId
    enum ResponseKeys :String{
        case authId  = "authid"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
    }
}

class CommonRouterManager {
    func performCommonApiCall(api: CommonRouterProtocol,
                        successCompletionHandler: @escaping APISuccessHandler,
                              errorCompletionHandler: @escaping APIFailureHandler) {
        RestClient.getAPIResponse(Router.commonRouterHandler(api)) { (response) in
            if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response)) {
                successCompletionHandler(apiResponse)
            }
        } errorCompletionHandler: { (error) in
            errorCompletionHandler(error)
        }
    }

    func getProjectMaster(params : [String: Any],
                          successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                          errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
        RestClient.getAPIResponse(Router.commonRouterHandler( CommonRouterProtocol.getProjectMaster(APIRequestModel(params: params))), successCompletionHandler: { (response) in
            
            if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response))  {
                successCompletionHandler(apiResponse)
            }
        }) { (error) in
            errorCompletionHandler(error)
        }
    }

    func getBridgeFromProjectId(params : [String: Any],
                           successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                           errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
         RestClient.getAPIResponse(Router.commonRouterHandler( CommonRouterProtocol.getBridgeFromProjectId(APIRequestModel(params: params))), successCompletionHandler: { (response) in
             
             if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response))  {
                 successCompletionHandler(apiResponse)
             }
         }) { (error) in
             errorCompletionHandler(error)
         }
     }

    func getBridgeMaster(params : [String: Any],
                         successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                         errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
         RestClient.getAPIResponse(Router.commonRouterHandler( CommonRouterProtocol.getBridgeMaster(APIRequestModel(params: params))), successCompletionHandler: { (response) in
             
             if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response))  {
                 successCompletionHandler(apiResponse)
             }
         }) { (error) in
             errorCompletionHandler(error)
         }
     }

    func getAllMasters(params : [String: Any],
                       successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                       errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
         RestClient.getAPIResponse(Router.commonRouterHandler( CommonRouterProtocol.getAllMasters(APIRequestModel(params: params))), successCompletionHandler: { (response) in
             
             if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response))  {
                 successCompletionHandler(apiResponse)
             }
         }) { (error) in
             errorCompletionHandler(error)
         }
     }

    func getAddOnBridgeMasters(params : [String: Any],
                       successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                       errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
        
        performCommonApiCall(api: .getAddOnBridgeMaster(APIRequestModel(params: params)), successCompletionHandler: successCompletionHandler, errorCompletionHandler: errorCompletionHandler)
    }
//    func syncContacts(params : SyncContactsRequestKeys,
//                      successCompletionHandler: @escaping (_ response: ContactsResponse) -> Void,
//                      errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
//        RestClient.getAPIResponse(Router.commonRouterHandler(CommonRouterProtocol.syncContacts(params), false), successCompletionHandler: { response in
//            if let apiResponse = Mapper<ContactsResponse>().map(JSONObject: RestClient.getResultValue(response)) {
//                //if apiResponse.status == 200 {
//                BaseModelManager.delete(ContactsResponse.self)
//
//
//                apiResponse.response?.syncContacts.sort(by: { (first, second) -> Bool in
//                    if let firstName = first.fullName, let seconsName = second.fullName{
//                        return firstName.lowercased() < seconsName.lowercased()
//                    }else{
//                        return false
//                    }
//                })
//
//                BaseModelManager.commitChange(apiResponse,update: false)
//                successCompletionHandler(apiResponse)
//                //                }else{
//                //                    errorCompletionHandler(ApiError())
//                //                }
//            }
//        }) { error in
//            errorCompletionHandler(error)
//        }
//    }
    
   
    
//    func addGroup(image : UIImage , compressionQuality: CGFloat = 0.4 , user : GetAddGroupRequestKeys, fileName : String ,successCompletionHandler: @escaping (_ response: ApiSuccess) -> Void,
//                  errorCompletionHandler: @escaping (_ error: ApiError?) -> Void) {
//
//        guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
//            print("Could not get JPEG representation of UIImage")
//            errorCompletionHandler(ApiError())
//            return
//        }
//
//        let parameters: [String : Any] = ["group_data" : user]
//
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            multipartFormData.append(imageData, withName: "group_image", fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
//
//            for (key, value) in parameters {
//                multipartFormData.append(((value as? GetAddGroupRequestKeys)?.toJSONString() ?? "").data(using: String.Encoding.utf8)!, withName: key as String)
//            }
//
//        }, with: Router.commonRouterHandler(CommonRouterProtocol.upsertGroup,false)) { (result) in
//            switch result {
//
//            case .success(let request, _, _):
//                request.uploadProgress(closure: { (progress) in
//                    debugPrint(progress)
//                })
//                request.responseJSON(completionHandler: { (response) in
//                    debugPrint(response.result)
//                    if let apiResponse = Mapper<ApiSuccess>().map(JSONObject: RestClient.getResultValue(response)) {
//                        successCompletionHandler(apiResponse)
//                    }
//                })
//            case .failure( _):
//                errorCompletionHandler(ApiError())
//            }
//        }
//    }
//
//    func getGroups(successCompletionHandler: @escaping (_ response: GroupsResponse) -> Void,errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
//
//        let params : [String : Any] = [GetRecentFriendsRequestKeys.RequestKeys.userId.rawValue : SessionDetails.getInstance().currentUser?.userId ?? ""]
//        RestClient.getAPIResponse(Router.commonRouterHandler(CommonRouterProtocol.getGroups(GetRecentFriendsRequestKeys(params: params)), false), successCompletionHandler: { response in
//            if let apiResponse = Mapper<GroupsResponse>().map(JSONObject: RestClient.getResultValue(response)) {
//                successCompletionHandler(apiResponse)
//            }
//        }) { error in
//            errorCompletionHandler(error)
//        }
//    }
//
//    func upsertToken(token : String ,successCompletionHandler: @escaping (_ response: ApiSuccess) -> Void,errorCompletionHandler: @escaping (_ response: ApiError?) -> Void) {
//
//        var params = [String : Any]()
//            params[SyncToken.RequestKeys.userId.rawValue] = SessionDetails.getInstance().currentUser?.userId ?? ""
//        params[SyncToken.RequestKeys.phoneNumber.rawValue] = SessionDetails.getInstance().currentUser?.phone ?? ""
//        params[SyncToken.RequestKeys.token.rawValue] = token
//        params[SyncToken.RequestKeys.osType.rawValue] = Constants.osType
//        RestClient.getAPIResponse(Router.commonRouterHandler(CommonRouterProtocol.upsertToken(SyncToken(params: params)), true),isBackgroundCall : true, successCompletionHandler: { response in
//            if let apiResponse = Mapper<ApiSuccess>().map(JSONObject: RestClient.getResultValue(response)) {
//                successCompletionHandler(apiResponse)
//            }
//        }) { error in
//            errorCompletionHandler(error)
//        }
//    }
    
    
}
