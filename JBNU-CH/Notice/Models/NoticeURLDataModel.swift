//
//  NoticeURLDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import Foundation

struct NoticeURLDataModel : Hashable{
    var id : String?
    var imageIndex : Int?
    var url : [URL?]
    
    init(id : String?, imageIndex : Int?, url : [URL?]){
        self.id = id
        self.imageIndex = imageIndex
        self.url = url
    }
}
