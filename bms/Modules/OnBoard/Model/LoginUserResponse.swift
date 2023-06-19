//
//  LoginUserResponse.swift
//  bms
//
//  Created by Naveed on 24/11/22.
//

import Foundation
import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

class LoginUserResponse : RequestBody {
  @objc dynamic var response : String?
    @objc dynamic var status:Int = 0
    @objc dynamic var message:String?
    
    
    enum ResponseKeys :String{
        case response  = "ResponseData"
        case status = "ResponseCode"
        case message = "ResponseDesc"
    }
    
    override func mapping(map: ObjectMapper.Map) {
        super.mapping(map: map)
        self.response  <- map["ResponseData"]
        
        self.status <- map[ResponseKeys.status.rawValue]
        self.message <- map[ResponseKeys.message.rawValue]
    }
}

class LoginUserReponseKeys : RequestBody {
    var ResponseData : String?
 
  
    
    enum ResponseKeys :String{
        case ResponseData              = "ResponseData"
      
        
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.ResponseData              <- map[ResponseKeys.ResponseData.rawValue]
       
    }
}


class Login :APIRequestBody{
    

    var username:String?
    var password:String?
    var device:String?
    
    enum ResponseKeys :String{
        case username  = "loginid"
      case password    = "userpwd"
        case device = "device"
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.username              <- map[ResponseKeys.username.rawValue]
        self.password              <- map[ResponseKeys.password.rawValue]
        self.device              <- map[ResponseKeys.device.rawValue]
    }
    
  
}


class Profile:RequestBody{
    @objc  dynamic var profile: User?
    @objc dynamic var role : RoleObj?
    
    
    enum ResponseKeys :String{
        case profile  = "profile"
        case role = "role"
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.profile              <- map[ResponseKeys.profile.rawValue]
        self.role              <- map[ResponseKeys.role.rawValue]
    }
}


class RoleObj:RequestBody{
    //made private to avoid direct use of it. Use below 'rolesAsEnum' for roles instead.
    //as it has roles based on active components which is asked to use to decide role
    private var roles = List<Role>()
    lazy var rolesAsEnum = {
        var roles: [UserRole] = []
        distinctComponents.forEach { comp in
            if comp.componentId == ComponentType.performInspection.rawValue {
                roles.append(.inspector)
            } else if comp.componentId == ComponentType.reviewInspection.rawValue {
                roles.append(.reviewer)
            }
        }
        return roles
    }()
    //    @objc dynamic var role :[Role]?
    lazy var distinctComponents:[Component] = {
        getAllDistinctComponents()
    }()

    enum ResponseKeys :String{
        case roles  = "roles"
        //      case role = "role"
        
    }
    
    override func mapping(map: ObjectMapper.Map) {
        self.roles              <- (map[ResponseKeys.roles.rawValue], ListTransform<Role>())
        //        self.role              <- map[ResponseKeys.role.rawValue]
    }
    
    override static func ignoredProperties() -> [String] {
            return ["rolesAsEnum", "distinctComponents"]
    }
    
    private func getAllDistinctComponents() -> [Component] {
        var components: [Component] = []
        roles.forEach { role in
            components.append(contentsOf: role.components)
        }
        components = components.reduce([Component]()) { partialResult, component in
            guard component.statusAsEnum == .active else {
                return partialResult
            }
            if partialResult.contains(where: { $0.componentId == component.componentId }) == false {
                var merged = partialResult
                merged.append(component)
                return merged
            }
            return partialResult
        }
        print ("Count - \(components.count) \n set - \(components)")
        return components
    }
}



class Role: RequestBody {
    @objc  dynamic var roleId:Int = 0
    @objc dynamic var roleName:String?
    var components = List<Component>()
    enum ResponseKeys :String{
        case roleId  = "roleid"
        case roleName = "rolename"
        case components = "component"
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.roleId              <- map[ResponseKeys.roleId.rawValue]
        self.roleName              <- map[ResponseKeys.roleName.rawValue]
        self.components              <- (map[ResponseKeys.components.rawValue], ListTransform<Component>())
      
    }
}

class Component:RequestBody{
    @objc dynamic var componentId:Int = 0
    @objc dynamic var statusBitValue: Bool = Status.inActive.boolValue
    @objc dynamic var ComponentName:String?
    @objc dynamic var status: Int = Status.inActive.intValue
    
    var statusAsEnum: Status {
        Status(rawValue: status.description) ?? .inActive
    }

    var type: ComponentType? {
        ComponentType(rawValue: componentId)
    }
    enum ResponseKeys :String{
        case componentId  = "componentid"
        case statusBitValue = "statusbitvalue"
        case ComponentName = "componentname"
        case status = "status"
      
        
    }
  
    override func mapping(map: ObjectMapper.Map) {
        self.componentId              <- map[ResponseKeys.componentId.rawValue]
        self.statusBitValue              <- map[ResponseKeys.statusBitValue.rawValue]
        self.ComponentName              <- map[ResponseKeys.ComponentName.rawValue]
        self.status              <- map[ResponseKeys.status.rawValue]
      
    }
    
}




