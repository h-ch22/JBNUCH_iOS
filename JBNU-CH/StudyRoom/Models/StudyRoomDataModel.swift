//
//  StudyRoomDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import Foundation

struct StudyRoomDataModel : Hashable{
    var roomName : String
    var status : StudyRoomStatusModel
    var nextReservation : String
    var myReservation : String
    
    init(roomName : String, status : StudyRoomStatusModel, nextReservation : String, myReservation : String){
        self.roomName = roomName
        self.status = status
        self.nextReservation = nextReservation
        self.myReservation = myReservation
    }
}
