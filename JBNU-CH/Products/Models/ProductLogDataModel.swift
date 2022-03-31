//
//  ProductLogDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import Foundation

struct ProductLogDataModel : Hashable{
    var id : String
    var productName : String
    var icName : String
    var isReturned : Bool
    var dateTime : String
    var number : String
    var dayLimit : String
}
