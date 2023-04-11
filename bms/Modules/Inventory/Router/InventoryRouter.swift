//
//  InventoryRouter.swift
//  bms
//
//  Created by Sahil Ratnani on 10/04/23.
//

import Foundation
import Alamofire
import ObjectMapper

enum InventoryRouterProtocol: RouterProtocol {
    case invantoryList(PostInventoryListModel)

    var path: String {
        switch self {
        case .invantoryList(_):
            return "Inventory/InventorySummary"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .invantoryList(_):
            return .post
        }
    }
    
    var header: Any? {
        switch self {
        default:
            return nil
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
        case .invantoryList(let body):
            return body
        }
    }
}

class PostInventoryListModel: APIRequestBody {
    
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

class InventoryRouterManager {
    func getInventory( params: [String: Any],
                       successCompletionHandler: @escaping (_ response: InventoryListResponseModel) -> Void,
                       errorCompletionHandler: @escaping (_ error: ApiError?) -> Void){
            
            RestClient.getAPIResponse(Router.inventoryRouterHandler( InventoryRouterProtocol.invantoryList(PostInventoryListModel(params: params))), successCompletionHandler: { (response) in
                
                if let apiResponse = Mapper<InventoryListResponseModel>().map(JSONObject: RestClient.getResultValue(response))  {
                    successCompletionHandler(apiResponse)
                }
                
            }) { (error) in
                errorCompletionHandler(error)
            }
        }
}
