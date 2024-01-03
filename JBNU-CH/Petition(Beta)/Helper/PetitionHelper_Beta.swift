//
//  PetitionHelper_Beta.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/07/01.
//

import Foundation
import Firebase

class PetitionHelperBeta : ObservableObject{
    @Published var petitionList : [PetitionDataModel] = []
    @Published var recommenders : [PetitionParticipantsModel] = []
    @Published var urlList : [URLListModel] = []
    @Published var noticeList : [NoticeDataModel] = []
    @Published var translatedText : String? = nil
    @Published var noticeImgList : [URLListModel] = []

    private let db = Firestore.firestore()
    private let formatter = DateFormatter()
    private let storage = Storage.storage()
    
    func uploadNotice(images : [URL], url : String, imageIndex : Int, title : String?, contents : String?, completion : @escaping(_ result : Bool?) -> Void){
        let noticeRef = self.db.collection("Notice").document("Petition")
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
                            let noticeRef = storageRef.child("notice/Petition/\(id)/\(i).png")
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
                            let noticeRef = storageRef.child("notice/Petition/\(id)/\(i).png")
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
    
    func getNotice(completion : @escaping(_ result : Bool?) -> Void){
        let docRef = db.collection("Notice").document("Petition")
        
        docRef.addSnapshotListener{documentSnapshot, error in
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
                                                           type : .Petition,
                                                           translatedText: nil))
                    
                    self.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
                    
                }
                
            }
        }
    }
    
    func uploadPetition(title : String, contents : String, images : [URL], category : Int, completion : @escaping(_ result : Bool?) -> Void){
        formatter.dateFormat = "yyyy. MM. dd. kk:mm:ss.SSSS"
        
        var categoryAsString = ""
        
        switch category{
        case 1: categoryAsString = "학사"
        case 2: categoryAsString = "시설"
        case 3: categoryAsString = "복지"
        case 4: categoryAsString = "문화 및 예술"
        case 5: categoryAsString = "기타"
        default: categoryAsString = "학사"
        }
        
        let docRef = self.db.collection("Petition_BETA").document()
        docRef.setData([
            "title" : AES256Util.encrypt(string: title),
            "contents" : AES256Util.encrypt(string: contents),
            "author" : AES256Util.encrypt(string: Auth.auth().currentUser?.uid ?? ""),
            "timeStamp" : formatter.string(from: Date()),
            "imageIndex" : images.count,
            "category" : categoryAsString
        ]){error in
            if error != nil{
                print(error)
                completion(false)
            }
            
            else{
                if images.count >= 1{
                    for i in 0..<images.count{
                        let storageRef = self.storage.reference(withPath: "/Petition_BETA/\(docRef.documentID)/\(i).png")
                        
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
        let docRef = self.db.collection("Petition_BETA")
        
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
                let category = diff.document.get("category") as? String ?? ""
                let images : [String] = []
                let statusAsString = diff.document.get("status") as? String ?? ""
                var status : PetitionStatusDataModel = .InProcess
                
                switch statusAsString{
                case "Answered":
                    status = .Answered
                    
                case "Finished":
                    status = .Finish
                    
                case "Canceled":
                    status = .Cancled
                    
                default :
                    status = .InProcess
                }
                
                switch diff.type{
                case .added:
                    if !self.petitionList.contains(where: {$0.id == id}){
                        self.petitionList.append(PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status, category : category))
                    }
                    
                    else{
                        let index = self.petitionList.firstIndex(where: {$0.id == id})
                        
                        if index != nil{
                            self.petitionList[index!] = PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status, category : category)
                        }
                        
                    }
                    
                case .modified:
                    if !self.petitionList.contains(where: {$0.id == id}){
                        self.petitionList.append(PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status, category : category))
                    }
                    
                    else{
                        let index = self.petitionList.firstIndex(where: {$0.id == id})
                        
                        if index != nil{
                            self.petitionList[index!] = PetitionDataModel(id: id, author: author, title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), images: images, imageIndex: imageIndex, recommend: recommend, read: read, timeStamp: timeStamp, status : status, category : category)
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
        self.db.collection("Petition_BETA").document(id).delete(){error in
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
        self.db.collection("Petition_BETA").document(id).collection("Recommends").addDocument(data: [
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
    
    func downloadNoticeImage(id : String, imageIndex : Int, completion : @escaping(_ result : Bool?) -> Void){
        self.urlList.removeAll()
        var imgList : [URLListModel] = []
        
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()

        if imageIndex > 0{
            for i in 0..<imageIndex{
                let imgRef = self.storage.reference(withPath : "notice/Petition/\(id)/\(i).png")
                
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
            
            downloadGroup.notify(queue: .main){
                self.urlList = imgList.sorted{$0.index < $1.index}
                
                completion(true)
            }
            
        } else{completion(true)}

    }
    
    func downloadImage(id : String, imageIndex : Int){
        self.urlList.removeAll()
        
        var imgList : [URLListModel] = []
        let downloadGroup = DispatchGroup()
        downloadGroup.enter()
        
        if imageIndex >= 1{
            for i in 0..<imageIndex{
                let storageRef = self.storage.reference(withPath: "/Petition_BETA/\(id)/\(i).png")
                
                storageRef.downloadURL(){(url, error) in
                    if error != nil{
                        print(error)
                        
                        return
                    }
                    
                    else{
                        imgList.append(URLListModel(index : i, url : url))
                        
                        if imgList.count == imageIndex{
                            downloadGroup.leave()
                        }
                    }
                }
            }
            
            downloadGroup.notify(queue : .main){
                self.urlList = imgList.sorted{$0.index < $1.index}
            }
        }
    }
    
    func removeNotice(id : String, completion : @escaping(_ result : Bool?) -> Void){
        var docRef : DocumentReference? = nil
        docRef = db.collection("Notice").document("Petition")
        
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
        var docRef = db.collection("Notice").document("Petition")
        
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
    
    func getRecommender(id : String, completion : @escaping(_ result : Bool?) -> Void){
        self.recommenders.removeAll()
        
        self.db.collection("Petition_BETA").document(id).collection("Recommends").addSnapshotListener{querySnapshot, error in
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
