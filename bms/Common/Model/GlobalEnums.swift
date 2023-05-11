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

    var text: String {
        switch self {
        case .draft:
            return "Draft"
        case .submitted:
            return "Submitted"
        }
    }
}
