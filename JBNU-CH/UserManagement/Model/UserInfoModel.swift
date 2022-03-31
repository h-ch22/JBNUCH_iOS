//
//  UserInfoModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import Foundation

struct UserInfoModel : Hashable{
    var name : String?
    var phone : String?
    var studentNo : String?
    var college : String?
    var collegeCode : CollegeCodeModel?
    var uid : String?
    var admin : AdminCodeModel?
    var spot : String?
    var profile : URL?
    
    init(name : String?, phone : String?, studentNo : String?, college : String?, collegeCode : CollegeCodeModel?, uid : String?, admin : AdminCodeModel?, spot : String?, profile : URL?){
        self.name = name
        self.phone = phone
        self.studentNo = studentNo
        self.college = college
        self.collegeCode = collegeCode
        self.uid = uid
        self.admin = admin
        self.spot = spot
        self.profile = profile
    }
}
