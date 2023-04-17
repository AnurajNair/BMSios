//
//  Inventory.swift
//  bms
//
//  Created by Sahil Ratnani on 11/04/23.
//

import ObjectMapper

class Inventory: RequestBody {
    @objc dynamic var id: Int = 0
    @objc dynamic var projectId: Int = 0
    @objc dynamic var bridgeId: Int = 0
    @objc dynamic var saveStatus: String?
    @objc dynamic var status: String?
    var statusIsActive: Bool {
        status == Status.active.rawValue
    }

    private var dataDict: [String: Any] = [:] {
        didSet {
            guard data == nil else { return }
            data = InventoryData(JSON: dataDict)
        }
    }

    var data: InventoryData?

    enum ResponseKeys: String {
        case id = "id"
        case projectId = "projectid"
        case bridgeId = "bridgeid"
        case saveStatus  = "savestatus"
        case status = "status"
        case data = "data"
    }

    override func mapping(map: Map) {
        id <- map[ResponseKeys.id.rawValue]
        projectId <- map[ResponseKeys.projectId.rawValue]
        bridgeId <- map[ResponseKeys.bridgeId.rawValue]
        saveStatus <- map[ResponseKeys.saveStatus.rawValue]
        status <- map[ResponseKeys.status.rawValue]
        dataDict <- map[ResponseKeys.data.rawValue]
    }

    func updateDataDict() {
        guard let dict = data?.toJSON() else { return }
        dataDict = dict
    }
}
