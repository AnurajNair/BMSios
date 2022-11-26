//
//  PopUpViewController.swift
//  bms
//
//  Created by Naveed on 16/11/22.
//

import UIKit
import ObjectMapper
import RealmSwift
import Alamofire

class PopUpViewController: UIViewController {
    
    var inspectionsList:[RoutineInspection] = []
    var json:Any = ""
    @IBOutlet weak var inspectionTypesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
    
        
    }
    
    func setupViews(){
//        self.getInspectionTemplates()
       // loadJson(filename: "InspectionsTemplates")
        self.setupTableView()
        getJSON()
      
    }
    
  
    
    
    func getInspectionTemplates(){
//        self.inspectionsList = loadJson(filename: "InspectionsTemplates")!.inspections!
//        print(loadJson(filename: "InspectionsTemplates")?.inspections)
//        print(inspectionsList)
        self.inspectionTypesTableView.reloadData()

    }
    
    func loadJson(filename fileName: String){
        var json :Any = ""
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try JSONSerialization.jsonObject(with: data) as? [String : Any]
                if let value = jsonData!["data"] {
                    json = value
                } else {
                    json = jsonData
                }
              
                let apiResponse:InspectionsTemplate = Mapper<InspectionsTemplate>().map(JSON: jsonData!)!
                print()
//                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
       
    }
    
    
    func getJSON(){
      
        let url = Bundle.main.url(forResource: "InspectionsTemplates", withExtension: "json")
        AF.request(URLRequest(url:url!)).responseJSON { response in
            switch response.result{
            case.success(let data ):
                print("JSON",data)
//                json = data as? Dictionary<String,Any>
//                let res = Mapper<InspectionsTemplate>().map(JSONObject:json)
                break
                
            case .failure(_): break
                
            }
           
        }
        
    }

    func setupTableView(){
        self.inspectionTypesTableView.separatorStyle = .none
        self.inspectionTypesTableView.delegate = self
        self.inspectionTypesTableView.dataSource = self
       
        self.inspectionTypesTableView.register(InspectionTemplateTypeTableViewCell.nib, forCellReuseIdentifier: InspectionTemplateTypeTableViewCell.identifier)
      
        self.inspectionTypesTableView.rowHeight = UITableView.automaticDimension
//        self.inspectionTypesTableView.estimatedRowHeight = 100
//        self.inspectionTypesTableView.backgroundColor = .clear
        
       
        
    }
    
    func onCheckBoxSelection(indexPath:IndexPath){
        let clickedCheckBox = self.inspectionsList[indexPath.row]
        let selection = clickedCheckBox.isSelected
       
       let cell = inspectionTypesTableView.cellForRow(at: indexPath) as! InspectionTemplateTypeTableViewCell
       
//       cell.select(!selection)
       
       for var insp in inspectionsList{
           if insp.inspection_id == clickedCheckBox.inspection_id {
               insp.isSelected = true
               break
           }
       }
        
        print(inspectionsList)
    }

}

extension PopUpViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCheckBoxSelection(indexPath: indexPath)
        
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        if  let cell = self.tableView(tableView, cellForRowAt: indexPath) as? InspectionTemplateTypeTableViewCell{
//            cell.inspectionTypeCheckboxView.delegate?.checkboxDeselected?(indexPath.row)
//        }
//    }
    
}

extension PopUpViewController:UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inspectionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InspectionTemplateTypeTableViewCell.identifier, for: indexPath) as? InspectionTemplateTypeTableViewCell else {
            fatalError("xib doesn't exist")
            
        }
        let section = self.inspectionsList[indexPath.row]
        
        cell.inspectionTypeCheckboxView.setupCheckboxField(id: indexPath.row, fieldLabel: section.inspection_name!, isSelectedByDefault: false, height: 44, isEditable: false, isUserInteractionEnabled: true)
        
        return cell
    }
    
   
    
    
}


