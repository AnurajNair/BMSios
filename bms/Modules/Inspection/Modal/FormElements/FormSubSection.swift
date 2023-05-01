//
//  FormSubSection.swift
//  bms
//
//  Created by Sahil Ratnani on 30/04/23.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class FormSubSection: RequestBody {
    @objc dynamic var subSectionIndex: Int = 0
    @objc dynamic var subSectionName: String?
    var questions = List<Question>() {
        didSet {
             questions.sort {
                $0.questionIndex < $1.questionIndex
            }
        }
    }

    enum ResponseKeys: String {
        case subSectionIndex = "subsectionindex"
        case subSectionName = "subsectionname"
        case questions = "questions"
    }

    override func mapping(map: ObjectMapper.Map) {
        subSectionIndex <- map[ResponseKeys.subSectionIndex.rawValue]
        subSectionName <- map[ResponseKeys.subSectionName.rawValue]
        questions <- (map[ResponseKeys.questions.rawValue], ListTransform<Question>())
    }

}
