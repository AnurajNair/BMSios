//
//  CreateInventoryViewController.swift
//  bms
//
//  Created by Sahil Ratnani on 02/04/23.
//

import UIKit

class CreateInventoryViewController: UIViewController {

    @IBOutlet weak var stepperTableView: UITableView!

    private var expandedSection: Int = 0
    let steps = ["Bridge Info", "Main Grider", "Total Slab (Interior)", "Total Slab (Cantilever Portion", "Cross Grider", "Low Viscosity Grout", "Polymer Modified Cement Grout", "Pier Cap", "PMC Mortar Treatment", "Water Sprout", "Ralling and Kreb Beam", "Expansion Joint", "Dismantling of RCC and Bituminous Wearing Coat", "Wrapping", "Microcncrete for repairing patch where large quantity of concrete is spalled out and loosening of remaining concrete at expansion joint", "Nipples for low viscosity polymer grout", "Nipples for Polymer modified cement grout"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        stepperTableView.registerNib(Step1Cell.identifier)
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
        guard indexPath.section == 0 else {
            // Temporarily adding UITableViewCell for remaining sections untill developed
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
           cell.backgroundColor = .yellow
                   return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Step1Cell") as? Step1Cell else {
            fatalError("no cell found")
        }
        return cell
    }
}
