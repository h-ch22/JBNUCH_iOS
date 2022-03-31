//
//  PetitionDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import Foundation

struct PetitionDataModel : Hashable{
    var id : String?
    var author : String?
    var title : String?
    var contents : String?
    var images : [String]
    var imageIndex : Int?
    var recommend : Int?
    var read : Int?
    var timeStamp : String?
    var status : PetitionStatusDataModel
    
    init(id : String?, author : String?, title : String?, contents : String?, images : [String], imageIndex : Int?, recommend : Int?, read : Int?, timeStamp : String?, status : PetitionStatusDataModel){
        self.id = id
        self.author = author
        self.title = title
        self.contents = contents
        self.images = images
        self.imageIndex = imageIndex
        self.recommend = recommend
        self.read = read
        self.timeStamp = timeStamp
        self.status = status
    }
}
