//
//  AllianceHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import Foundation
import Firebase

class AllianceHelper : ObservableObject{
    let userInfo : UserInfoModel?
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @Published var imgList : [UIImage] = []
    @Published var allianceList : [AllianceDataModel] = []
    
    init(userInfo : UserInfoModel?){
        self.userInfo = userInfo
    }
    
    func getAdList(completion : @escaping(_ result : Bool?) -> Void){
        let userManagement = UserManagement()
        
        self.imgList.removeAll()
        for i in 1...3{
            if userInfo?.collegeCode == .SOC || userInfo?.collegeCode == .COM || userInfo?.collegeCode == .COH || userInfo?.collegeCode == .CON || userInfo?.collegeCode == .CHE || userInfo?.collegeCode == .ENG{
                let imgReference = storage.reference(withPath : "\(userManagement.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode))/ad/ad_\(i).png")
                
                imgReference.getData(maxSize : 1*1024*1024){data, error in
                    if let error = error{
                        print(error)
                        completion(false)
                        
                        return
                    }
                    
                    else{
                        self.imgList.append(UIImage(data : data!)!)
                    }
                }
            }
            
            else{
                let imgReference = storage.reference(withPath : "CH/ad/ad_\(i).png")
                
                imgReference.getData(maxSize : 1*1024*1024){data, error in
                    if let error = error{
                        print(error)
                        completion(false)
                        
                        return
                    }
                    
                    else{
                        self.imgList.append(UIImage(data : data!)!)
                    }
                }
            }
            
        }
        
        completion(true)
        
    }
    
