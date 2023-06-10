//
//  UploadFileRouter.swift
//  bms
//
//  Created by Sahil Ratnani on 10/06/23.
//

import Foundation
import Alamofire
import ObjectMapper

enum UploadFileRouterProtocol: RouterProtocol {
    case uploadImage(APIRequestModel)

    var path: String{
        switch self {
        case .uploadImage(_):
            return "DOC/UploadDoc"
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
        case .uploadImage(let body):
            return body
        }
    }
    
    var header: Any? {
        switch self {
        default:
            return nil
        }
    }

    var formData: [String: Any]? {
        switch self {
        case .uploadImage(let body as APIRequestBody):
            return ["req": Mapper().toJSONString(body) ?? ""]
        }
    }
}


class UploadFileRequestModel: APIRequestBody {
    typealias Review = [String: Any]

    lazy var authId = SessionDetails.getInstance().currentUser?.profile?.authId
    var inspectionAssignId: Int?
    var secno: String?
    var fileName: String?
    var fileType: String?

    enum ResponseKeys :String{
        case authId  = "authid"
        case inspectionAssignId = "inspectionassignid"
        case secno = "secno"
        case fileName = "filename"
        case fileType = "filetype"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.authId              <- map[ResponseKeys.authId.rawValue]
        self.inspectionAssignId <- map[ResponseKeys.inspectionAssignId.rawValue]
        self.secno <- map[ResponseKeys.secno.rawValue]
        self.fileName <- map[ResponseKeys.fileName.rawValue]
        self.fileType <- map[ResponseKeys.fileType.rawValue]
    }
}

class UploadFileRouterManager {
    func uploadImage( params: [String: Any],
                      imageData: Data,
                       successCompletionHandler: @escaping (_ response: APIResponseModel) -> Void,
                       errorCompletionHandler: @escaping (_ error: ApiError?) -> Void) {
        RestClient.upload(.uploadImage(APIRequestModel(params: params)), imageData: imageData,
         successCompletionHandler: { (response) in
            
            if let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response))  {
                successCompletionHandler(apiResponse)
            }
            
        }) { (error) in
            errorCompletionHandler(error)
        }
    }
}
