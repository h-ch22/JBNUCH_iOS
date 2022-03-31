//
//  NoticeDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import Foundation
import UIKit

struct NoticeDataModel : Hashable{
    var id : String?
    var title : String?
    var contents : String?
    var dateTime : String?
    var imageIndex : Int?
    var url : String?
    var type : NoticeTypeModel
    
    init(id : String?, title : String?, contents : String?, dateTime : String?, imageIndex : Int?, url : String?, type : NoticeTypeModel){
        self.id = id
        self.title = title
        self.contents = contents
        self.dateTime = dateTime
        self.imageIndex = imageIndex
        self.url = url
        self.type = type
    }
}
