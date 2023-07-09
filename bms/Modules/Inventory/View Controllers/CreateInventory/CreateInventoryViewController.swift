//
//  CreateInventoryViewController.swift
//  bms
//
//  Created by Sahil Ratnani on 02/04/23.
//

import UIKit
import ObjectMapper

class CreateInventoryViewController: UIViewController {

    @IBOutlet weak var stepperTableView: UITableView!
    lazy var inventory: Inventory = Inventory(inventoryData: InventoryData())

    private var expandedSection: Int = 0
    let steps = ["Bridge Info", "Main Grider", "Total Slab (Interior)", "Total Slab (Cantilever Portion", "Cross Grider", "Low Viscosity Grout", "Polymer Modified Cement Grout", "Pier Cap", "PMC Mortar Treatment", "Water Sprout", "Ralling and Kreb Beam", "Expansion Joint", "Dismantling of RCC and Bituminous Wearing Coat", "Wrapping", "Microcncrete for repairing patch where large quantity of concrete is spalled out and loosening of remaining concrete at expansion joint", "Nipples for low viscosity polymer grout", "Nipples for Polymer modified cement grout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        stepperTableView.registerNib(StepperTableViewCell.identifier)
        stepperTableView.registerHeaderNibs([StepperTableHeaderView.identifier])
        stepperTableView.layoutIfNeeded()

        self.stepperTableView.rowHeight = UITableView.automaticDimension
        self.stepperTableView.estimatedRowHeight = 100
        self.stepperTableView.sectionFooterHeight = 0
        self.stepperTableView.sectionHeaderHeight = 0
    }
    
}

extension CreateInventoryViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        80
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.01
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StepperTableHeaderView.identifier) as? StepperTableHeaderView
        header?.configHeader(step: section+1, title: steps[section], isExpanded: expandedSection == section)
        header?.onHeaderTap = { [weak self] _ in
            self?.expandSection(section)
        }
        return header
    }

    func expandSection(_ section: Int) {
        guard expandedSection != section else {
            return
        }
        let previosExpandedSec = expandedSection
        expandedSection = section
        stepperTableView.reloadSections([previosExpandedSec, expandedSection], with: .fade)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView(frame: .zero)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension CreateInventoryViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        17
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        expandedSection == section ? 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StepperTableViewCell.identifier) as? StepperTableViewCell else {
            fatalError("no cell found")
        }
        let isFirst = indexPath.section == 0
        let isLast = tableView.numberOfSections == indexPath.section+1

        cell.configureForStep(indexPath.section+1, inventory: inventory, isFirst: isFirst, isLast: isLast)

        cell.onTapBack = { [weak self] in
            if !isFirst {
                self?.expandSection(indexPath.section-1)
            }
        }

        cell.onTapSaveAndNext = { [weak self] in
            if  !isLast  {
                self?.expandSection(indexPath.section+1)
            }
            self?.saveInventory(as: isLast ? .submitted : .draft)
        }
        return cell
    }

    func saveInventory(as saveStatus: SaveStatus) {
        inventory.updateDataDict()
        Utils.showLoadingInView(self.view)
        InventoryRouterManager().performInventoryCRUD(params: getParams(inventory: inventory, saveStatus: saveStatus)) { response in
            if(response.status == 0){
                self.showSuccessAlertFor(saveStatus: saveStatus)
                Utils.hideLoadingInView(self.view)
            } else {
                Utils.hideLoadingInView(self.view)

                Utils.displayAlert(title: "Error", message: response.message ?? "Something went wrong.")
            }
        } errorCompletionHandler: { error in
            Utils.showLoadingInView(self.view)
            print("error - \(String(describing: error))")
            Utils.displayAlert(title: "Error", message: "Something went wrong.")
        }
    }

    func showSuccessAlertFor(saveStatus: SaveStatus) {
        guard saveStatus == .submitted else {
            return
        }
        _ = Utils.displayAlertController("Inventory Saved Successfully", message: "", isSingleBtn: true) {
            Navigate.routeUserBack(self) {
                //No Action
            }
        } cancelclickHandler: {
            //Not Valid
        }
    }

    func getParams(inventory: Inventory, saveStatus: SaveStatus) -> [String : Any] {
        var params = [String : Any]()
        params[APIRequestModel.RequestKeys.requestdata.rawValue] = encryptReq(inventory: inventory, saveStatus: saveStatus)
        return params

    }

    func encryptReq(inventory: Inventory, saveStatus: SaveStatus) -> String {
        inventory.saveStatus = saveStatus.rawValue
        let json = InventoryCRUDRequestModel(inventory: inventory, mode: inventory.id == 0 ? .insert : .update).getJson()
        print("inventory json \(json)")
        let jsonData = try! JSONSerialization.data(withJSONObject: json,options: [])
        let jsonString = String(data: jsonData, encoding: .utf8)
        let encrypRequest = Utils().encryptData(json: jsonString! )
       return encrypRequest
    }
}
