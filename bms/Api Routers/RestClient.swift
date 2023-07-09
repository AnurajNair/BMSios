//
//  RestClient.swift
//  bms
//
//  Created by Naveed on 16/10/22.
//

import Foundation
import Alamofire
import ObjectMapper

class RestClient {
    
    static var currentRequest : Request?
    
    ///Indicates whether internet connection is availbale or not
    static var isConnected: Bool {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        if let isReachable = manager?.isReachable, isReachable {
            return true     //Internet Available
        }
        return false        //No Internet
    }
    
    /**
     Makes an API call and returns the response.
     - parameter router: Router Object containing API request with headers and params.
     - parameter isTokenRequired: Bool indicating whether token is needed to be passed or not while making a request.
     - parameter isBackgroundCall: Bool indicating whether call needs be made in the background.
     - parameter successCompletionHandler: Closure to be executed on API success.
     - parameter errorCompletionHandler: Closure to be executed on API failure.
     */
    class func getAPIResponse(_ router: URLRequestConvertible,
                              isTokenRequired: Bool = true,
                              isBackgroundCall: Bool = false,
                              successCompletionHandler : @escaping (_ res : Any) -> Void,
                              errorCompletionHandler : @escaping (_ error: ApiError?) -> Void ){
        
        //To be enabled when you want to send the user token with API Calls
        //SessionDetails.getUserToken(successCompletionHandler: {
        
        
        var manager = NetworkReachabilityManager(host: "www.apple.com")
        
        if !isConnected {
            ///Internet is not available; handle error
            handleUnknownError(manager: manager)
        }
        
        manager?.startListening{status in
            
            switch status {
            case .notReachable: handleUnknownError(manager: manager)
                
            case .unknown: handleUnknownError(manager: manager)
                
                
                
            default:
                manager?.stopListening()
                manager = nil
                
                print("resp")
                let (isVisible, viewController) = isUnknownErrorControllerVisible()
                
                if isVisible && viewController != nil {
                    viewController!.dismiss(animated: false, completion: {
                    })
                }
                
                
                //To be enabled when you want to send the user token with API Calls
//                SessionDetails.getUserToken(isTokenRequired: isTokenRequired, successCompletionHandler: {
                
//                AF.request(router).response { response in
//                    switch response.result {
//                              case .success(let value as Any):
//                        successCompletionHandler(response)
//                              case .failure(let error):
//                                print(error)
//
//                              default:
//                                  fatalError("received non-dictionary JSON response")
//                              }
//
//                }
                
                AF.request(router).responseJSON {
                    (response) in
                    print(response.result)
                    switch response.result {
                    case .success(let value):
                        print(value)
                        guard handleIfSessionExpired(response: value) == false else {
                            return
                        }
                        successCompletionHandler(value)

                    case .failure(let error):
                        print(error)
                        
                    default:
                        fatalError("received non-dictionary JSON response")
                    }
                    // print(String(data: response.data!, encoding: String.Encoding.utf8))
                    
                }
                
            
//           AF.request(router).validate(statusCode: 200..<300)
//                    .validate(contentType: ["application/json"]).responseDecodable(completionHandler: { response in
//                            print(response)
//                            // print(String(data: response.data!, encoding: String.Encoding.utf8))
//
//                            if response.result.failure {
//                                handleError(response,
//                                            isBackgroundCall: isBackgroundCall,
//                                            manager: manager,
//                                            successHandler:{
//                                                res in
//                                                successCompletionHandler(res)
//                                },
//                                            errorhandler:{error in
//                                                errorCompletionHandler(error)
//                                })
//                            } else {
//                                successCompletionHandler(response.result,response.result.failure)
//                            }
//                        })
                    
//                }) {
//
//                }
            }
        }
       // manager?.up()
        
    }

