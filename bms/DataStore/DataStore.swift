//
//  DataStore.swift
//  bms
//
//  Created by Sahil Ratnani on 07/05/23.
//

import Foundation
import ObjectMapper

class DataStore {
    static let shared = DataStore()

    private var bridgePropertiesMaster: BridgePropertiesMaster?

    func getMasters() -> BridgePropertiesMaster? {
        guard let masters = bridgePropertiesMaster else {
            fetchAllPropertiesMaster()
            return nil
        }
        return masters
    }

    func fetchAllPropertiesMaster() {
        Utils.showLoadingInRootView()
        let requestModel = AllMastersRequestKeys()
        CommonRouterManager().getAllMasters(params: APIUtils.createAPIRequestParams(dataObject: requestModel)) { response in
            if(response.status == 0){
                if(response.response != ""){
                    if let masters = Mapper<BridgePropertiesMaster>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.bridgePropertiesMaster = masters
                    }
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
                Utils.hideLoadingInRootView()
            } else {
                Utils.hideLoadingInRootView()
                
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            Utils.hideLoadingInRootView()
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }
}
