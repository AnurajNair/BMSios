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
    @objc dynamic var buid: Int = 0
    @objc dynamic var saveStatus: String?
    @objc dynamic var status: String?
    var statusIsActive: Bool {
        status == "1"
    }

    private var dataDict: [String: Any] = [:]

    var data: InventoryData?  {
        didSet{
            dataDict = data?.toJSON() ?? [:]
        }
    }

    enum ResponseKeys: String {
        case id = "id"
        case projectId = "projectid"
        case buid = "buid"
        case saveStatus  = "savestatus"
        case status = "status"
        case data = "data"
    }

    override func mapping(map: Map) {
        id <- map[ResponseKeys.id.rawValue]
        projectId <- map[ResponseKeys.projectId.rawValue]
        buid <- map[ResponseKeys.buid.rawValue]
        saveStatus <- map[ResponseKeys.saveStatus.rawValue]
        status <- map[ResponseKeys.status.rawValue]
        dataDict <- map[ResponseKeys.data.rawValue]
        data = InventoryData(JSON: dataDict)
    }
}
