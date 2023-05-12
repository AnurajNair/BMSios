//
//  Step1Form.swift
//  bms
//
//  Created by Sahil Ratnani on 07/04/23.
//

import Foundation
import UIKit
import ObjectMapper
import RealmSwift

class Step1Form: NSObject, StepperTableViewCellFormProtocol {
    private let itemsPerRow: CGFloat = 3
    var formData: Inventory
    private var collectionView: UICollectionView?
    private var projects: [Project] = [] {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 1, section: 0)])
        }
    }
    private var bridges: [Bridge] = [] {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 2, section: 0)])
        }
    }

    private lazy var typeMasters: BridgePropertiesMaster? = {
        DataStore.shared.getMasters()
    }()

    init(formData: Inventory) {
        self.formData = formData
        super.init()
        getProjects()
    }

    func populate(collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension Step1Form {
    func getProjects() {
        CommonRouterManager().getProjectMaster(params: getParams()) { response in
            if(response.status == 0){
                if(response.response != ""){
                    if let projects = Mapper<ProjectList>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.projects = projects.projectList.map { $0 } as [Project]
                    }
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }

    }

    func getParams() -> [String : Any] {
        var params = [String : Any]()
        params[APIRequestModel.RequestKeys.requestdata.rawValue] = encryptReq()
        return params

    }

    func encryptReq() -> String {
        let obj = GetProjectMasterRequestKeys()
        obj.authId = SessionDetails.getInstance().currentUser?.profile?.authId
        
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        let encrypRequest = Utils().encryptData(json: jsonString! )
       return encrypRequest
    }
}

extension Step1Form: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        17
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCollectionViewCell.identifier, for: indexPath) as? FormCollectionViewCell else {
            fatalError("Could not load cell")
        }
        let fieldNo = indexPath.row
        switch fieldNo {
        case 0:
            cell.collectionFormElement.setupSwitcher(id: fieldNo, isOn: formData.statusIsActive, onValue: "Status", offValue: "Status")

        case 1:
            var options: [DropDownModel] = []
            projects.forEach { project in
                guard project.status == Status.active.rawValue else {
                    return
                }
                let option = DropDownModel(id: project.id, name: project.name ?? "")
                options.append(option)
            }
            let selectedIndex = options.firstIndex {
                guard let id = $0.id as? Int else {
                    return false
                }
                return id == formData.projectId
            }
            if selectedIndex != nil {
                getBridgesForProject(id: formData.projectId)
            }
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Project Id", options: options, placeHolder: "Project Id", selectedIndex: selectedIndex)

        case 2:
            var options: [DropDownModel] = []
            bridges.forEach { bridge in
                let option = DropDownModel(id: bridge.id, name: bridge.name ?? "")
                options.append(option)
            }
            let selectedIndex = options.firstIndex {
                guard let id = $0.id as? Int else {
                    return false
                }
                return id == formData.bridgeId
            }
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "BUID", options: options , placeHolder: "BUID", selectedIndex: selectedIndex)

        case 3:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfFoundation ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfFoundation }
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Foundation", options: options , placeHolder: "Type of Foundation", selectedIndex: selectedIndex)

        case 4:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfSubStructure ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfSubstructure }

            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Sub-Structure", options: options , placeHolder: "Type of Sub-Structure", selectedIndex: selectedIndex)
        
        case 5:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfSuperStructure ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfSuperstructure }
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Super-Structure", options: options , placeHolder: "Type of Super-Structure", selectedIndex: selectedIndex)

        case 6:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfBearing ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfBearing }

            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Bearing", options: options , placeHolder: "Type of Bearing", selectedIndex: selectedIndex)
        
        case 7:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfExpansionJoint ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfExpansionJoint}

            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Expansion Joint", options: options , placeHolder: "Type of Expansion Joint", selectedIndex: selectedIndex)
        
        case 8:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfWearingCoarse ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfWearingCoars}
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Wearing Coars", options: options, placeHolder: "Type of Wearing Coars", selectedIndex: selectedIndex)
        
        case 9:
            let options = getDropDownOptionsFrom(list: typeMasters?.typeOfRailing ?? List())
            let selectedIndex = options.firstIndex { $0.id as? Int == formData.data?.typeOfRailing}
            cell.collectionFormElement.setupDropdownField(id: fieldNo, fieldTitle: "Type of Railing", options: options , placeHolder: "Type of Railing", selectedIndex: selectedIndex)
        case 10:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "No. of Span", showFieldTitleByDefault: false, placeholderTitle: "No. of Span", fieldValue: formData.data?.noOfSpan?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 11:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "Length of Span", showFieldTitleByDefault: false, placeholderTitle: "Length of Span", fieldValue: formData.data?.lengthOfSpan?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 12:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "Width of Span", showFieldTitleByDefault: false, placeholderTitle: "Width of Span", fieldValue: formData.data?.widthOfSpan?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 13:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "no of main grider in a Span", showFieldTitleByDefault: false, placeholderTitle: "no of main grider in a Span", fieldValue: formData.data?.noOfMainGirderInASpan?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)
        
        case 14:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "no of bearing in span", showFieldTitleByDefault: false, placeholderTitle: "no of bearing in span", fieldValue: formData.data?.noOfBearingInSpan?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)

        case 15:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "no of pile", showFieldTitleByDefault: false, placeholderTitle: "no of pile", fieldValue: formData.data?.noOfPile?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)
        
        case 16:
            _ = cell.collectionFormElement.setupTextField(id: fieldNo, fieldTitle: "dia of pile", showFieldTitleByDefault: false, placeholderTitle: "dia of pile", fieldValue: formData.data?.diaOfPile?.description ?? "", textFieldStyling: TTTextFieldStyler.blueStyle)
        
        
        default:
            break
        }
        cell.collectionFormElement.delegate = self
        return cell
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
    
}

