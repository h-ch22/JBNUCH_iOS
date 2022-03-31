//
//  MarketDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import Foundation

struct MarketDataModel : Hashable{
    var id : String?
    var seller : String?
    var price : Int?
    var sellerInfo : String?
    var title : String
    var contents : String?
    var thumbnail : URL?
    var quantity : Int?
    var status : ProductStatusModel?
    var date : String?
    var category : String?
    var imgCount : Int?
    
    init(id : String?, seller : String?, price : Int?, sellerInfo : String?, title : String, contents : String?, thumbnail : URL?, quantity : Int?, status : ProductStatusModel?, date : String?, category : String?, imgCount : Int?){
        self.id = id
        self.seller = seller
        self.price = price
        self.sellerInfo = sellerInfo
        self.title = title
        self.contents = contents
        self.thumbnail = thumbnail
        self.quantity = quantity
        self.status = status
        self.date = date
        self.category = category
        self.imgCount = imgCount
    }
}
