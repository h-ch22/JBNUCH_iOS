//
//  NoticeHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI

class NoticeHelper : ObservableObject{
    @Published var noticeList : [NoticeDataModel] = []
    @Published var urlList : [URLListModel] = []
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let userManagement = UserManagement()
    
    func getNotice(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Notice").document("CH").addSnapshotListener{documentSnapshot, error in
            guard let document = documentSnapshot else{return}
            
            guard let data = document.data() else{return}
                        
            for index in data.keys{
                let noticeData = data[index] as! [String : Any]
                
                if !self.noticeList.contains(where: {$0.id == noticeData["id"] as? String ?? ""}){
                    
                    self.noticeList.append(NoticeDataModel(id: noticeData["id"] as? String ?? "",
                                                           title: noticeData["title"] as? String ?? "",
                                                           contents: noticeData["contents"] as? String ?? "",
                                                           dateTime: noticeData["dateTime"] as? String ?? "",
                                                           imageIndex: noticeData["imageIndex"] as? Int ?? 0,
                                                           url: noticeData["url"] as? String ?? "",
                                                           type : .CH))
                    
                    self.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})

                }

            }
        }
        
        if userInfo?.collegeCode == .SOC || userInfo?.collegeCode == .COM || userInfo?.collegeCode == .COH || userInfo?.collegeCode == .CON || userInfo?.collegeCode == .CHE{
            self.db.collection("Notice").document(userManagement.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).addSnapshotListener{documentSnapshot, error in
                guard let document = documentSnapshot else{return}
                
                guard let data = document.data() else{return}
                            
                for index in data.keys{
                    let noticeData = data[index] as! [String : Any]
                    
                    if !self.noticeList.contains(where: {$0.id == noticeData["id"] as? String ?? ""}){
                        self.noticeList.append(NoticeDataModel(id: noticeData["id"] as? String ?? "",
                                                               title: noticeData["title"] as? String ?? "",
                                                               contents: noticeData["contents"] as? String ?? "",
                                                               dateTime: noticeData["dateTime"] as? String ?? "",
                                                               imageIndex: noticeData["imageIndex"] as? Int ?? 0,
                                                               url: noticeData["url"] as? String ?? "",
                                                               type : .College))
                        
                        self.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})

                    }
                    

                }
                

            }
        }
        
        self.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
        
        completion(true)
    }
    
    func uploadNotice(images : [URL], url : String, imageIndex : Int, admin : String, title : String?, contents : String?, completion : @escaping(_ result : Bool?) -> Void){
        let noticeRef = self.db.collection("Notice").document(admin ?? "")
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm"
        
        let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let id = str.createRandomStr(length : 28)
        let storageRef = storage.reference()
        
        let data : [String : Any] = [
            "contents" : contents,
            "dateTime" : dateFormatter.string(from: Date()),
            "id" : id,
            "imageIndex" : imageIndex,
            "title" : title,
            "url" : url
        ]
        
        noticeRef.getDocument(){(document, error) in
            if let document = document{
                if document.exists{
                    noticeRef.updateData([id:data]){error in
                        if error != nil{
                            completion(false)
                            
                            return
                        }
                        
                        for i in 0..<images.count{
                            let noticeRef = storageRef.child("notice/\(admin)/\(id)/\(i).png")
                            let uploadTask = noticeRef.putFile(from: images[i], metadata : nil){metadata, error in
                                guard let metadata = metadata else{
                                    completion(false)
                                    
                                    return
                                }
                                
                                
                            }
                        }
                        
                        completion(true)
                    }
                }
                
                else{
                    noticeRef.setData([id:data]){error in
                        if error != nil{
                            completion(false)
                            
                            return
                        }
                        
                        for i in 0..<images.count{
                            let noticeRef = storageRef.child("notice/\(admin)/\(id)/\(i).png")
                            let uploadTask = noticeRef.putFile(from: images[i], metadata : nil){metadata, error in
                                guard let metadata = metadata else{
                                    completion(false)
                                    
                                    return
                                }
                                
                                
                            }
                        }
                        
                        completion(true)
                    }
                    
                }
            }
        }
        

    }
    
    func downloadImage(userInfo : UserInfoModel?, id : String, type : NoticeTypeModel, imageIndex : Int, completion : @escaping(_ result : Bool?) -> Void){
        self.urlList.removeAll()
        var imgList : [URLListModel] = []
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()

        if imageIndex > 0{
            for i in 0..<imageIndex{
                
                if type == .CH{
                    let imgRef = self.storage.reference(withPath : "notice/CH/\(id)/\(i).png")
                    
                    imgRef.downloadURL{url, error in
                        if error != nil{
                            print(error)
                            completion(false)
                            
                            return
                        }
                        
                        else{
                            imgList.append(URLListModel(index: i, url: url))
                            
                            if imgList.count == imageIndex{
                                downloadGroup.leave()
                            }
                        }
                    }
                }
                
                else{
                    let imgRef = self.storage.reference(withPath : "notice/\(userManagement.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode))/\(id)/\(i).png")
                    
                    imgRef.downloadURL{url, error in
                        if error != nil{
                            print(error)
                            completion(false)
                            
                            return
                        }
                        
                        else{
                            imgList.append(URLListModel(index: i, url: url))

                            if imgList.count == imageIndex{
                                downloadGroup.leave()
                            }
                        }
                    }
                }
            }
            
            downloadGroup.notify(queue: .main){
                self.urlList = imgList.sorted{$0.index < $1.index}
                
                completion(true)
            }
            
        } else{completion(true)}

    }
    
    func removeNotice(id : String, type : NoticeTypeModel, completion : @escaping(_ result : Bool?) -> Void){
        var docRef : DocumentReference? = nil
        
        switch type{
        case .CH:
            docRef = db.collection("Notice").document("CH")
            
        case .College:
            docRef = db.collection("Notice").document(userManagement.convertCollegeCodeAsString(collegeCode: userManagement.userInfo?.collegeCode))
        }
        
        if docRef != nil{
            docRef?.updateData([id : FieldValue.delete()]){err in
                if let err = err{
                    print(err)
                    
                    completion(false)
                }
                
                else{
                    completion(true)
                }
            }
        }
        
        else{
            completion(false)
        }
    }
    
    func editNotice(id : String, admin : String, title : String, contents : String, data : NoticeDataModel, completion : @escaping(_ result : Bool?) -> Void){
        var docRef = db.collection("Notice").document(admin)
        
        if docRef != nil{
            docRef.updateData([id : [
                "title" : title,
                "contents" : contents,
                "dateTime" : data.dateTime,
                "id" : data.id,
                "imageIndex" : data.imageIndex,
                "url" : data.url
            ]]){err in
                if let err = err{
                    print(err)
                    
                    completion(false)
                }
                
                else{
                    completion(true)
                }
            }
        }
        
        else{
            completion(false)
        }
    }
}