    func getAllianceList(category : String, completion : @escaping(_ result : Bool?) -> Void){
        var categoryCode = convertCategoryCode(category: category)
        let userManagement = UserManagement()
        
        if categoryCode == "All"{
            self.db.collection("Affiliate").document(userManagement.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    completion(false)
                    
                    return
                }
                
                else{
                    if let document = document{
                        if document.exists{
                            let data = document.data()! as! [String : Any]
                            
                            for index in data.keys{
                                let storeListData = document.data()![index]! as! [String : Any]
                                
                                for store in storeListData.keys{
                                    let storeData = storeListData[store] as! [String : String?]
                                    let id : String = storeData["id"] as? String ?? ""
                                    let storeLogoRef = self.storage.reference(withPath : "storeLogo/\(id).png")
                                    
                                    storeLogoRef.downloadURL{url, error in
                                        if error != nil{
                                            print(error)
                                        }
                                        
                                        if !self.allianceList.contains(where: {$0.id == storeData["id"] ?? ""}){
                                            self.allianceList.append(AllianceDataModel(storeName: store,
                                                                                       benefits: storeData["benefits"] ?? "",
                                                                                       breakTime: storeData["breakTime"] ?? "",
                                                                                       closeTime: storeData["closeTime"] ?? "",
                                                                                       closed: storeData["closed"] ?? "",
                                                                                       id: storeData["id"] ?? "",
                                                                                       location: storeData["location"] ?? "",
                                                                                       menu: storeData["menu"] ?? "",
                                                                                       openTime: storeData["openTime"] ?? "",
                                                                                       price: storeData["price"] ?? "",
                                                                                       tel: storeData["tel"] ?? "",
                                                                                       storeLogo: url,
                                                                                       allianceType : "단대"))
                                        }
                                        
                                        else{
                                            let index = self.allianceList.firstIndex(where: {$0.id == storeData["id"] ?? ""})
                                            
                                            if index != nil{
                                                if self.allianceList[index!].allianceType != "단대"{
                                                    self.allianceList.append(AllianceDataModel(storeName: store,
                                                                                               benefits: storeData["benefits"] ?? "",
                                                                                               breakTime: storeData["breakTime"] ?? "",
                                                                                               closeTime: storeData["closeTime"] ?? "",
                                                                                               closed: storeData["closed"] ?? "",
                                                                                               id: storeData["id"] ?? "",
                                                                                               location: storeData["location"] ?? "",
                                                                                               menu: storeData["menu"] ?? "",
                                                                                               openTime: storeData["openTime"] ?? "",
                                                                                               price: storeData["price"] ?? "",
                                                                                               tel: storeData["tel"] ?? "",
                                                                                               storeLogo: url,
                                                                                               allianceType : "단대"))
                                                }
                                            }
                                            
                                            else{
                                                self.allianceList.append(AllianceDataModel(storeName: store,
                                                                                           benefits: storeData["benefits"] ?? "",
                                                                                           breakTime: storeData["breakTime"] ?? "",
                                                                                           closeTime: storeData["closeTime"] ?? "",
                                                                                           closed: storeData["closed"] ?? "",
                                                                                           id: storeData["id"] ?? "",
                                                                                           location: storeData["location"] ?? "",
                                                                                           menu: storeData["menu"] ?? "",
                                                                                           openTime: storeData["openTime"] ?? "",
                                                                                           price: storeData["price"] ?? "",
                                                                                           tel: storeData["tel"] ?? "",
                                                                                           storeLogo: url,
                                                                                           allianceType : "단대"))
                                            }
                                            

                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            print(self.allianceList)
            
            self.db.collection("Affiliate").document("CH").getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    completion(false)
                    
                    return
                }
                
                else{
                    if let document = document{
                        if document.exists{
                            let data = document.data()! as! [String : Any]
                            
                            for index in data.keys{
                                let storeListData = document.data()![index]! as! [String : Any]
                                
                                for store in storeListData.keys{
                                    let storeData = storeListData[store] as! [String : String?]
                                    let id : String = storeData["id"] as? String ?? ""
                                    let storeLogoRef = self.storage.reference(withPath : "storeLogo/\(id).png")
                                    
                                    storeLogoRef.downloadURL{url, error in
                                        if error != nil{
                                            print(error)
                                        }
                                        
                                        if !self.allianceList.contains(where : {$0.id == storeData["id"] ?? ""}){
                                            self.allianceList.append(AllianceDataModel(storeName: store,
                                                                                       benefits: storeData["benefits"] ?? "",
                                                                                       breakTime: storeData["breakTime"] ?? "",
                                                                                       closeTime: storeData["closeTime"] ?? "",
                                                                                       closed: storeData["closed"] ?? "",
                                                                                       id: storeData["id"] ?? "",
                                                                                       location: storeData["location"] ?? "",
                                                                                       menu: storeData["menu"] ?? "",
                                                                                       openTime: storeData["openTime"] ?? "",
                                                                                       price: storeData["price"] ?? "",
                                                                                       tel: storeData["tel"] ?? "",
                                                                                       storeLogo: url,
                                                                                       allianceType : "총학"))
                                        }
                                        
                                        else{
                                            let index = self.allianceList.firstIndex(where: {$0.id == storeData["id"] ?? ""})
                                            
                                            if index != nil{
                                                if self.allianceList[index!].allianceType != "총학"{
                                                    self.allianceList.append(AllianceDataModel(storeName: store,
                                                                                               benefits: storeData["benefits"] ?? "",
                                                                                               breakTime: storeData["breakTime"] ?? "",
                                                                                               closeTime: storeData["closeTime"] ?? "",
                                                                                               closed: storeData["closed"] ?? "",
                                                                                               id: storeData["id"] ?? "",
                                                                                               location: storeData["location"] ?? "",
                                                                                               menu: storeData["menu"] ?? "",
                                                                                               openTime: storeData["openTime"] ?? "",
                                                                                               price: storeData["price"] ?? "",
                                                                                               tel: storeData["tel"] ?? "",
                                                                                               storeLogo: url,
                                                                                               allianceType : "총학"))
                                                }
                                            }
                                            
                                            else{
                                                self.allianceList.append(AllianceDataModel(storeName: store,
                                                                                           benefits: storeData["benefits"] ?? "",
                                                                                           breakTime: storeData["breakTime"] ?? "",
                                                                                           closeTime: storeData["closeTime"] ?? "",
                                                                                           closed: storeData["closed"] ?? "",
                                                                                           id: storeData["id"] ?? "",
                                                                                           location: storeData["location"] ?? "",
                                                                                           menu: storeData["menu"] ?? "",
                                                                                           openTime: storeData["openTime"] ?? "",
                                                                                           price: storeData["price"] ?? "",
                                                                                           tel: storeData["tel"] ?? "",
                                                                                           storeLogo: url,
                                                                                           allianceType : "총학"))
                                            }
                                            

                                        }
                                        
                                    }
                                }
    
                            }
                            
                            completion(true)
                            
                        }
                    }
                    
                    
                    
                    
                }
            }
        }
        
        else{
            self.db.collection("Affiliate").document(userManagement.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    completion(false)
                    
                    return
                }
                
                else{
                    if let document = document{
                        if document.exists{
                            let data = document.data()![categoryCode]! as! [String : Any]
                            
                            for index in data.keys{
                                let storeData = data[index] as! [String : String?]
                                let id : String = storeData["id"] as? String ?? ""
                                let storeLogoRef = self.storage.reference(withPath : "storeLogo/\(id).png")
                                
                                storeLogoRef.downloadURL{url, error in
                                    if error != nil{
                                        print(error)
                                    }
                                    
                                    self.allianceList.append(AllianceDataModel(storeName: index,
                                                                               benefits: storeData["benefits"] ?? "",
                                                                               breakTime: storeData["breakTime"] ?? "",
                                                                               closeTime: storeData["closeTime"] ?? "",
                                                                               closed: storeData["closed"] ?? "",
                                                                               id: storeData["id"] ?? "",
                                                                               location: storeData["location"] ?? "",
                                                                               menu: storeData["menu"] ?? "",
                                                                               openTime: storeData["openTime"] ?? "",
                                                                               price: storeData["price"] ?? "",
                                                                               tel: storeData["tel"] ?? "",
                                                                               storeLogo: url,
                                                                               allianceType : "단대"))
                                }
                            }
                        }
                    }
                }
                
                print(self.allianceList)
                
                self.db.collection("Affiliate").document("CH").getDocument(){(document, error) in
                    if error != nil{
                        print(error)
                        completion(false)
                        
                        return
                    }
                    
                    else{
                        if let document = document{
                            if document.exists{
                                let data = document.data()![categoryCode]! as! [String : Any]
                                
                                for index in data.keys{
                                    let storeData = data[index] as! [String : String?]
                                    let id : String = storeData["id"] as? String ?? ""
                                    let storeLogoRef = self.storage.reference(withPath : "storeLogo/\(id).png")
                                    
                                    storeLogoRef.downloadURL{url, error in
                                        if error != nil{
                                            print(error)
                                        }
                                        
                                        self.allianceList.append(AllianceDataModel(storeName: index,
                                                                                   benefits: storeData["benefits"] ?? "",
                                                                                   breakTime: storeData["breakTime"] ?? "",
                                                                                   closeTime: storeData["closeTime"] ?? "",
                                                                                   closed: storeData["closed"] ?? "",
                                                                                   id: storeData["id"] ?? "",
                                                                                   location: storeData["location"] ?? "",
                                                                                   menu: storeData["menu"] ?? "",
                                                                                   openTime: storeData["openTime"] ?? "",
                                                                                   price: storeData["price"] ?? "",
                                                                                   tel: storeData["tel"] ?? "",
                                                                                   storeLogo: url,
                                                                                   allianceType : "총학"))
                                    }
                                    
                                    
                                }
                                
                                completion(true)
                                
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    
    func convertCategoryCode(category : String) -> String{
        var categoryCode = ""
        
        switch category{
        case "전체" :
            categoryCode = "All"
            
        case "식사" :
            categoryCode = "Meal"
            
        case "카페" :
            categoryCode = "Cafe"
            
        case "술" :
            categoryCode = "Alcohol"
            
        case "편의" :
            categoryCode = "Convenience"
            
        default:
            break
        }
        
        return categoryCode
    }
}
