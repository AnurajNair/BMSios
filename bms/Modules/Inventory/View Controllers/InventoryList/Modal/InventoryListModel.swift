//
//  InventoryListModel.swift
//  bms
//
//  Created by Sahil Ratnani on 08/04/23.
//

import Foundation

struct InventoryListModel {
    var id: Int
    var projectName:String
    var projectId:Int
    var buid:Int
    var saveStatus:String
    var status:Int
    var bridgeId:Int
    var bridgeName:String

    static let dummyList = [InventoryListModel(id: 1,
                                               projectName: "Project1",
                                               projectId: 1,
                                               buid: 1,
                                               saveStatus: "Submitted",
                                               status: 1,
                                               bridgeId: 1,
                                               bridgeName: "01234u109234-Test Bridge 1"),
                            InventoryListModel(id: 2,
                                               projectName: "Project2",
                                               projectId: 2,
                                               buid: 2,
                                               saveStatus: "Submitted",
                                               status: 1,
                                               bridgeId: 2,
                                               bridgeName: "71873489178934-Test Bridge 2"),
                            InventoryListModel(id: 3,
                                               projectName: "Project3",
                                               projectId: 3,
                                               buid: 3,
                                               saveStatus: "Submitted",
                                               status: 0,
                                               bridgeId: 3,
                                               bridgeName: "7419837413-Test Bridge 3")]
}
