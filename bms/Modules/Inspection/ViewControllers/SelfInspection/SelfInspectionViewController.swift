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
    @IBOutlet weak var reviewerDropDown: ReusableDropDown!
    @IBOutlet weak var startInspectionButton: UIButton!

    var bridges: [Bridge] = [] {
        didSet {
            setupBridgeDropDown()
        }
    }

    var inspections: [InspectionSummary] = [] {
        didSet {
            setupInspectionDropDown()
        }
    }

    var reviewers: [Reviewer] = [] {
        didSet {
            setupReviewersDropDown()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBridgeDropDown()
        setupInspectionDropDown()
        getBridges()
        getInspectionSummary()
        getReviewers()
    }

    func setupView() {
        unregisteredButton.setAsRounded()
        startInspectionButton.setAsRounded()
    }

    func setupBridgeDropDown() {
        var options = [DropDownModel]()
        bridges.forEach {
            let option = DropDownModel(id: $0.id, name: $0.name ?? "")
            options.append(option)
        }
        bridgeDropDown.setupDropDown(options: options, placeHolder: "Select Bridge", style: TTDropDownStyle.borderedStyle)
    }

    func setupInspectionDropDown() {
        var options = [DropDownModel]()
        inspections.forEach {
            let option = DropDownModel(id: $0.id, name: $0.name ?? "")
            options.append(option)
        }
        inspectionDropDown.setupDropDown(options: options, placeHolder: "Select Inspection", style: TTDropDownStyle.borderedStyle)
    }

    func setupReviewersDropDown() {
        var options = [DropDownModel]()
        reviewers.forEach {
            let option = DropDownModel(id: $0.id, name: $0.name ?? "")
            options.append(option)
        }
        reviewerDropDown.setupDropDown(options: options, placeHolder: "Select Reviewer", style: TTDropDownStyle.borderedStyle)
    }

    @IBAction func unregisteredDidTap(_ sender: Any) {
        let delegateData = ["delegate": self]
        Navigate.routeUserToScreen(screenType: .registerBridge, transitionType: .modal, data: delegateData)
    }
    
    @IBAction func startInspectionDidTap(_ sender: UIButton) {
        assignAndStartInspection()
    }
}

extension SelfInspectionViewController {
    func getBridges() {
        Utils.showLoadingInView(self.view)
            CommonRouterManager().getBridgeMaster(params: APIUtils.createAPIRequestParams(dataObject: MastersRequestKeys())) { response in
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
                        self.bridges = bridges
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

    func getInspectionSummary() {
        Utils.showLoadingInView(self.view)
            InspctionRouterManager().getInspectionSummary(params: APIUtils.createAPIRequestParams(dataObject: MastersRequestKeys())) { response in
                Utils.hideLoadingInView(self.view)

                if(response.status == 0){
                if(response.response != ""){
                    let responseJson = Utils.getJsonFromString(string: Utils().decryptData(encryptdata: response.response!))
                    if let inspectionArray =  responseJson?["inspectionlist"] as? [[String: Any]]{
                        var inspections: [InspectionSummary] = []
                        inspectionArray.forEach { bridgeData in
                            if let bridge = Mapper<InspectionSummary>().map(JSON: bridgeData) {
                                inspections.append(bridge)
                            }
                        }
                        self.inspections = inspections
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

    func getReviewers() {
        Utils.showLoadingInView(self.view)
            InspctionRouterManager().getReviewers(params: APIUtils.createAPIRequestParams(dataObject: MastersRequestKeys())) { response in
                Utils.hideLoadingInView(self.view)

                if(response.status == 0){
                if(response.response != ""){
                    let responseJson = Utils.getJsonFromString(string: Utils().decryptData(encryptdata: response.response!))
                    if let reviewersArray =  responseJson?["reviewerlist"] as? [[String: Any]]{
                        var reviewers: [Reviewer] = []
                        reviewersArray.forEach { reviewer in
                            if let reviewer = Mapper<Reviewer>().map(JSON: reviewer) {
                                reviewers.append(reviewer)
                            }
                        }
                        self.reviewers = reviewers
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

    func assignAndStartInspection() {
        guard let params = getAssignInspectionParams() else {
            return
        }
        Utils.showLoadingInView(self.view)
        InspctionRouterManager().assignInspection(params: params) { response in
                Utils.hideLoadingInView(self.view)

                if(response.status == 0){
                if let response = response.response, let inspectionId = Int(response) {
                    self.prepareForInspection(inspectionId)
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

    func getAssignInspectionParams() -> APIRequestParams? {
        guard let userId = SessionDetails.getInstance().currentUser?.profile?.userId,
              let bridgeId = bridgeDropDown.selectedItem?.id as? Int,
              let inspectionId = inspectionDropDown.selectedItem?.id as? Int,
              let reviewerId = reviewerDropDown.selectedItem?.id as? Int else {
            return nil
        }
        let model = AssignInspectionRequestModel()
        model.mode = Mode.insert.rawValue
        model.bridgeId = bridgeId
        model.inspectionId = inspectionId
        model.inspector = [userId]
        model.reviewer = [reviewerId]

        return APIUtils.createAPIRequestParams(dataObject: model)
    }

    func prepareForInspection(_ inspectionId: Int) {
        InspctionRouterManager().getInspectionById(params: getInspectionByIdParams(inspectionId)) { response in
            Utils.hideLoadingInView(self.view)
            self.handleInspectionByIdSuccess(response: response)
        } errorCompletionHandler: { error in
            Utils.showLoadingInView(self.view)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }

    func handleInspectionByIdSuccess(response: APIResponseModel) {
        guard response.status == 0, response.response != "" else {
            Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            return
        }
        if let inspectionQues =  Mapper<InspectionQuestionnaire>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
            var data: [String: Any] = ["inspectionQues" : inspectionQues]
            data["inspectionType"] = InspectionType.inspect
            Navigate.routeUserToScreen(screenType: .routineInspbridgeDetailScreen,transitionType: .changeSlider,data: data)
        }
    }

    func getInspectionByIdParams(_ inspectionId: Int) -> APIRequestParams {
        let obj = InspectionByIdRequestModel()
        obj.inspectionId = inspectionId
        let params = APIUtils.createAPIRequestParams(dataObject: obj)
        return params
    }
}

extension SelfInspectionViewController: RegisterBridgeViewControllerDelegate {
    func didRegisterSuccessfully(bridge: Bridge) {
        bridges.insert(bridge, at: 0)
        setupView()
    }
}
