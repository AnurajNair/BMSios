//
//  RoutineInspection.swift
//  bms
//
//  Created by Naveed on 13/11/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class RoutineInspection: RequestBody{
    var inspection_name:String?
    var inspection_id:String?
    var type:String?
    //var sections:[sections]?
    var isSelected:Bool = false
    enum ResponseKeys :String{
        case inspection_name   = "inspection_name"
        case inspection_id   = "inspection_id"
        case type   = "type"
        case sections   = "sections"
      
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.inspection_name     <- map[ResponseKeys.inspection_name.rawValue]
        self.inspection_id     <- map[ResponseKeys.inspection_id.rawValue]

        self.type     <- map[ResponseKeys.type.rawValue]

      //  self.sections     <- map[ResponseKeys.sections.rawValue]

      
    }
   
}


struct sections{
    var section_name:String
    var isSubSectionPresent:String
    var subSections:[subSections]
    var questions:[question_ans]
}

struct subSections{
    var subsection_name:String
    var questions:[question_ans]
}


struct question_ans:Decodable {
    var question:String
    var type:String
}


