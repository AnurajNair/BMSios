//
//  FormSection.swift
//  bms
//
//  Created by Sahil Ratnani on 30/04/23.
//

import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class FormSection: RequestBody {
    @objc dynamic var sectionIndex: Int = 0
    @objc dynamic var sectionName:String?
    var files = List<String>()

    var subSections = List<FormSubSection>() {
        didSet {
            subSections.sort {
                $0.subSectionIndex < $1.subSectionIndex
            }
        }
    }

    enum ResponseKeys: String {
        case sectionIndex = "sectionindex"
        case sectionName = "sectionname"
        case subSections = "subsection"
        case files = "files"
    }

    override func mapping(map: ObjectMapper.Map) {
        sectionIndex <- map[ResponseKeys.sectionIndex.rawValue]
        sectionName <- map[ResponseKeys.sectionName.rawValue]
        subSections <- (map[ResponseKeys.subSections.rawValue], ListTransform<FormSubSection>())
        files <- map[ResponseKeys.files.rawValue]
    }

}
