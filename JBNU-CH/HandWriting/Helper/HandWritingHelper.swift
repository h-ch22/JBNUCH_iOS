//
//  HandWritingHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import Foundation
import Firebase

class HandWritingHelper : ObservableObject{
    @Published var handWritingList : [HandWritingDataModel] = []
    @Published var urlList : [URL?] = []
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func getHandWritingList(completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("HandWriting").addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            querySnapshot?.documentChanges.forEach{diff in
                let date = diff.document.get("date") as? String ?? ""
                let examName = diff.document.get("examName") as? String ?? ""
                let howTO = diff.document.get("howTO") as? String ?? ""
                let meter = diff.document.get("meter") as? String ?? ""
                let review = diff.document.get("review") as? String ?? ""
                let term = diff.document.get("term") as? String ?? ""
                let examDate = diff.document.get("examDate") as? String ?? ""
                let college = diff.document.get("college") as? String ?? ""
                let studentNo = diff.document.get("studentNo") as? String ?? ""
                let name = diff.document.get("name") as? String ?? ""
                let uid = diff.document.get("uid") as? String ?? ""
                let imageIndex = diff.document.get("imageIndex") as? Int ?? 0
                let title = diff.document.get("title") as? String ?? ""
                let id = diff.document.documentID
                let recommend = diff.document.get("recommend") as? Int ?? 0
                
                let name_encrypted = AES256Util.decrypt(encoded: name)
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
                
                switch diff.type{
                case .added:
                    if !self.handWritingList.contains(where : {$0.id == id}){
                        self.handWritingList.append(HandWritingDataModel(date: date, examName: examName, howTO: howTO, meter: meter, review: review, term: term, examDate: examDate, college: college, studentNo: String(studentNoAsArray), name: String(nameAsArray), uid: uid, id: id, imageIndex: imageIndex, title: title, recommend : recommend))
                    }
                    
                case .modified:
                    let index = self.handWritingList.firstIndex(where : {$0.id == id})
                    
                    if index != nil{
                        self.handWritingList[index!] = HandWritingDataModel(date: date, examName: examName, howTO: howTO, meter: meter, review: review, term: term, examDate: examDate, college: college, studentNo: String(studentNoAsArray), name: String(nameAsArray), uid: uid, id: id, imageIndex: imageIndex, title: title, recommend : recommend)
                    }
                    
                    else{
                        self.handWritingList.append(HandWritingDataModel(date: date, examName: examName, howTO: howTO, meter: meter, review: review, term: term, examDate: examDate, college: college, studentNo: String(studentNoAsArray), name: String(nameAsArray), uid: uid, id: id, imageIndex: imageIndex, title: title, recommend : recommend))
                    }
                    
                case .removed:
                    let index = self.handWritingList.firstIndex(where : {$0.id == id})

                    if index != nil{
                        self.handWritingList.remove(at : index!)
                    }
                }
            }
            
            self.handWritingList.sort(by: {$0.date > $1.date})

            completion(true)
            
        }
        
    }
    
    func uploadHandWriting(data : HandWritingDataModel, images : [URL], completion : @escaping(_ result : Bool?) -> Void){
        let docRef = self.db.collection("HandWriting").document()
        
        docRef.setData([
            "date" : data.date,
            "examName" : data.examName,
            "howTO" : data.howTO,
            "meter" : data.meter,
            "review" : data.review,
            "term" : data.term,
            "examDate" : data.examDate,
            "college" : data.college,
            "studentNo" : AES256Util.encrypt(string: data.studentNo),
            "name" : AES256Util.encrypt(string: data.name),
            "uid" : data.uid,
            "imageIndex" : data.imageIndex,
            "title" : data.title,
            "recommend" : data.recommend
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            if data.imageIndex >= 1{
                for i in 0..<data.imageIndex{
                    let storageRef = self.storage.reference(withPath: "/handWriting/\(docRef.documentID)/\(i).png")
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
    
    func removeHandWriting(data : HandWritingDataModel, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("HandWriting").document(data.id).delete(){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func downloadImage(data : HandWritingDataModel, completion : @escaping(_ result : Bool?) -> Void){
        self.urlList.removeAll()
        
        if data.imageIndex > 0{
            for i in 0..<data.imageIndex{
                let imgRef = self.storage.reference(withPath: "/handWriting/\(data.id)/\(i).png")
                
                imgRef.downloadURL{url, error in
                    if error != nil{
                        print(error)
                        
                        completion(false)
                        
                        return
                    }
                    
                    else{
                        self.urlList.append(url)
                    }
                }
            }
            
            
        }
        
        completion(true)
    }
    
    func recommend(data : HandWritingDataModel, userModel : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("HandWriting").document(data.id).collection("Recommends").addDocument(data: [
            "uid" : userModel?.uid ?? ""
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func getRecommender(data : HandWritingDataModel, userModel : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("HandWriting").document(data.id).collection("Recommends").whereField("uid", isEqualTo : userModel?.uid ?? "").getDocuments(){(querySnapshot, error) in
            if querySnapshot != nil{
                if querySnapshot!.documents.count >= 1{
                    completion(true)
                }
                
                else{
                    completion(false)
                }
            }

            else{
                completion(false)
            }
        }
    }
    
    
}