    class func upload(_ uploadRouter: UploadFileRouterProtocol,
                      imageData: Data,
                      isTokenRequired: Bool = true,
                      isBackgroundCall: Bool = false,
                      successCompletionHandler : @escaping (_ res : Any) -> Void,
                      errorCompletionHandler : @escaping (_ error: ApiError?) -> Void ){
        
        var manager = NetworkReachabilityManager(host: "www.apple.com")
        
        if !isConnected {
            ///Internet is not available; handle error
            handleUnknownError(manager: manager)
        }
        
        manager?.startListening { status in
            
            switch status {
            case .notReachable: handleUnknownError(manager: manager)
                
            case .unknown: handleUnknownError(manager: manager)
                
            default:
                manager?.stopListening()
                manager = nil
                
                print("resp")
                let (isVisible, viewController) = isUnknownErrorControllerVisible()
                
                if isVisible && viewController != nil {
                    viewController!.dismiss(animated: false, completion: {
                    })
                }
                let request = Router.uploadFileRouterHandler(uploadRouter)
                AF.upload(multipartFormData: { (multipartFormData) in
                    for (key, value) in uploadRouter.formData ?? [:] {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
                    multipartFormData.append(imageData, withName: "")
                }, with: request).response {
                    (response) in
                    print(response.result)
                    switch response.result {
                    case .success(let value):
                        do {
                            guard let value = value else {
                                fatalError("received non-dictionary JSON response")
                            }
                            guard handleIfSessionExpired(response: value) == false else {
                                return
                            }
                            let responseData = try JSONSerialization.jsonObject(with: value)
                            successCompletionHandler(responseData)
                        } catch {
                            fatalError("received non-dictionary JSON response")
                        }
                    case .failure(let error):
                        print(error)
                    }
                    // print(String(data: response.data!, encoding: String.Encoding.utf8))
                    
                }
            }
        }
    }

    private class func handleIfSessionExpired(response: Any) -> Bool {
        guard let apiResponse = Mapper<APIResponseModel>().map(JSONObject: RestClient.getResultValue(response)), apiResponse.status == 7 else {
            return false
        }
        SessionDetails.clearInstance()
        _ = Utils.displayAlertController("Error",
                                     message: apiResponse.message ?? "Invalid Session", isSingleBtn: true) {
            Navigate.routeUserToScreen(screenType: .loginScreen, transitionType: .root)
        } cancelclickHandler: {
            
        }

        return true
    }

    class func handleError(_ response: DataResponse<Any,Error>?,
                           isBackgroundCall: Bool = false,
                           manager: NetworkReachabilityManager?,
                           successHandler:(_ res: DataResponse<Any,Error>?) -> Void,
                           errorhandler:(_ error: ApiError?) -> Void) {
        
        let error: ApiError = getApiError(response)
        
        if let responseValue = response?.response {
            let statusCode = responseValue.statusCode
            
            /// - Note: If you want to know http status codes follow the link
            ///   https://developer.apple.com/documentation/applemusicapi/apple_music_api_objects/http_status_codes
            
            /// Successful Responses
            if (200...211).contains(statusCode) {
                successHandler(response)
            }
            
            /// Error Responses
            else {
                /// 401: Unauthorized Access (Token Error)
                if statusCode == 401 && error.cause == "Unauthenticated." {
                    SessionDetails.clearInstance()
                   // Navigate.routeUserToScreen(screenType: .enterEmail, transitionType: .root)
                }
                
                else if !isBackgroundCall {
                    /// 400: Bad Request
                    if (statusCode == 400 || statusCode == 401) {
                        Utils.showApiErrorMessage(error)
                    }
                    
                    /// 429: Too Many Requests
                    else if statusCode == 429 {
                        handleUnknownError(manager: manager, errorData: EmptyStateViewStyler.tooManyAttemptsErrorMessageData)
                    }
                    
                    /// For all other status codes when API call is not made in the background
                    else {
                        handleServerError()
                    }
                }
            }
        } else {
            if !isBackgroundCall {
                handleServerError()
            }
        }
        
        errorhandler(error)
    }
    
    /**
     Checks given response to return containing error.
     - parameter response: API Response.
     - returns: ApiError object.
     */
    class func getApiError(_ response: DataResponse<Any,Error>?) -> ApiError {
        var error: ApiError = ApiError()
        if let data = response?.data {
            do {
                let errorObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                if ((errorObject as AnyObject).value(forKey: ApiError.ResponseKeys.message.rawValue) as? String) != nil {
                    error = Mapper<ApiError>().map(JSONObject: errorObject)!
                }
            } catch let error as NSError { print(error)}
        }
        return error
    }
    
    /**
     Checks whether Error Controller is presented and visible.
     - Returns: A tuple (Bool, UIViewController) - Unknown error controller if its topmost controller with visibility flag as true. Else if unknown error controller is not topmost controller then visibility falg is passed as false with view controller as nil. */
    class func isUnknownErrorControllerVisible() -> (Bool, UIViewController?) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let navigationController = appDelegate.window?.topMostWindowController() as? UINavigationController, navigationController.topViewController is UnknownErrorViewController {
            return (true, navigationController.topViewController)
        } else {
            return (false, nil)
        }
    }
    
    /// Displays Unknown error controller.
    ///
    /// - Parameters:
    ///   - manager: NetworkReachabilityManager instance which needs to be passed to unknown error controller.
    ///   - errorData: TTEmptyViewData object describing error
    class func handleUnknownError(manager: NetworkReachabilityManager? = nil,
                                  errorData: EmptyStateViewStyler.EmptyViewData? = nil) {
        let (isVisible, _ ) = isUnknownErrorControllerVisible()
        if !isVisible {
            
            var data:[String:Any] = [:]
            if let reachabilityManager = manager {
                data["manager"] = reachabilityManager
            }
            if let value = errorData {
                data["errorData"] = value
            }
            
            NavigationRoute.routeUserToScreen(screenType: .unknownError, transitionType: .modal, data: data)
        }
    }
    
    class func handleServerError() {
        Utils.displayAlert(title: "Error".localized(), message: "Seems like our servers are having a bad day. Try again shortly? If the problem persists, please try contacting us?".localized())
    }
    
    
    //MARK: Data Extraction Functions
    
    class func getResultValue(_ res : Any) -> Any {
        print("got it her")
        var data:Any = ""
        
        if let result = res as? Dictionary<String,Any> {
            if let value = result["data"] {
                data = value
            } else {
                data = result
            }
        }
        
        else if let result = res as? [Any] {
            data = result
        }
        
        return data

    }
    
    class func getMetaData(_ res: DataResponse<Any,Error>?, forKey: String) -> Any {
        var data:Any = ""
        if let result = res?.value as? Dictionary<String,Any> {
            if let value = result["meta"] {
                if let metaData = value as? Dictionary<String,Any>, let actualValue = metaData[forKey] {
                    data = actualValue
                } else {
                    data = value
                }
            } else {
                data = result
            }
        }
        return data
    }
}
