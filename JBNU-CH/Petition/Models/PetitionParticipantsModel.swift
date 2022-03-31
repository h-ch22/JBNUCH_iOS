//
//  PetitionParticipantsModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import Foundation

struct PetitionParticipantsModel : Hashable{
    var uid : String
    var name : String
    var college : String
    var studentNo : String
    var date : String
    
    init(uid : String, name : String, college : String, studentNo : String, date : String){
        self.uid = uid
        self.name = name
        self.college = college
        self.studentNo = studentNo
        self.date = date
    }
}
