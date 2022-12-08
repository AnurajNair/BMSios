//
//  Router.swift
//  bms
//
//  Created by Naveed on 16/10/22.
//

import Foundation
import Alamofire
import ObjectMapper

/**
 *  Base router which has list of all the router that will be used to make network call
 *  throughout the app.
 */
enum Router: URLRequestConvertible {
    
    // Custom variable defined in build.
    case commonRouterHandler(CommonRouterProtocol)
    case inspectionRouterHandler(InspectionRouterProtocol)
   case onBoardingRouterHandler(OnBoardRouterProtocol)
//    case profileRouterHandler(ProfileRouterProtocol , Bool)
//    case placeRouterHandler(PlaceRouterProtocol ,Bool)
//    case planRouterHandler(PlanRouterProtocol ,Bool)
//    case trackingRouterHandler(TrackingRouterProtocol , Bool)
//    case settingsRouterHandler(SettingsRouterProtocol , Bool)
//    case dashboardRouterHandler(DashboardRouterProtocol , Bool)
    
    
    func asURLRequest() throws -> URLRequest {
        switch self {
        case .commonRouterHandler(let request):
            let urlRequest = configureRequest(request)
            return urlRequest
        case .inspectionRouterHandler(let request):
            let urlRequest = configureRequest(request)
            return urlRequest
        case .onBoardingRouterHandler(let request):
            let urlRequest = configureRequest(request)
            return urlRequest
//        case .onBoardingRouterHandler(let request):
//            let urlRequest = configureRequest(request)
//            return urlRequest
//        case .profileRouterHandler(let request , let isVersioned):
//            let urlRequest = configureRequest(request,isVersioned:  isVersioned)
//            return urlRequest
//        case .placeRouterHandler(let request ,let isVersioned):
//            let urlRequest = configureRequest(request ,isVersioned:  isVersioned)
//            return urlRequest
//        case .planRouterHandler(let request ,let isVersioned):
//            let urlRequest = configureRequest(request ,isVersioned:  isVersioned)
//            return urlRequest
//        case .trackingRouterHandler(let request , let isVersioned):
//            let urlRequest = configureRequest(request , isVersioned : isVersioned)
//            return urlRequest
//        case .settingsRouterHandler(let request , let isVersioned):
//            let urlRequest = configureRequest(request , isVersioned : isVersioned)
//            return urlRequest
//        case .dashboardRouterHandler(let request , let isVersioned):
//            let urlRequest = configureRequest(request , isVersioned : isVersioned)
//            return urlRequest
        }
    }
    
    
    
    /**
     Configure app level request object.
     - Set request path
     - Set request method
     - Set Headers [Authorization, Accept, Content-Type]
     - Set request body
     - set request parameters
     
     - parameter requestObj: Router of type RouterProtocol
     
     - returns: NSMutableURLRequest object
     */
    
    func configureRequest(_ requestObj: RouterProtocol) -> URLRequest {
        
        
        var parameters:[String:Any] = [:]
        
        var headers:[String:Any] = [:]
        
        if let value = requestObj.parameters as? APIRequestBody {
            parameters = Mapper().toJSON(value)
        }
            
        else if let value = requestObj.parameters as? RequestBody {
            parameters = Mapper().toJSON(value)
        }
        
        if let value = requestObj.header as? APIRequestBody {
            headers = Mapper().toJSON(value)
        }
            
        else if let value = requestObj.header as? RequestBody {
            headers = Mapper().toJSON(value)
        }
        
        var  mutableURLRequest = getUrlRequestWithHeaders(requestObj.method.rawValue, path: requestObj.path, parameters: headers )
        
        // Check if Request has Body defined
        
        if requestObj.method == Alamofire.HTTPMethod.post || requestObj.method == Alamofire.HTTPMethod.delete {
            // Request type is post/put -> check for request body
            
            var body:[String:Any] = [:]
            
            if let value = requestObj.body as? APIRequestBody {
                body = Mapper().toJSON(value)
            }
                
            else if let value = requestObj.body as? RequestBody {
                body = Mapper().toJSON(value)
            }
            
            if body.count > 0 {
                
                do {
                    mutableURLRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
                } catch {
                    // No-op
                }
                
            }
            
        }
        
        // Check if Request has parameters defined
        
        if parameters.count > 0 {
            
            print("\(parameters)")
            
            do{
                
                if requestObj.method == Alamofire.HTTPMethod.get {
                    return try Alamofire.URLEncoding.default.encode(mutableURLRequest as URLRequestConvertible, with: parameters)
                }
                
                return try Alamofire.JSONEncoding.default.encode(mutableURLRequest as URLRequestConvertible, with: parameters)
            }
            catch{
                print(error)
            }
            
        }
        
        return mutableURLRequest
    }
    
    func getBaseUrl() -> String {
        
        let appUrl =  APIConstants.apiBaseUrl
        return appUrl
    }
    
    
    /**
     
     Checks for the auth token stored in the persitent storage and assign to the headers of the NSURLRequest
     
     - parameter mutableURLRequest: NSMutableRequest for which authorization needs to be set
     */
    func getUrlRequestWithHeaders(_ httpMethod: String, path: String, parameters:[String:Any] = [:] ) -> URLRequest {
        
        let url = URL(string: getBaseUrl())!
        
        var mutableURLRequest = URLRequest(url: url.appendingPathComponent(path)) // Set request path
        mutableURLRequest.httpMethod = httpMethod // Set request method
        
        mutableURLRequest.setValue("application/json", forHTTPHeaderField:"Accept")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
        mutableURLRequest.timeoutInterval = Constants.serverTimeoutInterval
        
        let headers = Router.getAuthorizationHeaders()
        
        for header in headers {
            mutableURLRequest.setValue(header.value, forHTTPHeaderField: header.HTTPHeaderField)
        }
        
        if parameters.count > 0 {
            for parameter in parameters {
                mutableURLRequest.setValue(parameter.value as? String, forHTTPHeaderField: parameter.key)
            }
        }
        
        return mutableURLRequest
    }
    
    static func getAuthorizationHeaders() -> [(value: String, HTTPHeaderField: String)] {
        
        var data:[(value: String, HTTPHeaderField: String)] = []
        
        if SessionDetails.isTokenPresent() {
            data.append((value: SessionDetails.getInstance().accessToken!, HTTPHeaderField: "x-auth-token"))
        }
        
        return data
        
    }
    
}

// MARK: - Alamofire request extension
//  - Add debugLog method which logs request
extension Request {
    public func debugLog() -> Self {
        
        print("===============")
        print(self)
        print("Headers ---> ")
        print(self.request!.allHTTPHeaderFields as Any)
        print("Body ---> ")
        if let requestBody = self.request?.httpBody {
            print(NSString(data: requestBody, encoding: String.Encoding.utf8.rawValue) as Any)
        }
        print("===============")
        
        return self
    }
}
