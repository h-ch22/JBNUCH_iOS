//
//  FeedbackHubHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import Foundation
import Firebase

class FeedbackHubHelper : ObservableObject{
    private let db = Firestore.firestore()
    @Published var feedbackList : [FeedbackHubDataModel] = []
    @Published var myfeedbackList : [FeedbackHubDataModel] = []
    
    func sendFeedback(userModel : UserInfoModel?, feedbackType : FeedbackHubTypeModel?, feedbackCategory : FeedbackHubCategoryModel?, feedbackTitle : String, feedbackContents : String, completion : @escaping(_ result : Bool?) -> Void){
        var feedbackTypeAsString = ""
        
        switch feedbackType{
        case .Good:
            feedbackTypeAsString = "칭찬해요"
            
        case .Bad:
            feedbackTypeAsString = "개선해주세요"
            
        case .Question:
            feedbackTypeAsString = "궁금해요"
            
        case .none:
            feedbackTypeAsString = ""
        }
        
        var feedbackCategoryAsString = ""
        
        switch feedbackCategory{
        case .Welfare:
            feedbackCategoryAsString = "복지"
            
        case .Event:
            feedbackCategoryAsString = "행사"
            
        case .Pledge:
            feedbackCategoryAsString = "공약"
            
        case .Facility:
            feedbackCategoryAsString = "시설"
            
        case .App:
            feedbackCategoryAsString = "앱"
            
        case .Communication:
            feedbackCategoryAsString = "소통"
            
        case .Others:
            feedbackCategoryAsString = "기타"
            
        case .none:
            feedbackCategoryAsString = ""
        }
                
        let college = userModel?.college ?? ""
        let studentNo = userModel?.studentNo ?? ""
        let name = userModel?.name ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
        
        self.db.collection("Feedback").addDocument(data: [
            "Author" : AES256Util.encrypt(string:college + " " + studentNo + " " + name),
            "Title" : AES256Util.encrypt(string: feedbackTitle),
            "Contents" : AES256Util.encrypt(string: feedbackContents),
            "Type" : AES256Util.encrypt(string: feedbackTypeAsString),
            "Category" : AES256Util.encrypt(string: feedbackCategoryAsString),
            "UID" : userModel?.uid ?? "",
            "Date" : dateFormatter.string(from: Date())
        ]){error in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func getMyFeedback(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Feedback").addSnapshotListener(){(querySnapshot, error) in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            querySnapshot?.documentChanges.forEach{diff in
                let UID = diff.document.get("UID") as? String ?? ""
                
                if UID == userInfo?.uid ?? ""{
                    let id = diff.document.documentID
                    let title = diff.document.get("Title") as? String ?? ""
                    let contents = diff.document.get("Contents") as? String ?? ""
                    let type = diff.document.get("Type") as? String ?? ""
                    let category = diff.document.get("Category") as? String ?? ""
                    let Date = diff.document.get("Date") as? String ?? ""
                    let answer = diff.document.get("Answer") as? String ?? ""
                    let answer_author = diff.document.get("Answer_Author") as? String ?? ""
                    let answer_date = diff.document.get("Answer_Date") as? String ?? ""
                    
                    switch diff.type{
                    case .added:
                        if !self.myfeedbackList.contains(where: {$0.id == id}){
                            self.myfeedbackList.append(FeedbackHubDataModel(name: "", studentNo: "", college: "", title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), category: self.convertFeedbackCategory(category: AES256Util.decrypt(encoded: category)), type: self.convertFeedbackType(type: AES256Util.decrypt(encoded: type)), id : id, uid : UID, date : Date, answer : AES256Util.decrypt(encoded: answer), answer_author : AES256Util.decrypt(encoded: answer_author), answer_date : answer_date))
                        }
                        
                    case .modified:
                        let index = self.myfeedbackList.firstIndex(where: {$0.id == id})
                        
                        if index != nil{
                            self.myfeedbackList[index!] = FeedbackHubDataModel(name: "", studentNo: "", college: "", title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), category: self.convertFeedbackCategory(category: AES256Util.decrypt(encoded: category)), type: self.convertFeedbackType(type: AES256Util.decrypt(encoded: type)), id : id, uid : UID, date : Date, answer : AES256Util.decrypt(encoded: answer), answer_author : AES256Util.decrypt(encoded: answer_author),answer_date : answer_date)
                        }
                        
                        else{
                            self.myfeedbackList.append(FeedbackHubDataModel(name: "", studentNo: "", college: "", title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), category: self.convertFeedbackCategory(category: AES256Util.decrypt(encoded: category)), type: self.convertFeedbackType(type: AES256Util.decrypt(encoded: type)), id : id, uid : UID, date : Date, answer : AES256Util.decrypt(encoded: answer), answer_author : AES256Util.decrypt(encoded: answer_author), answer_date : answer_date))
                        }
                        
                        
                    case .removed:
                        let index = self.myfeedbackList.firstIndex(where: {$0.id == id})

                        if index != nil{
                            self.myfeedbackList.remove(at: index!)
                        }
                    }
                }
                
            }
        }
    }
    
    func getAllFeedback(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Feedback").addSnapshotListener(){(querySnapshot, error) in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            if userInfo?.admin == nil{
                completion(false)
                
                return
            }
            
            
            querySnapshot?.documentChanges.forEach{diff in
                let id = diff.document.documentID
                let author = diff.document.get("Author") as? String ?? ""
                let title = diff.document.get("Title") as? String ?? ""
                let contents = diff.document.get("Contents") as? String ?? ""
                let type = diff.document.get("Type") as? String ?? ""
                let category = diff.document.get("Category") as? String ?? ""
                let UID = diff.document.get("UID") as? String ?? ""
                let Date = diff.document.get("Date") as? String ?? ""
                let answer = diff.document.get("Answer") as? String ?? ""
                let answer_author = diff.document.get("Answer_Author") as? String ?? ""
                let answer_date = diff.document.get("Answer_Date") as? String ?? ""
                
                let author_decrypted = AES256Util.decrypt(encoded: author.replacingOccurrences(of: "\n", with: ""))
                let author_splited = author_decrypted.components(separatedBy: " ")
                
                switch diff.type{
                case .added:
                    if !self.feedbackList.contains(where: {$0.id == id}){
                        self.feedbackList.append(FeedbackHubDataModel(name: author_splited[2], studentNo: author_splited[1], college: author_splited[0], title: AES256Util.decrypt(encoded: title.replacingOccurrences(of: "\n", with: "")), contents: AES256Util.decrypt(encoded: contents.replacingOccurrences(of: "\n", with: "")), category: self.convertFeedbackCategory(category: AES256Util.decrypt(encoded: category.replacingOccurrences(of: "\n", with: ""))), type: self.convertFeedbackType(type: AES256Util.decrypt(encoded: type.replacingOccurrences(of: "\n", with: ""))), id : id, uid : UID, date : Date, answer : AES256Util.decrypt(encoded: answer.replacingOccurrences(of: "\n", with: "")), answer_author : AES256Util.decrypt(encoded: answer_author.replacingOccurrences(of: "\n", with: "")), answer_date : answer_date.replacingOccurrences(of: "\n", with: "")))
                    }
                    
                case .modified:
                    let index = self.feedbackList.firstIndex(where: {$0.id == id})
                    
                    if index != nil{
                        self.feedbackList[index!] = FeedbackHubDataModel(name: author_splited[2], studentNo: author_splited[1], college: author_splited[0], title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), category: self.convertFeedbackCategory(category: AES256Util.decrypt(encoded: category)), type: self.convertFeedbackType(type: AES256Util.decrypt(encoded: type)), id : id, uid : UID, date : Date, answer : AES256Util.decrypt(encoded: answer), answer_author : AES256Util.decrypt(encoded: answer_author), answer_date : answer_date)
                    }
                    
                    else{
                        self.feedbackList.append(FeedbackHubDataModel(name: author_splited[2], studentNo: author_splited[1], college: author_splited[0], title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), category: self.convertFeedbackCategory(category: AES256Util.decrypt(encoded: category)), type: self.convertFeedbackType(type: AES256Util.decrypt(encoded: type)), id : id, uid : UID, date : Date, answer : AES256Util.decrypt(encoded: answer), answer_author : AES256Util.decrypt(encoded: answer_author), answer_date : answer_date))
                    }
                    
                    
                case .removed:
                    let index = self.feedbackList.firstIndex(where: {$0.id == id})

                    if index != nil{
                        self.feedbackList.remove(at: index!)
                    }
                }
            }
        }
    }
    
    func writeAnswer(model : FeedbackHubDataModel, answer : String, userModel : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
        
        self.db.collection("Feedback").document(model.id).updateData([
            "Answer" : AES256Util.encrypt(string: answer),
            "Answer_Author" : AES256Util.encrypt(string: userModel?.spot ?? ""),
            "Answer_Date" : dateFormatter.string(from: Date())
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    
    func convertFeedbackType(type : String) -> FeedbackHubTypeModel?{
        var feedbackType : FeedbackHubTypeModel?
        
        switch type{
        case "칭찬해요":
            feedbackType = .Good
            
        case "개선해주세요":
            feedbackType = .Bad
            
        case "궁금해요":
            feedbackType = .Question
            
        default:
            feedbackType = nil
        }
        
        return feedbackType
    }
    
    func convertFeedbackCategory(category : String) -> FeedbackHubCategoryModel?{
        var feedbackCategory : FeedbackHubCategoryModel?
        
        switch category{
        case "복지":
            feedbackCategory = .Welfare
            
        case "행사":
            feedbackCategory = .Event

        case "공약":
            feedbackCategory = .Pledge

        case "시설":
            feedbackCategory = .Facility

        case "앱":
            feedbackCategory = .App

        case "소통":
            feedbackCategory = .Communication

        case "기타":
            feedbackCategory = .Others

        default:
            feedbackCategory = .Others
        }
        
        
        return feedbackCategory
    }
}
