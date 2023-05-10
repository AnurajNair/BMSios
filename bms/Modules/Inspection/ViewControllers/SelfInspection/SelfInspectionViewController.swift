//
//  SelfInspectionViewController.swift
//  bms
//
//  Created by Sahil Ratnani on 09/05/23.
//

import UIKit
import Foundation
import RealmSwift
import ObjectMapper

class SelfInspectionViewController: UIViewController {

    @IBOutlet weak var bridgeDropDown: ReusableDropDown!
    @IBOutlet weak var inspectionDropDown: ReusableDropDown!
    @IBOutlet weak var unregisteredButton: UIButton!
    @IBOutlet weak var startInspectionButton: UIButton!

    var dataStore = DataStore.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupDropDown()
        getBridges()
    }

    func setupView() {
        unregisteredButton.setAsRounded()
        startInspectionButton.setAsRounded()
    }

    func setupDropDown() {
        var options = [DropDownModel]()
        dataStore.bridges.forEach {
            let option = DropDownModel(id: $0.id, name: $0.name ?? "")
            options.append(option)
        }
        bridgeDropDown.setupDropDown(options: options, placeHolder: "Select Bridge", style: TTDropDownStyle.borderedStyle)
    }

    @IBAction func unregisteredDidTap(_ sender: Any) {
    }
    
    @IBAction func startInspectionDidTap(_ sender: UIButton) {
    }
}

extension SelfInspectionViewController {
    func getBridges() {
        Utils.showLoadingInView(self.view)
            CommonRouterManager().getBridgeMaster(params: APIUtils.createAPIRequestParams(dataObject: AllMastersRequestKeys())) { response in
                Utils.hideLoadingInView(self.view)

                if(response.status == 0){
                if(response.response != ""){
                    let responseJson = Utils.getJsonFromString(string: Utils().decryptData(encryptdata: response.response!))
                    if let bridgesArray =  responseJson?["bridgesummary"] as? [[String: Any]]{
                        var bridges: [Bridge] = []
                        bridgesArray.forEach { bridgeData in
                            if let bridge = Mapper<Bridge>().map(JSON: bridgeData) {
                                bridges.append(bridge)
                            }
                        }
                        self.dataStore.storeBridges(bridges)
                        self.setupDropDown()
                    }
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            Utils.hideLoadingInView(self.view)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }

    }
}
