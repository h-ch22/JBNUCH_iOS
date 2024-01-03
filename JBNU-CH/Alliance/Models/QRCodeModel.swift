//
//  QRCodeModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import Foundation

struct QRCodeModel : Hashable{
    var benefits : String
    var number : String
    var createDate : String
    var expireDate : String
    var store : String
    
    init(benefits : String, number : String, createDate : String, expireDate : String, store : String){
        self.benefits = benefits
        self.number = number
        self.createDate = createDate
        self.expireDate = expireDate
        self.store = store
    }
}
