//
//  SportsDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import Foundation

struct SportsDataModel : Hashable{
    var roomName : String
    var sportsType : String
    var allPeople : Int
    var currentPeople : Int
    var locationDescription : String
    var others : String
    var manager : String
    var location : String
    var dateTime : String
    var userInfo : UserInfoModel?
    var id : String
    var address : String
    var isOnline : Bool
    var status : String
    
    init(roomName : String, sportsType : String, allPeople : Int, currentPeople : Int, locationDescription : String, others : String, manager : String, location : String, dateTime : String, userInfo : UserInfoModel?, id : String, address : String, isOnline : Bool, status : String){
        self.roomName = roomName
        self.sportsType = sportsType
        self.allPeople = allPeople
        self.currentPeople = currentPeople
        self.locationDescription = locationDescription
        self.others = others
        self.manager = manager
        self.location = location
        self.dateTime = dateTime
        self.userInfo = userInfo
        self.id = id
        self.address = address
        self.isOnline = isOnline
        self.status = status
    }
}
