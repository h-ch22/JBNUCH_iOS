//
//  HandWritingDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import Foundation

struct HandWritingDataModel : Hashable{
    var date : String
    var examName : String
    var howTO : String
    var meter : String
    var review : String
    var term : String
    var examDate : String
    var college : String
    var studentNo : String
    var name : String
    var uid : String
    var id : String
    var imageIndex : Int
    var title : String
    var recommend : Int
    
    init(date : String, examName : String, howTO : String, meter : String, review : String, term : String, examDate : String, college : String, studentNo : String, name : String, uid : String, id : String, imageIndex : Int, title : String, recommend : Int){
        self.date = date
        self.examName = examName
        self.howTO = howTO
        self.meter = meter
        self.review = review
        self.term = term
        self.examDate = examDate
        self.college = college
        self.studentNo = studentNo
        self.name = name
        self.uid = uid
        self.id = id
        self.imageIndex = imageIndex
        self.title = title
        self.recommend = recommend
    }
}
