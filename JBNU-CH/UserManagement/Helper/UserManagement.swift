//
//  UserManagement.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/23.
//

import Foundation
import FirebaseMLVision
import Firebase
import SwiftUI

class UserManagement : ObservableObject{
    private let db = Firestore.firestore()
    private let storageRef = Storage.storage().reference()
    private let auth = Auth.auth()
    private let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    private let storage = Storage.storage()
    
    @Published var legacyUserInfo : UserInfoModel? = nil
    @Published var userInfo : UserInfoModel?
    
    func secession(completion : @escaping(_ result : Bool?) -> Void){
        let uid = auth.currentUser?.uid
        
        db.collection("Users").document(uid ?? "").delete(){error in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            else{
                self.auth.currentUser?.delete{error in
                    if let error = error{
                        print(error)
                        
                        completion(false)
                        return
                    }
                    
                    completion(true)
                }
            }
        }
    }
    
    func signIn(email : String, password : String, completion: @escaping(_ result : UserManagementResultModel?) -> Void){
        auth.signIn(withEmail: email.lowercased(), password: password){(authResult, error) in
            if error != nil{
                print(error)
                
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    if errCode == .networkError{
                        completion(.networkError)
                    }
                    
                    else if errCode == .userNotFound{
                        let userRef = self.db.collection("User").document(email)
                        
                        userRef.getDocument(){(document, error) in
                            if let document = document{
                                if document.exists{
                                    completion(.legacyUser)
                                }
                                
                                else{
                                    completion(.userNotFound)
                                }
                            }
                            
                        }
                        
                    }
                    
                    else if errCode == .userTokenExpired{
                        completion(.userTokenExpired)
                    }
                    
                    else if errCode == .tooManyRequests{
                        completion(.tooManyRequests)
                    }
                    
                    else if errCode == .invalidAPIKey{
                        completion(.invalidAPIKey)
                    }
                    
                    else if errCode == .appNotAuthorized{
                        completion(.appNotAuthorized)
                    }
                    
                    else if errCode == .keychainError{
                        completion(.keychainError)
                    }
                    
                    else if errCode == .internalError{
                        completion(.internalError)
                    }
                    
                    else if errCode == .operationNotAllowed{
                        completion(.operationNotAllowed)
                    }
                    
                    else if errCode == .wrongPassword{
                        completion(.wrongPassword)
                    }
                    
                    else if errCode == .invalidEmail{
                        completion(.invalidEmail)
                    }
                    
                    else if errCode == .userDisabled{
                        completion(.userDisabled)
                    }
                    
                    else{
                        completion(.unknownError)
                    }
                }
                
            }
            
            else{
                self.db.collection("Users").document(self.auth.currentUser?.uid ?? "").updateData(["token" : Messaging.messaging().fcmToken ?? ""])
                UserDefaults.standard.set(email.lowercased(), forKey: "SignIn_email")
                UserDefaults.standard.set(password, forKey : "SignIn_password")
                
                self.getUserInfo(){result in
                    guard let result = result else{return}
                    
                    completion(result)
                }
            }
        }
    }
    
    func removeLegacyData(email : String, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("User").document(email).delete(){err in
            if err != nil{
                print(err)
                
                completion(false)
            }
            
            else{
                completion(true)
            }
        }
    }
    
    func changeCollege(college : String, completion : @escaping(_ result : Bool?) -> Void){
        let collegeCode = self.convertCollegeCode(college: college)
        let collegeCodeAsString = self.convertCollegeCodeAsString(collegeCode: collegeCode)
        
        db.collection("Users").document(userInfo?.uid ?? "").updateData([
            "college" : AES256Util.encrypt(string: college),
            "collegeCode" : collegeCodeAsString
        ]){error in
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
    
    func getUserInfo(completion : @escaping(_ result : UserManagementResultModel?) -> Void){
        if auth.currentUser?.uid == nil{
            completion(.userTokenExpired)
            
            return
        }
        
        
        self.db.collection("Users").document(auth.currentUser?.uid ?? "").getDocument(){(document, error) in
            if error != nil{
                print(error)
                
                completion(.internalError)
                
                return
            }
            
            else{
                if let document = document{
                    if document.exists{
                        let name = document.get("name") as? String ?? ""
                        let phone = document.get("phone") as? String ?? ""
                        let studentNo = document.get("studentNo") as? String ?? ""
                        let college = document.get("college") as? String ?? ""
                        let admin = document.get("admin") as? String ?? ""
                        let belong = document.get("belong") as? String ?? ""
                        
                        let profileRef = self.storage.reference(withPath: "Profile/\(self.auth.currentUser?.uid ?? "").png")
                                                
                        var adminAsModel : AdminCodeModel? = nil
                        var spotAsString = ""
                        
                        if admin != "" && belong != ""{
                            adminAsModel = self.convertAdminCode(admin: belong + "_" + admin)
                            spotAsString = self.convertAdminCodeAsString(adminCode: adminAsModel)
                        }
                        
                        profileRef.downloadURL{url, error in
                            if error != nil{
                                self.userInfo = UserInfoModel(name: AES256Util.decrypt(encoded : name),
                                                              phone: AES256Util.decrypt(encoded : phone),
                                                              studentNo: AES256Util.decrypt(encoded : studentNo),
                                                              college: AES256Util.decrypt(encoded : college),
                                                              collegeCode: self.convertCollegeCode(college: AES256Util.decrypt(encoded: college)),
                                                              uid : self.auth.currentUser?.uid ?? "",
                                                              admin : adminAsModel,
                                                              spot : spotAsString,
                                                              profile : nil,
                                                              countryCode : nil)
                            }
                            
                            else{
                                self.userInfo = UserInfoModel(name: AES256Util.decrypt(encoded : name),
                                                              phone: AES256Util.decrypt(encoded : phone),
                                                              studentNo: AES256Util.decrypt(encoded : studentNo),
                                                              college: AES256Util.decrypt(encoded : college),
                                                              collegeCode: self.convertCollegeCode(college: AES256Util.decrypt(encoded: college)),
                                                              uid : self.auth.currentUser?.uid ?? "",
                                                              admin : adminAsModel,
                                                              spot : spotAsString,
                                                              profile : url,
                                                              countryCode : nil)
                            }
                            
                            Messaging.messaging().subscribe(toTopic: "Notice_CH"){error in
                                if error != nil{
                                    print(error)
                                }
                            }
                        }
                        

                                                
                        completion(.success)
                    }
                    
                    else{
                        completion(.userNotFound)
                        
                        return
                    }
                }
            }
        }
    }
    
    func signUp(email : String, password : String, userModel : UserInfoModel, completion : @escaping(_ result : UserManagementResultModel?) -> Void){
        self.db.collection("Users").whereField("studentNo", isEqualTo : AES256Util.encrypt(string: userModel.studentNo ?? "")).getDocuments(){(querySnapshot, err) in
            if querySnapshot != nil && querySnapshot!.documents.count >= 1{
                completion(.registeredUser)
            }
            
            else{
                self.auth.createUser(withEmail : email.lowercased(), password: password){(authResult, error) in
                    if error != nil{
                        if let errCode = AuthErrorCode(rawValue: error!._code){
                            if errCode == .networkError{
                                completion(.networkError)
                            }
                            
                            else if errCode == .tooManyRequests{
                                completion(.tooManyRequests)
                            }
                            
                            else if errCode == .invalidAPIKey{
                                completion(.invalidAPIKey)
                            }
                            
                            else if errCode == .appNotAuthorized{
                                completion(.appNotAuthorized)
                            }
                            
                            else if errCode == .keychainError{
                                completion(.keychainError)
                            }
                            
                            else if errCode == .internalError{
                                completion(.internalError)
                            }
                            
                            else if errCode == .operationNotAllowed{
                                completion(.operationNotAllowed)
                            }
                            
                            else if errCode == .invalidEmail{
                                completion(.invalidEmail)
                            }
                            
                            else if errCode == .weakPassword{
                                completion(.weakPassword)
                            }
                            
                            else if errCode == .emailAlreadyInUse{
                                completion(.EmailAlreadyInUse)
                            }
                            
                            else{
                                completion(.unknownError)
                            }
                        }
                    }
                    
                    else{
                        let userRef = self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "")
                        
                        let userData : [String : Any] = [
                            "college" : AES256Util.encrypt(string: userModel.college ?? ""),
                            "studentNo" : AES256Util.encrypt(string: userModel.studentNo ?? ""),
                            "name" : AES256Util.encrypt(string: userModel.name ?? ""),
                            "phone" : AES256Util.encrypt(string: userModel.phone ?? ""),
                            "collegeCode" : self.convertCollegeCodeAsString(collegeCode: self.convertCollegeCode(college: userModel.college ?? ""))
                        ]
                        
                        userRef.setData(userData){error in
                            if error != nil{
                                print(error)
                                
                                completion(.internalError)
                                
                                return
                            }
                            
                            else{
                                UserDefaults.standard.set("SignIn_email", forKey: email.lowercased())
                                UserDefaults.standard.set("SignIn_password", forKey : password)
                                
                                self.getUserInfo(){result in
                                    guard let result = result else{return}
                                    
                                    completion(result)
                                }
                            }
                        }
                    }
                }
            }
        }
        

    }
    
    func signOut(completion : @escaping(_ result : Bool?) -> Void){
        do{
            try auth.signOut()
            
            self.userInfo = UserInfoModel(name: "", phone: "", studentNo: "", college: "", collegeCode: nil, uid: "", admin: nil, spot : "", profile : nil, countryCode : nil)
            UserDefaults.standard.removeObject(forKey: "SignIn_email")
            UserDefaults.standard.removeObject(forKey: "SignIn_password")

            completion(true)
        } catch let error as NSError{
            print(error)
            completion(false)
            
            return
        }
    }
    
    func getLegacyUserData(email : String, completion : @escaping(_ result : UserManagementResultModel?) -> Void){
        let legacyUserRef = self.db.collection("User").document(email)
        
        legacyUserRef.getDocument(){(document, error) in
            if error != nil{
                completion(.internalError)
                
                return
            }
            
            if let document = document{
                if document.exists{
                    let dept = document.get("dept") as? String ?? ""
                    let studentNo = document.get("studentNo") as? String ?? ""
                    let name = document.get("name") as? String ?? ""
                    let phone = document.get("phone") as? String ?? ""
                    
                    self.legacyUserInfo = UserInfoModel(name: name, phone: phone, studentNo: studentNo, college: "공과대학 (" + dept + ")", collegeCode: self.convertCollegeCode(college: "공과대학"), uid : Auth.auth().currentUser?.uid ?? "", admin : nil, spot : "", profile : nil, countryCode : nil)
                    
                    completion(.success)
                }
                
                else{
                    completion(.userNotFound)
                }
            }
        }
    }
    
    func transferData(email : String, completion : @escaping(_ result : UserManagementResultModel?) -> Void){
        let legacyUserRef = self.db.collection("User").document(email)
        
        legacyUserRef.getDocument(){(document, error) in
            if error != nil{
                completion(.internalError)
                
                return
            }
            
            if let document = document{
                if document.exists{
                    let dept = "공과대학"
                    let studentNo = document.get("studentNo") as? String ?? ""
                    let name = document.get("name") as? String ?? ""
                    let phone = document.get("phone") as? String ?? ""
                    
                    self.signUp(email: email, password: self.str.createRandomStr(length: 128), userModel: UserInfoModel(name: name, phone: phone, studentNo: studentNo, college: dept, collegeCode: self.convertCollegeCode(college: dept), uid : "", admin : nil, spot : "", profile : nil, countryCode : nil)){result in
                        guard let result = result else{return}
                        
                        if result != .success{
                            completion(result)
                        }
                        
                        else{
                            legacyUserRef.delete(){error in
                                if error != nil{
                                    print(error)
                                    
                                    completion(.internalError)
                                    
                                    return
                                }
                                
                                else{
                                    self.auth.sendPasswordReset(withEmail: email){error in
                                        if error != nil{
                                            print(error)
                                            
                                            completion(.internalError)
                                            
                                            return
                                        }
                                        
                                        else{
                                            self.userInfo?.uid = Auth.auth().currentUser?.uid ?? ""
                                            completion(.success)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                }
                
                else{
                    completion(.userNotFound)
                    
                    return
                }
            }
        }
    }
    
    func sendPasswordResetMail(email : String, completion : @escaping(_ result : UserManagementResultModel?) -> Void){
        auth.sendPasswordReset(withEmail: email){error in
            if error != nil{
                print(error)
                
                completion(.internalError)
            }
            
            else{
                completion(.success)
            }
        }
    }
    
    func changePassword(password : String, isSignOut : Bool, completion : @escaping(_ result : Bool?) -> Void){
        auth.currentUser?.updatePassword(to : password){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            if isSignOut{
                self.signOut(){result in
                    guard let result = result else{return}
                }
            }
            
            else{
                UserDefaults.standard.set(password, forKey : "SignIn_password")
            }
            
            completion(true)
        }
    }
    
    func changePhone(phone : String, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Users").document(auth.currentUser?.uid ?? "").updateData([
            "phone" : AES256Util.encrypt(string: phone)
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            self.getUserInfo(){result in
                guard let result = result else{return}
                
                completion(true)
            }
            
        }
    }
    

    
    func ValidateIDCard(IDCard : UIImage?, studentNo : String, name : String, college : String, completion:@escaping(_ result : UserManagementResultModel?) -> Void){
        let vision = Vision.vision()
        
        var resultName = false
        var resultStudentNo = false
        var resultSchool = false
        var resultCollege = false
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["ko"]
        
        let textRecognizer = vision.cloudTextRecognizer(options: options)
        
        let image = VisionImage(image : IDCard!)

        textRecognizer.process(image){result, error in
            guard error == nil, let result = result else{
                completion(.internalError)
                                
                return
            }
                        
            let validateGroup = DispatchGroup()

            validateGroup.enter()
            
            for block in result.blocks{

                for line in block.lines{
                    let lineText = line.text
                    let line_num = lineText
                        .components(separatedBy:CharacterSet.decimalDigits.inverted)
                        .joined()
                    
                    print(lineText)
                    
                    if line_num.contains(studentNo){
                        resultStudentNo = true
                        print("studentNo detected")
                    }
                    
                    if lineText.contains(name.trimmingCharacters(in: .whitespacesAndNewlines)){
                        resultName = true
                        print("name detected")
                    }
                    
                    if lineText.contains("재학생") || lineText.contains("휴학생"){
                        resultSchool = true
                        print("school detected")
                    }
                    
                    if lineText.contains(college){
                        resultCollege = true
                        print("college detected")
                    }
                }
            }
            
            validateGroup.leave()

            validateGroup.notify(queue:.main){
                if resultName && resultStudentNo && resultSchool && resultCollege{
                    completion(.success)
                }
                
                else{
                    completion(.IDCardValidationFailed)
                }
            }
            

        }
    }
    
    func detectNoticePermission() -> Bool{
        switch self.userInfo?.admin{
        case .none:
            return false
            
        case .CH_President:
            return true

        case .CH_VicePresident:
            return true

        case .CH_Execution_President:
            return false

        case .some(.CH_Execution_VicePresident):
            return false

        case .some(.CH_ExternalCoop_President):
            return false

        case .some(.CH_ExternalCoop_VicePresident):
            return false

        case .some(.CH_ExternalCoop_Member):
            return false

        case .some(.CH_Culture_President):
            return false

        case .some(.CH_Culture_VicePresident):
            return false

        case .some(.CH_Culture_Member):
            return false

        case .some(.CH_Affairs_President):
            return false

        case .some(.CH_Affairs_VicePresident):
            return false

        case .some(.CH_Affairs_Member):
            return false

        case .some(.CH_Facility_President):
            return false

        case .some(.CH_Facility_VicePresident):
            return false

        case .some(.CH_Facility_Member):
            return false

        case .some(.CH_Policy_President):
            return false

        case .some(.CH_Policy_VicePresident):
            return false

        case .some(.CH_Policy_Member):
            return false

        case .some(.CH_Employment_President):
            return false

        case .some(.CH_Employment_VicePresident):
            return false

        case .some(.CH_Employment_Member):
            return false

        case .some(.CH_Welfare_President):
            return false

        case .some(.CH_Welfare_VicePresident):
            return false

        case .some(.CH_Welfare_Member):
            return false

        case .some(.CH_PRD_President):
            return true

        case .some(.CH_PRD_VicePresident):
            return true

        case .some(.CH_PRD_Member):
            return true

        case .some(.SOC_President):
            return true

        case .some(.SOC_VicePresident):
            return true

        case .some(.COM_President):
            return true

        case .some(.COM_VicePresident):
            return true

        case .some(.COH_President):
            return true

        case .some(.COH_VicePresident):
            return true

        case .some(.CON_President):
            return true

        case .some(.CON_VicePresident):
            return true

        case .some(.CHE_President):
            return true

        case .some(.CHE_VicePresident):
            return true

        case .some(.SOC_PRD_President):
            return true

        case .some(.SOC_PRD_VicePresident):
            return true

        case .some(.COM_PRD_President):
            return true

        case .some(.COM_PRD_VicePresident):
            return true

        case .some(.COH_PRD_President):
            return true

        case .some(.COH_PRD_VicePresident):
            return true

        case .some(.CON_PRD_President):
            return true

        case .some(.CON_PRD_VicePresident):
            return true

        case .some(.CHE_PRD_President):
            return true

        case .some(.CHE_PRD_VicePresident):
            return true
        }
    }
    
    func convertAdminCode(admin : String) -> AdminCodeModel?{
        var adminCode : AdminCodeModel?
        
        if admin == ""{
            return nil
        }
        
        switch admin{
        case "CH_President":
            adminCode = .CH_President
            
        case "CH_VicePresident":
            adminCode = .CH_VicePresident
            
        case "CH_Execution_President":
            adminCode = .CH_Execution_President
            
        case "CH_Execution_VicePresident":
            adminCode = .CH_Execution_VicePresident
            
        case "CH_ExternalCoop_President":
            adminCode = .CH_ExternalCoop_President
            
        case "CH_ExternalCoop_VicePresident":
            adminCode = .CH_ExternalCoop_VicePresident
            
        case "CH_ExternalCoop_Member":
            adminCode = .CH_ExternalCoop_Member
            
        case "CH_Culture_President":
            adminCode = .CH_Culture_President
            
        case "CH_Culture_VicePresident":
            adminCode = .CH_Culture_VicePresident
            
        case "CH_Culture_Member":
            adminCode = .CH_Culture_Member
            
        case "CH_Affairs_President":
            adminCode = .CH_Affairs_President
            
        case "CH_Affairs_VicePresident":
            adminCode = .CH_Affairs_VicePresident
            
        case "CH_Affairs_Member":
            adminCode = .CH_Affairs_Member
            
        case "CH_Facility_President":
            adminCode = .CH_Facility_President
            
        case "CH_Facility_VicePresident":
            adminCode = .CH_Facility_VicePresident
            
        case "CH_Facility_Member":
            adminCode = .CH_Facility_Member
            
        case "CH_Policy_President":
            adminCode = .CH_Policy_President
            
        case "CH_Policy_VicePresident":
            adminCode = .CH_Policy_VicePresident
            
        case "CH_Policy_Member":
            adminCode = .CH_Policy_Member
            
        case "CH_Employment_President":
            adminCode = .CH_Employment_President
            
        case "CH_Employment_VicePresident":
            adminCode = .CH_Employment_VicePresident
            
        case "CH_Employment_Member":
            adminCode = .CH_Employment_Member
            
        case "CH_Welfare_President":
            adminCode = .CH_Welfare_President
            
        case "CH_Welfare_VicePresident":
            adminCode = .CH_Welfare_VicePresident
            
        case "CH_Welfare_Member":
            adminCode = .CH_Welfare_Member
            
        case "CH_PRD_President":
            adminCode = .CH_PRD_President
            
        case "CH_PRD_VicePresident":
            adminCode = .CH_PRD_VicePresident
            
        case "CH_PRD_Member":
            adminCode = .CH_PRD_Member
            
        case "SOC_President":
            adminCode = .SOC_President
            
        case "SOC_VicePresident":
            adminCode = .SOC_VicePresident
            
        case "SOC_PRD_President":
            adminCode = .SOC_PRD_President
            
        case "SOC_PRD_VicePresident":
            adminCode = .SOC_PRD_VicePresident
            
        case "COM_President":
            adminCode = .COM_President
            
        case "COM_VicePresident":
            adminCode = .COM_VicePresident
            
        case "COM_PRD_President":
            adminCode = .COM_PRD_President
            
        case "COM_PRD_VicePresident":
            adminCode = .COM_PRD_VicePresident
            
        case "COH_President":
            adminCode = .COH_President
            
        case "COH_VicePresident":
            adminCode = .COH_VicePresident
            
        case "COH_PRD_President":
            adminCode = .COH_PRD_President
            
        case "COH_PRD_VicePresident":
            adminCode = .COH_PRD_VicePresident
            
        case "CON_President":
            adminCode = .CON_President
            
        case "CON_VicePresident":
            adminCode = .CON_VicePresident
            
        case "CON_PRD_President":
            adminCode = .CON_PRD_President
            
        case "CON_PRD_VicePresident":
            adminCode = .CON_PRD_VicePresident
            
        case "CHE_President":
            adminCode = .CHE_President
            
        case "CHE_VicePresident":
            adminCode = .CHE_VicePresident
            
        case "CHE_PRD_President":
            adminCode = .CHE_PRD_President
            
        case "CHE_PRD_VicePresident":
            adminCode = .CHE_PRD_VicePresident
            
        default:
            adminCode = nil
        }
        
        return adminCode
    }
    
    func convertCollegeCodeAsShortString(collegeCode : CollegeCodeModel?) -> String{
        var shortString = ""
        
        if collegeCode == nil{
            return shortString
        }
        
        switch collegeCode{
        case .NUR: shortString = "간호대"
        case .ENG: shortString = "공과대"
        case .GFC : shortString = "글융대"
        case .AGR : shortString = "농생대"
        case .COE : shortString = "사범대"
        case .SOC : shortString = "사회대"
        case .COM : shortString = "상과대"
        case .CHE : shortString = "생활대"
        case .VET: shortString = "수의대"
        case .PHA: shortString = "약학대"
        case .ART: shortString = "예술대"
        case .MED : shortString = "의과대"
        case .COH: shortString = "인문대"
        case .CON : shortString = "자연대"
        case .COD: shortString = "치과대"
        case .COB: shortString = "환생대"
        case .COF: shortString = "스마트팜"
        case .none: shortString = ""
        }
        
        return shortString
    }
    
    func convertAdminCodeAsString(adminCode : AdminCodeModel?) -> String{
        var adminCodeAsString = ""
        
        if adminCode == nil{
            return adminCodeAsString
        }
        
        switch adminCode{
        case .none:
            adminCodeAsString = ""
            
        case .CH_President:
            adminCodeAsString = "총학생회장"
            
        case .CH_VicePresident:
            adminCodeAsString = "부총학생회장"
            
        case .CH_Execution_President:
            adminCodeAsString = "총학생회 중앙집행위원장"

        case .some(.CH_Execution_VicePresident):
            adminCodeAsString = "총학생회 중앙집행부위원장"
            
        case .some(.CH_ExternalCoop_President):
            adminCodeAsString = "총학생회 대외협력국장"

        case .some(.CH_ExternalCoop_VicePresident):
            adminCodeAsString = "총학생회 대외협력부국장"

        case .some(.CH_ExternalCoop_Member):
            adminCodeAsString = "총학생회 대외협력국원"

        case .some(.CH_Culture_President):
            adminCodeAsString = "총학생회 문화예술국장"

        case .some(.CH_Culture_VicePresident):
            adminCodeAsString = "총학생회 문화예술부국장"

        case .some(.CH_Culture_Member):
            adminCodeAsString = "총학생회 문화예술국원"

        case .some(.CH_Affairs_President):
            adminCodeAsString = "총학생회 사무국장"

        case .some(.CH_Affairs_VicePresident):
            adminCodeAsString = "총학생회 사무부국장"

        case .some(.CH_Affairs_Member):
            adminCodeAsString = "총학생회 사무국원"

        case .some(.CH_Facility_President):
            adminCodeAsString = "총학생회 시설운영국장"

        case .some(.CH_Facility_VicePresident):
            adminCodeAsString = "총학생회 시설운영부국장"

        case .some(.CH_Facility_Member):
            adminCodeAsString = "총학생회 시설운영국원"

        case .some(.CH_Policy_President):
            adminCodeAsString = "총학생회 정책기획국장"

        case .some(.CH_Policy_VicePresident):
            adminCodeAsString = "총학생회 정책기획부국장"

        case .some(.CH_Policy_Member):
            adminCodeAsString = "총학생회 정책기획국원"

        case .some(.CH_Employment_President):
            adminCodeAsString = "총학생회 취업지원국장"

        case .some(.CH_Employment_VicePresident):
            adminCodeAsString = "총학생회 취업지원부국장"

        case .some(.CH_Employment_Member):
            adminCodeAsString = "총학생회 취업지원국원"

        case .some(.CH_Welfare_President):
            adminCodeAsString = "총학생회 학생복지국장"

        case .some(.CH_Welfare_VicePresident):
            adminCodeAsString = "총학생회 학생복지부국장"

        case .some(.CH_Welfare_Member):
            adminCodeAsString = "총학생회 학생복지국원"

        case .some(.CH_PRD_President):
            adminCodeAsString = "총학생회 홍보국장"

        case .some(.CH_PRD_VicePresident):
            adminCodeAsString = "총학생회 홍보부국장"

        case .some(.CH_PRD_Member):
            adminCodeAsString = "총학생회 홍보국원"

        case .some(.SOC_President):
            adminCodeAsString = "사회과학대학 학생회장"

        case .some(.SOC_VicePresident):
            adminCodeAsString = "사회과학대학 부학생회장"

        case .some(.COM_President):
            adminCodeAsString = "상과대학 학생회장"

        case .some(.COM_VicePresident):
            adminCodeAsString = "상과대학 부학생회장"

        case .some(.COH_President):
            adminCodeAsString = "인문대학 학생회장"

        case .some(.COH_VicePresident):
            adminCodeAsString = "인문대학 부학생회장"

        case .some(.CON_President):
            adminCodeAsString = "자연과학대학 학생회장"

        case .some(.CON_VicePresident):
            adminCodeAsString = "자연과학대학 부학생회장"

        case .some(.CHE_President):
            adminCodeAsString = "생활과학대학 학생회장"

        case .some(.CHE_VicePresident):
            adminCodeAsString = "생활과학대학 부학생회장"
            
        case .some(.SOC_PRD_President):
            adminCodeAsString = "사회과학대학 홍보국장"
            
        case .some(.SOC_PRD_VicePresident):
            adminCodeAsString = "사회과학대학 홍보부국장"

        case .some(.COM_PRD_President):
            adminCodeAsString = "상과대학 홍보국장"

        case .some(.COM_PRD_VicePresident):
            adminCodeAsString = "상과대학 홍보부국장"

        case .some(.COH_PRD_President):
            adminCodeAsString = "인문대학 홍보국장"

        case .some(.COH_PRD_VicePresident):
            adminCodeAsString = "인문대학 홍보부국장"

        case .some(.CON_PRD_President):
            adminCodeAsString = "자연과학대학 홍보국장"

        case .some(.CON_PRD_VicePresident):
            adminCodeAsString = "자연과학대학 홍보부국장"

        case .some(.CHE_PRD_President):
            adminCodeAsString = "생활과학대학 홍보국장"

        case .some(.CHE_PRD_VicePresident):
            adminCodeAsString = "생활과학대학 홍보부국장"

        }
        
        return adminCodeAsString
    }
    
    func convertCollegeCode(college : String) -> CollegeCodeModel?{
        var collegeCode : CollegeCodeModel?
        
        if college == ""{
            return nil
        }
        
        switch college{
        case "간호대학":
            collegeCode = .NUR
            
        case "공과대학":
            collegeCode = .ENG
            
        case "글로벌융합대학":
            collegeCode = .GFC
            
        case "농업생명과학대학":
            collegeCode = .AGR
            
        case "사범대학":
            collegeCode = .COE
            
        case "사회과학대학":
            collegeCode = .SOC
            
        case "상과대학":
            collegeCode = .COM
            
        case "생활과학대학":
            collegeCode = .CHE
            
        case "수의과대학":
            collegeCode = .VET
            
        case "약학대학":
            collegeCode = .PHA
            
        case "예술대학":
            collegeCode = .ART
            
        case "의과대학":
            collegeCode = .MED
            
        case "인문대학":
            collegeCode = .COH
            
        case "자연과학대학":
            collegeCode = .CON
            
        case "치과대학":
            collegeCode = .COD
            
        case "환경생명자원대학":
            collegeCode = .COB
            
        case "스마트팜학과":
            collegeCode = .COF
        default:
            collegeCode = nil
        }
        
        return collegeCode
    }
    
    func convertCollegeCodeAsString(collegeCode : CollegeCodeModel?) -> String{
        var collegeCodeAsString = ""
        
        switch collegeCode{
        case .AGR:
            collegeCodeAsString = "AGR"
            
        case .ART:
            collegeCodeAsString = "ART"
            
        case .CHE:
            collegeCodeAsString = "CHE"
            
        case .COB:
            collegeCodeAsString = "COB"
            
        case .COD:
            collegeCodeAsString = "COD"
            
        case .COE:
            collegeCodeAsString = "COE"
            
        case .COF:
            collegeCodeAsString = "COF"
            
        case .COH:
            collegeCodeAsString = "COH"
            
        case .COM:
            collegeCodeAsString = "COM"
            
        case .CON:
            collegeCodeAsString = "CON"
            
        case .ENG:
            collegeCodeAsString = "ENG"
            
        case .GFC:
            collegeCodeAsString = "GFC"
            
        case .MED:
            collegeCodeAsString = "MED"
            
        case .NUR:
            collegeCodeAsString = "NUR"
            
        case .PHA:
            collegeCodeAsString = "PHA"
            
        case .SOC:
            collegeCodeAsString = "SOC"
            
        case .VET:
            collegeCodeAsString = "VET"
            
        default:
            collegeCodeAsString = ""
        }
        
        return collegeCodeAsString
    }
    
    func updateCountry(country : String, completion : @escaping(_ result : Bool?) -> Void){
        var countryCodeAsString = ""
        
        switch country{
        case "대한민국 (Republic of Korea)":
            countryCodeAsString = "kr"
            
        case "United States":
            countryCodeAsString = "us"

        case "中国 (China)":
            countryCodeAsString = "cn"

        case "日本 (Japan)":
            countryCodeAsString = "jp"

        case "Việt Nam (Vietnam)":
            countryCodeAsString = "vn"

        default:
            completion(false)
            return
        }
        
        if countryCodeAsString == "kr"{
            UserDefaults.standard.set(["ko"], forKey : "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            setLanguage()
        }
        
        else{
            UserDefaults.standard.set(["en"], forKey : "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            setLanguage()
        }
        
        self.db.collection("Users").document(auth.currentUser?.uid ?? "").updateData(["country" : countryCodeAsString]){err in
            if err != nil{
                print(err)
                completion(false)
                
                return
            }
            
            else{
                completion(true)
            }
        }
    }
    
    func setLanguage(){
        let language = UserDefaults.standard.array(forKey : "AppleLanguages")?.first as! String
        let index = language.index(language.startIndex, offsetBy: 2)
        let langCode = String(language[..<index])
        
        let path = Bundle.main.path(forResource: langCode, ofType: "lproj")
        let bundle = Bundle(path : path!)
    }
    
    func detectCountry(completion : @escaping(_ result : UserCountryCode?) -> Void){
        var countryCode : UserCountryCode?
        
        self.db.collection("Users").document(auth.currentUser?.uid ?? "").getDocument(){(document, error) in
            if error != nil{
                print(error)
                
                completion(.unknown)
                
                return
            }
            
            else{
                if document != nil{
                    let document = document
                    
                    let countryCodeAsString = document?.get("country") as? String ?? ""
                    
                    if countryCodeAsString == nil || countryCodeAsString == ""{
                        completion(.unknown)
                        
                        return
                    }
                    
                    else{
                        switch countryCodeAsString{
                        case "kr":
                            countryCode = .kr
                        
                        case "us":
                            countryCode = .us
                            
                        case "cn":
                            countryCode = .cn
                            
                        case "vn":
                            countryCode = .vn
                            
                        case "jp":
                            countryCode = .jp
                            
                        default:
                            countryCode = .unknown
                        }
                        
                        completion(countryCode)
                    }
                }
            }
            
            completion(countryCode)

        }
    }
}
