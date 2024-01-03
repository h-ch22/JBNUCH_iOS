//
//  AllianceDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import Foundation
import UIKit

struct AllianceDataModel : Hashable{
    var storeName : String?
    var benefits : String?
    var breakTime : String?
    var closeTime : String?
    var closed : String?
    var id : String?
    var location : String?
    var menu : String?
    var openTime : String?
    var price : String?
    var tel : String?
    var storeLogo : URL?
    var allianceType : String
    var URL_Naver : String?
    var URL_Baemin : String?
    var pos : String?
    var isFavorite : Bool?
    
    init(storeName : String?, benefits : String?, breakTime : String?, closeTime : String?, closed : String?, id : String?, location : String?, menu : String?, openTime : String?, price : String?, tel : String?, storeLogo : URL?, allianceType : String, URL_Naver : String?, URL_Baemin : String?, pos : String?, isFavorite : Bool?){
        self.storeName = storeName
        self.benefits = benefits
        self.breakTime = breakTime
        self.closeTime = closeTime
        self.closed = closed
        self.id = id
        self.location = location
        self.menu = menu
        self.openTime = openTime
        self.price = price
        self.tel = tel
        self.storeLogo = storeLogo
        self.allianceType = allianceType
        self.URL_Naver = URL_Naver
        self.URL_Baemin = URL_Baemin
        self.pos = pos
        self.isFavorite = isFavorite
    }
}
