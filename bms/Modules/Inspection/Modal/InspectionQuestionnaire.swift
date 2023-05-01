//
//  InspectionQuestionnaire.swift
//  bms
//
//  Created by Sahil Ratnani on 30/04/23.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class InspectionQuestionnaire: Inspection {
    @objc dynamic var desc: String?
    var inspectors = List<User>()
    var reviewers = List<User>()
    var sections = List<FormSection>() {
        didSet {
            sections.sort {
                $0.sectionIndex < $1.sectionIndex
            }
        }
    }

    enum ResponseKeys: String {
        case desc = "description"
        case inspectors = "inspectorid"
        case reviewers = "reviewerid"
        case sections = "section"
    }

    override func mapping(map: ObjectMapper.Map) {
        super.mapping(map: map)
        desc <- map[ResponseKeys.desc.rawValue]
        inspectors <- (map[ResponseKeys.inspectors.rawValue], ListTransform<User>())
        reviewers <- (map[ResponseKeys.reviewers.rawValue], ListTransform<User>())
        sections <- (map[ResponseKeys.sections.rawValue], ListTransform<FormSection>())
    }
}
