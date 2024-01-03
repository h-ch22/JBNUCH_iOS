//
//  SportsHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import Foundation
import Firebase

class SportsHelper : ObservableObject{
    private let db = Firestore.firestore()
    @Published var sportsList : [SportsDataModel] = []
    @Published var participantsList : [SportsParticipantsDataModel] = []
    
    func uploadRoom(data : SportsDataModel, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Sports").addDocument(data: [
            "roomName" : data.roomName,
            "sportsType" : data.sportsType,
            "allPeople" : data.allPeople,
            "currentPeople" : data.currentPeople,
            "locationDescription" : data.locationDescription,
            "others" : data.others,
            "manager" : Auth.auth().currentUser?.uid ?? "",
            "location" : data.location,
            "dateTime" : data.dateTime + ":00",
            "college" : data.userInfo?.college ?? "",
            "studentNo" : AES256Util.encrypt(string: data.userInfo?.studentNo ?? ""),
            "phone" : AES256Util.encrypt(string: data.userInfo?.phone ?? ""),
            "name" : AES256Util.encrypt(string: data.userInfo?.phone ?? ""),
            "address" : data.address,
            "isOnline" : data.isOnline,
            "status" : data.status
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func getSportsList(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Sports").addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            querySnapshot?.documentChanges.forEach{diff in
                
                let roomName = diff.document.get("roomName") as? String ?? ""
                let sportsType = diff.document.get("sportsType") as? String ?? ""
                let allPeople = diff.document.get("allPeople") as? Int ?? 0
                let currentPeople = diff.document.get("currentPeople") as? Int ?? 0
                let locationDescription = diff.document.get("locationDescription") as? String ?? ""
                let others = diff.document.get("others") as? String ?? ""
                let manager = diff.document.get("manager") as? String ?? ""
                let location = diff.document.get("location") as? String ?? ""
                let dateTime = diff.document.get("dateTime") as? String ?? ""
                let userInfo = UserInfoModel(name: "", phone: "", studentNo: "", college: "", collegeCode: nil, uid: "", admin: nil, spot : "", profile : nil, countryCode : nil)
                let id = diff.document.documentID
                let address = diff.document.get("address") as? String ?? ""
                let isOnline = diff.document.get("isOnline") as? Bool ?? false
                let status = diff.document.get("status") as? String ?? ""
                
                if status != ""{
                    if userInfo.uid ?? "" == manager{
                        switch diff.type{
                        case .added:
                            if !self.sportsList.contains(where: {$0.id == id}){
                                self.sportsList.append(SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: allPeople, currentPeople: currentPeople, locationDescription: locationDescription, others: others, manager: manager, location: location, dateTime: dateTime, userInfo: userInfo, id: id, address : address, isOnline : isOnline, status : status))
                            }
                        case .modified:
                            let index = self.sportsList.firstIndex(where: {$0.id == id})
                            
                            if index != nil{
                                self.sportsList[index!] = SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: allPeople, currentPeople: currentPeople, locationDescription: locationDescription, others: others, manager: manager, location: location, dateTime: dateTime, userInfo: userInfo, id: id, address : address, isOnline : isOnline, status : status)
                            }
                            
                            else{
                                self.sportsList.append(SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: allPeople, currentPeople: currentPeople, locationDescription: locationDescription, others: others, manager: manager, location: location, dateTime: dateTime, userInfo: userInfo, id: id, address : address, isOnline : isOnline, status : status))
                            }
                            
                        case .removed:
                            let index = self.sportsList.firstIndex(where: {$0.id == id})

                            if index != nil{
                                self.sportsList.remove(at: index!)

                            }
                        }
                    }
                    
                    else{
                        let index = self.sportsList.firstIndex(where: {$0.id == id})

                        if index != nil{
                            self.sportsList.remove(at: index!)

                        }
                    }
                }
                
                else{
                    switch diff.type{
                    case .added:
                        if !self.sportsList.contains(where: {$0.id == id}){
                            self.sportsList.append(SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: allPeople, currentPeople: currentPeople, locationDescription: locationDescription, others: others, manager: manager, location: location, dateTime: dateTime, userInfo: userInfo, id: id, address : address, isOnline : isOnline, status : status))
                        }
                    case .modified:
                        let index = self.sportsList.firstIndex(where: {$0.id == id})
                        
                        if index != nil{
                            self.sportsList[index!] = SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: allPeople, currentPeople: currentPeople, locationDescription: locationDescription, others: others, manager: manager, location: location, dateTime: dateTime, userInfo: userInfo, id: id, address : address, isOnline : isOnline, status : status)
                        }
                        
                        else{
                            self.sportsList.append(SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: allPeople, currentPeople: currentPeople, locationDescription: locationDescription, others: others, manager: manager, location: location, dateTime: dateTime, userInfo: userInfo, id: id, address : address, isOnline : isOnline, status : status))
                        }
                        
                    case .removed:
                        let index = self.sportsList.firstIndex(where: {$0.id == id})

                        if index != nil{
                            self.sportsList.remove(at: index!)

                        }
                    }
                }
                

            }
        }
    }
    
    func participate(id : String, userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Sports").document(id).collection("Participants").document(userInfo?.uid ?? "").setData([
            "name" : AES256Util.encrypt(string: userInfo?.name ?? ""),
            "phone" : AES256Util.encrypt(string: userInfo?.phone ?? ""),
            "studentNo" : AES256Util.encrypt(string: userInfo?.studentNo ?? ""),
            "college" : AES256Util.encrypt(string: userInfo?.college ?? "")
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }

    }
    
    func cancel(id : String, userModel : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        let docRef = self.db.collection("Sports").document(id).collection("Participants").document(userModel?.uid ?? "")
        
        docRef.delete(){error in
            if error != nil{
                print(error)
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func removeRoom(id : String, userModel : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        let docRef = self.db.collection("Sports").document(id)
        
        docRef.getDocument(){(document, error) in
            if let document = document{
                if document.get("manager") as? String ?? "" == userModel?.uid{
                    docRef.delete(){error in
                        if error != nil{
                            print(error)
                            completion(false)
                            
                            return
                        }
                        
                        completion(true)
                    }
                }
            }
            
            else{
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                completion(false)
                
                return
            }
        }
    }
    
    func getParticipants(id : String, completion : @escaping(_ result : Bool?) -> Void){
        self.participantsList.removeAll()
        
        self.db.collection("Sports").document(id).collection("Participants").addSnapshotListener{querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            
            for document in documents{
                if !document.exists{
                    if self.participantsList.contains(where: {$0.uid == document.documentID}){
                        let index = self.participantsList.firstIndex(where: {$0.uid == document.documentID})
                        
                        if index != nil{
                            self.participantsList.remove(at : index!)
                        }
                    }
                }
                
                else{
                    if !self.participantsList.contains(where: {$0.uid == document.documentID}){
                        let name = document.get("name") as? String ?? ""
                        let phone = document.get("phone") as? String ?? ""
                        let studentNo = document.get("studentNo") as? String ?? ""
                        let college = document.get("college") as? String ?? ""
                        
                        self.participantsList.append(SportsParticipantsDataModel(studentNo: AES256Util.decrypt(encoded: studentNo), college: AES256Util.decrypt(encoded: college), name: AES256Util.decrypt(encoded: name), phone: AES256Util.decrypt(encoded: phone), uid: document.documentID))
                    }
                }

            }
            
            completion(true)
        }
    }
    
}
