//
//  SportsParticipantsDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import Foundation

struct SportsParticipantsDataModel : Hashable{
    var studentNo : String
    var college : String
    var name : String
    var phone : String
    var uid : String
    
    init(studentNo : String, college : String, name : String, phone : String, uid : String){
        self.studentNo = studentNo
        self.college = college
        self.name = name
        self.phone = phone
        self.uid = uid
    }
}
