//
//  GlobalEnums.swift
//  bms
//
//  Created by Sahil Ratnani on 14/04/23.
//


enum Status: String {
    case active = "0"
    case inActive = "1"
}

enum Mode: String {
    case insert = "I"
    case update = "U"
}

enum SaveStatus: String {
    case draft = "D"
    case submitted = "S"
}

enum InspectionStatus: String {
    case assigned = "A"
    case draft = "D"
    case submitted = "S"
    case reviewed = "R"
}
