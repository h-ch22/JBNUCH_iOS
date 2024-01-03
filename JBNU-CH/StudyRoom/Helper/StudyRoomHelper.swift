//
//  StudyRoomHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/04.
//

import Foundation
import Firebase
import SwiftUI

class StudyRoomHelper : ObservableObject{
    @Published var studyRoomStatus_1 : StudyRoomDataModel? = nil
    @Published var studyRoomStatus_2 : StudyRoomDataModel? = nil

    private let db = Firestore.firestore()
    private let helper = UserManagement()
    
    func getReservationInfo(userInfo : UserInfoModel?, checkIn : String?, checkOut : String?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("StudyRoom").document(self.helper.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).collection("Reservation")
    }
    
    func getStatus(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("StudyRoom").document(self.helper.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).getDocument(){(document, error) in
            if error != nil{
                print(error)
                completion(false)
                
                return
            }
            
            else{
                if let document = document{
                    if document.exists{
                        let status_Room1 = document.get("Room_1") as? String ?? ""
                        let status_Room2 = document.get("Room_2") as? String ?? ""
                        
                        switch status_Room1{
                        case "available":
                            self.studyRoomStatus_1 = StudyRoomDataModel(roomName: "제1스터디룸", status: .available, nextReservation: "", myReservation: "")
                            
                        case "unvailable":
                            self.studyRoomStatus_1 = StudyRoomDataModel(roomName: "제1스터디룸", status: .unavailable, nextReservation: "", myReservation: "")
                            
                        case "preparing":
                            self.studyRoomStatus_1 = StudyRoomDataModel(roomName: "제1스터디룸", status: .preparing, nextReservation: "", myReservation: "")
                            
                        default:
                            self.studyRoomStatus_1 = StudyRoomDataModel(roomName: "제1스터디룸", status: .preparing, nextReservation: "", myReservation: "")
                        }
                        
                        switch status_Room2{
                        case "available":
                            self.studyRoomStatus_2 = StudyRoomDataModel(roomName: "제2스터디룸", status: .available, nextReservation: "", myReservation: "")
                            
                        case "unvailable":
                            self.studyRoomStatus_2 = StudyRoomDataModel(roomName: "제2스터디룸", status: .unavailable, nextReservation: "", myReservation: "")
                            
                        case "preparing":
                            self.studyRoomStatus_2 = StudyRoomDataModel(roomName: "제2스터디룸", status: .preparing, nextReservation: "", myReservation: "")
                            
                        default:
                            self.studyRoomStatus_2 = StudyRoomDataModel(roomName: "제2스터디룸", status: .preparing, nextReservation: "", myReservation: "")
                        }
                        
                    }
                    
                    completion(true)

                }
            }
        }
    }
}