extension Step1Form: UICollectionViewDelegate {
}

extension Step1Form: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 2
        let paddingSpace: CGFloat = 5*(itemsPerRow+1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem.rounded(.down), height: 70)
    }
}

extension Step1Form: ReusableFormElementViewDelegate {
    func setValues(index: Any, item: Any) {
        switch index as? Int {
        case 0:
            guard let item = item as? Bool else {
                return
            }
            formData.status = (item == true) ? Status.active.rawValue : Status.inActive.rawValue

        case 1:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.projectId = id
            getBridgesForProject(id: id)
        case 2:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.bridgeId = id

        case 3:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfFoundation = id

        case 4:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfSubstructure = id

        case 5:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfSuperstructure = id

        case 6:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfBearing = id
        
        case 7:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfExpansionJoint = id
        
        case 8:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfWearingCoars = id
        
        case 9:
            guard let option = (item as? DropDownModel), let id = option.id as? Int else {
                return
            }
            formData.data?.typeOfRailing = id
        
        case 10:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfSpan = intValue
            formData.data?.setPMCMortarTotalAreaOfBottomOfMainGirder()
            formData.data?.setPMCMortarTotalAreaOfSideOfMainGirder()
            formData.data?.setPMCMortarTotalAreaOfTopSlabInterior()
            formData.data?.setPMCMortarTotalAreaOfTopSlabCantilever()
            formData.data?.setTotalNoOfWaterSprout()
            formData.data?.railingAndKerbBeam?.noOfSpan = intValue
            formData.data?.expansionJoint?.noOfJoints = intValue+1

        case 11:
            guard let value = (item as? String), let floatValue = Float(value) else {
                return
            }
            formData.data?.lengthOfSpan = floatValue
            formData.data?.setMainGirderAreaOfBottom()
            formData.data?.setMainGirderAreaOfSide()
            formData.data?.setTopSlabInteriorArea()
            formData.data?.setTopSlabCantileverArea()
            formData.data?.railingAndKerbBeam?.length = floatValue
            formData.data?.expansionJoint?.length = floatValue+1
            formData.data?.setAreaOfDismantlingOfRcc()
        case 12:
            guard let value = (item as? String), let intValue = Float(value) else {
                return
            }
            formData.data?.widthOfSpan = intValue
            formData.data?.setAreaOfDismantlingOfRcc()

        case 13:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfMainGirderInASpan = intValue
            formData.data?.setPMCMortarTotalAreaOfBottomOfMainGirder()
            formData.data?.setPMCMortarTotalAreaOfSideOfMainGirder()
            formData.data?.setPMCMortarTotalAreaOfTopSlabInterior()

        case 14:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfBearingInSpan = intValue

        case 15:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.noOfPile = intValue

        case 16:
            guard let value = (item as? String), let intValue = Int(value) else {
                return
            }
            formData.data?.diaOfPile = intValue

        default:
            break
        }
    }

    func setError(index: Any, error: String) {
        print("Error occured in \(self.description) - \(error)")
    }
}


extension Step1Form {
    func getBridgesForProject(id: Int) {
        CommonRouterManager().getBridgeFromProjectId(params: getParamsForBridges(projectId: id)) { response in
            if(response.status == 0){
                if(response.response != ""){
                    if let bridges = Mapper<BridgeList>().map(JSONString: Utils().decryptData(encryptdata: response.response!)) {
                        self.bridges = bridges.bridgeList.map { $0 } as [Bridge]
                    }
                }else{
                    Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
                }
            } else {
                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }

    }

    func getParamsForBridges(projectId: Int) -> [String : Any] {
        var params = [String : Any]()
        params[APIRequestModel.RequestKeys.requestdata.rawValue] = encryptReq(projectId: projectId)
        return params

    }

    func encryptReq(projectId: Int) -> String {
        let obj = BridgeFromProjectIDRequestKeys()
        obj.authId = SessionDetails.getInstance().currentUser?.profile?.authId
        obj.projectId = projectId
        let jsonData = try! JSONSerialization.data(withJSONObject: Mapper().toJSON(obj),options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        let encrypRequest = Utils().encryptData(json: jsonString! )
       return encrypRequest
    }
}
