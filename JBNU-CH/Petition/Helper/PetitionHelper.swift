//
//  PetitionHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import Foundation
import Firebase

class PetitionHelper : ObservableObject{
    @Published var petitionList : [PetitionDataModel] = []
    @Published var recommenders : [PetitionParticipantsModel] = []
    @Published var urlList : [URL?] = []
    
    private let db = Firestore.firestore()
    private let formatter = DateFormatter()
    private let storage = Storage.storage()

    func uploadPetition(title : String, contents : String, images : [URL], completion : @escaping(_ result : Bool?) -> Void){
        formatter.dateFormat = "yyyy. MM. dd. kk:mm:ss.SSSS"
        
        let docRef = self.db.collection("Petition").document()
        docRef.setData([
            "title" : AES256Util.encrypt(string: title),
            "contents" : AES256Util.encrypt(string: contents),
            "author" : AES256Util.encrypt(string: Auth.auth().currentUser?.uid ?? ""),
            "timeStamp" : formatter.string(from: Date()),
            "imageIndex" : images.count
        ]){error in
            if error != nil{
                print(error)
                completion(false)
            }
            
            else{
                if images.count >= 1{
                    for i in 0..<images.count{
                        let storageRef = self.storage.reference(withPath: "/Petition/\(docRef.documentID)/\(i).png")
                        
                        storageRef.putFile(from : images[i], metadata : nil){metadata, error in
                            guard let metadata = metadata else{
                                completion(false)
                                
                                return
                            }
                        }
                    }
                }
                
                completion(true)
            }
        }
    }
    
    func getPetitionList(completion : @escaping(_ result : Bool?) -> Void){
        let docRef = self.db.collection("Petition")
        
        docRef.addSnapshotListener{querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            querySnapshot?.documentChanges.forEach{diff in
                let id = diff.document.documentID
                let title = diff.document.get("title") as? String ?? ""
                let contents = diff.document.get("contents") as? String ?? ""
                let timeStamp = diff.document.get("timeStamp") as? String ?? ""
                let author = diff.document.get("author") as? String ?? ""
                let imageIndex = diff.document.get("imageIndex") as? Int ?? 0
                let read = diff.document.get("read") as? Int ?? 0
                let recommend = diff.document.get("recommend") as? Int ?? 0
                let images : [String] = []
                let statusAsString = diff.document.get("status") as? String ?? ""
                var status : PetitionStatusDataModel = .InProcess
                
                switch statusAsString{
                case "Answered":
                    status = .Answered
                    
                case "Finished":
                    status = .Finish
                    
                default :
                    status = .InProcess
                }
                
                switch diff.type{
                case .added:
                    if !self.petitionList.contains(where: {$0.id == id}){
                        self.petitionList.append(PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status))
                    }
                    
                    else{
                        let index = self.petitionList.firstIndex(where: {$0.id == id})
                        
                        if index != nil{
                            self.petitionList[index!] = PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status)
                        }

                    }
                    
                case .modified:
                    if !self.petitionList.contains(where: {$0.id == id}){
                        self.petitionList.append(PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status))
                    }
                    
                    else{
                        let index = self.petitionList.firstIndex(where: {$0.id == id})
                        
                        if index != nil{
                            self.petitionList[index!] = PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status)
                        }

                    }
                    
                case .removed:
                    let index = self.petitionList.firstIndex(where: {$0.id == id})
                    
                    if index != nil{
                        self.petitionList.remove(at: index!)
                    }
                }
                

            }
        }
    }
    
    func removePetition(id : String, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Petition").document(id).delete(){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            else{
                completion(true)
            }
        }
    }
    
    func recommend(userInfo : UserInfoModel?, id : String, completion : @escaping(_ result : Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss.SSSS"
        self.db.collection("Petition").document(id).collection("Recommends").addDocument(data: [
            "date" : dateFormatter.string(from: Date()),
            "college" : AES256Util.encrypt(string: userInfo?.college ?? ""),
            "name" : AES256Util.encrypt(string: userInfo?.name ?? ""),
            "studentNo" : AES256Util.encrypt(string: userInfo?.studentNo ?? ""),
            "uid" : userInfo?.uid ?? ""
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func downloadImage(id : String, imageIndex : Int){
        if imageIndex >= 1{
            for i in 0..<imageIndex{
                let storageRef = self.storage.reference(withPath: "/Petition/\(id)/\(i).png")
                
                storageRef.downloadURL(){(url, error) in
                    if error != nil{
                        print(error)
                        
                        return
                    }
                    
                    else{
                        self.urlList.append(url)
                    }
                }
            }
        }
    }
    
    func getRecommender(id : String, completion : @escaping(_ result : Bool?) -> Void){
        self.recommenders.removeAll()
        
        self.db.collection("Petition").document(id).collection("Recommends").addSnapshotListener{querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}

            for document in documents{
                
                let uid = document.get("uid") as? String ?? ""
                let date = document.get("date") as? String ?? ""
                let college = document.get("college") as? String ?? ""
                let name = document.get("name") as? String ?? ""
                let studentNo = document.get("studentNo") as? String ?? ""
                
                if !self.recommenders.contains(where: {$0.uid == uid}){
                    let name_encrypted = AES256Util.decrypt(encoded: name)
                    let college_encrypted = AES256Util.decrypt(encoded: college)
                    let studentNo_encrypted = AES256Util.decrypt(encoded: studentNo)
                    var nameAsArray = name_encrypted.map{$0}

                    if name_encrypted.count > 2{
                        nameAsArray[1] = "*"
                        nameAsArray[2] = "*"
                    }
                    
                    else{
                        nameAsArray[1] = "*"
                    }
                    
                    var studentNoAsArray = studentNo_encrypted.map{$0}
                    
                    for i in 4..<studentNoAsArray.count{
                        studentNoAsArray[i] = "*"
                    }
                    
                    self.recommenders.append(PetitionParticipantsModel(uid: uid, name: String(nameAsArray), college: college_encrypted, studentNo: String(studentNoAsArray), date: date))
                }
                
            }
            
            completion(true)
        }
    }
}
