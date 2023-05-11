//
//  RegisterBridgeViewController.swift
//  bms
//
//  Created by Sahil Ratnani on 10/05/23.
//

import UIKit
import RealmSwift
import ObjectMapper

protocol RegisterBridgeViewControllerDelegate: AnyObject {
    func didRegisterSuccessfully(bridge: Bridge)
}

class RegisterBridgeViewController: UIViewController {

    @IBOutlet weak var bridgeNameTextField: ReusableFormTextField!
    @IBOutlet weak var projectNoDropDown: ReusableDropDown!
    @IBOutlet weak var alternateRouteDropDown: ReusableDropDown!
    @IBOutlet weak var chainageOfBridgeInMtrTxtField: ReusableFormTextField!
    @IBOutlet weak var chainageOfBridgeInKmTxtField: ReusableFormTextField!
    @IBOutlet weak var carriagewayFirstDgtDropDown: ReusableDropDown!
    @IBOutlet weak var carriagewaySecondDgtDropDown: ReusableDropDown!
    @IBOutlet weak var typeOfBridge: ReusableDropDown!
    @IBOutlet weak var foundationOfBridgeDropDown: ReusableDropDown!
    @IBOutlet weak var superstructureDropDown: ReusableDropDown!
    @IBOutlet weak var structureDropDown: ReusableDropDown!

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveAndContinueButton: UIButton!
    weak var delegate: RegisterBridgeViewControllerDelegate?

    var bridgeMaster: AddOnBridgeMaster? {
        didSet {
            self.setUpFields()
        }
    }

    var prjectOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.projects ?? List())
    }

    var alternativeRouteOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.alternativeRoute ?? List())
    }

    var carriageWayFirstDropDownOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.typeOfCarriageWayFirstDigit ?? List())
    }

    var carriageWaySecondDropDownOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.typeOfCarriageWaySecondDigit ?? List())
    }

    var typeOfBridgeOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.typeOfBridge ?? List())
    }

    var typeOfFoundationsOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.typeOfFoundation ?? List())
    }

    var typeOfSuperStructureOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.typeOfSuperStructure ?? List())
    }

    var typeOfStructureOptions: [DropDownModel] {
        getDropDownOptionsFrom(list: bridgeMaster?.typeOfStructure ?? List())
    }

    let textFieldStyle = TTTextFieldStyler.userDetailsStyle
    let dropDownStyle = TTDropDownStyle.borderedStyle
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        fetchAddOnBridgeMaster()
        
        setUpFields()
    }

    func setUpFields() {
        bridgeNameTextField.setupTextField(id: 1,
                                           placeholderTitle: "Bridge Name",
                                           textFieldStyling: textFieldStyle)
        chainageOfBridgeInMtrTxtField.setupTextField(id: 1,
                                                     placeholderTitle:
                                                        "Chainage of Bridge in meter",
                                                     textFieldStyling: textFieldStyle)
        chainageOfBridgeInKmTxtField.setupTextField(id: 1,
                                                    placeholderTitle: "Chainage Of Bridge in Kilo meter",
                                                    textFieldStyling: textFieldStyle)

        projectNoDropDown.setupDropDown(options: prjectOptions, placeHolder: "Project No", style: dropDownStyle)
        alternateRouteDropDown.setupDropDown(options: alternativeRouteOptions, placeHolder: "Alternate Route", style: dropDownStyle)
        carriagewayFirstDgtDropDown.setupDropDown(options: carriageWayFirstDropDownOptions, placeHolder: "Carriageway First Digit", style: dropDownStyle)
        carriagewaySecondDgtDropDown.setupDropDown(options: carriageWaySecondDropDownOptions, placeHolder: "Carriageway Second Digit", style: dropDownStyle)
        typeOfBridge.setupDropDown(options: typeOfBridgeOptions, placeHolder: "Type of Bridge", style: dropDownStyle)
        foundationOfBridgeDropDown.setupDropDown(options: typeOfFoundationsOptions, placeHolder: "Foundation of Bridge", style: dropDownStyle)
        superstructureDropDown.setupDropDown(options: typeOfSuperStructureOptions, placeHolder: "Type of Super Structure", style: dropDownStyle)
        structureDropDown.setupDropDown(options: typeOfStructureOptions, placeHolder: "Type of Structure", style: dropDownStyle)
    }

    func getDropDownOptionsFrom<T: BasicDetails>(list: List<T>) -> [DropDownModel]{
        let array = list.map { $0 } as [T]
        var options: [DropDownModel] = []
        array.forEach { item in
            let option = DropDownModel(id: item.id, name: item.name ?? "")
            options.append(option)
        }
        return options
    }
    @IBAction func saveAndContinueDidTap(_ sender: Any) {
       registerBridge()
    }
    @IBAction func cancelDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension RegisterBridgeViewController {
    func fetchAddOnBridgeMaster() {
        Utils.showLoadingInView(self.view)
        CommonRouterManager().getAddOnBridgeMasters(params: APIUtils.createAPIRequestParams(dataObject: MastersRequestKeys()) ) { response in
            Utils.hideLoadingInView(self.view)
            if(response.status == 0){
                if(response.response != ""){
                    if let bridge = Mapper<AddOnBridgeMaster>().map(JSONString:  Utils().decryptData(encryptdata: response.response!)) {
                        self.bridgeMaster = bridge
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

    func registerBridge() {
        guard let params = addOnBridgeParams() else {
            return
        }
        Utils.showLoadingInView(self.view)
        InspctionRouterManager().saveAddOnBridge(params: params) { response in
            Utils.hideLoadingInView(self.view)
            if(response.status == 0){
                if(response.response != "") {
                    if let bridge = Mapper<Bridge>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.delegate?.didRegisterSuccessfully(bridge: bridge)
                        self.dismiss(animated: true)
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

    func addOnBridgeParams() -> [String: Any]? {
        let bridge = AddOnBridgeRequestModel()
       guard let projectId = projectNoDropDown.selectedItem?.id as? Int,
             let bridgeName = bridgeNameTextField.text,
             let alternateRoute = alternateRouteDropDown.selectedItem?.id as? Int,
             let chainageKm = chainageOfBridgeInKmTxtField.text,
             let chainageMeter = chainageOfBridgeInMtrTxtField.text,
             let carriagewayFirst = carriagewayFirstDgtDropDown.selectedItem?.id as? Int,
             let carriagewaySecond = carriagewaySecondDgtDropDown.selectedItem?.id as? Int,
             let bridgeType = typeOfBridge.selectedItem?.id as? Int,
             let foundationType = foundationOfBridgeDropDown.selectedItem?.id as? Int,
             let superStructure = superstructureDropDown.selectedItem?.id as? Int,
             let structure = structureDropDown.selectedItem?.id as? Int else {
           return nil
       }
        bridge.projectId = projectId
        bridge.name = bridgeName
        bridge.alternateRoute = alternateRoute
        bridge.chainagekm = Int(chainageKm)
        bridge.chainagemet = Int(chainageMeter)
        bridge.carriageWayFirstDigit = carriagewayFirst
        bridge.carriageWaySecondDigit = carriagewaySecond
        bridge.bridgeType = bridgeType
        bridge.foundation = foundationType
        bridge.superStructure = superStructure
        bridge.structure = structure

        let param = APIUtils.createAPIRequestParams(dataObject: bridge)
        return param
    }
}
