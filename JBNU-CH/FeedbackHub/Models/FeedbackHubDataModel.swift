//
//  FeedbackHubDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import Foundation

struct FeedbackHubDataModel : Hashable{
    var name : String
    var studentNo : String
    var college : String
    var title : String
    var contents : String
    var category : FeedbackHubCategoryModel?
    var type : FeedbackHubTypeModel?
    var id : String
    var uid : String
    var date : String
    var answer : String
    var answer_author : String
    var answer_date : String
}
