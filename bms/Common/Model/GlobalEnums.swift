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

enum QuestionType: Int {
    case text = 1
    case radioOptions = 2
}

enum TrueFalse: String {
    case `false` = "0"
    case `true` = "1"
}
