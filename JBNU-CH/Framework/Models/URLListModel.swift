//
//  URLListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/15.
//

import Foundation

struct URLListModel : Hashable{
    var index : Int
    var url : URL?
    
    init(index : Int, url : URL?){
        self.index = index
        self.url = url
    }
}
