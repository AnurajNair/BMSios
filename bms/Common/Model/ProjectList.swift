//
//  ProjectList.swift
//  bms
//
//  Created by Sahil Ratnani on 16/04/23.
//

import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

import Foundation
class ProjectList: RequestBody {
    var projectList = List<Project>()
    
    enum ResponseKeys :String{
        case projectList  = "project"
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.projectList              <- (map[ResponseKeys.projectList.rawValue], ListTransform<Project>())
    }
}
