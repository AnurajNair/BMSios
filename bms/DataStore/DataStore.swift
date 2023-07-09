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
        DispatchQueue.main.async {
            Utils.showLoadingInRootView()
        }
        let requestModel = MastersRequestKeys()
        CommonRouterManager().getAllMasters(params: APIUtils.createAPIRequestParams(dataObject: requestModel)) { response in
            DispatchQueue.main.async {
                Utils.hideLoadingInRootView()
            }
            if(response.status == 0){
                if(response.response != ""){
                    if let masters = Mapper<BridgePropertiesMaster>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.bridgePropertiesMaster = masters
                    }
                }else{
                    DispatchQueue.main.async {
                        Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                    }
                }
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            DispatchQueue.main.async {
                Utils.hideLoadingInRootView()
                print("error - \(String(describing: error))")
                Utils.displayAlert(title: "Error", message: "Something went wrong.")
            }
        }
    }
}
