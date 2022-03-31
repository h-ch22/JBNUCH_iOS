//
//  ProductHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import Foundation
import Firebase

class ProductHelper : ObservableObject{
    @Published var isAvailable = true
    @Published var productList : [ProductDataModel] = []
    @Published var productLogList : [ProductLogDataModel] = []
    
    private let db = Firestore.firestore()
    
    func calcTime(){
        let hour = Calendar.current.component(.hour, from : Date())
        let dayOfWeek = Date().dayNumberOfWeek()!
        
        if dayOfWeek >= 2 && dayOfWeek <= 6{
            if hour >= 9 && hour < 18{
                if hour == 13{
                    isAvailable = false
                }
                
                else{
                    isAvailable = true
                }
            }
            
            else{
                isAvailable = false
            }
        }
        
        else{
            isAvailable = false
        }
    }
    
    func getLog(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        productLogList.removeAll()
        
        db.collection("Products").document("CH").collection("Log").addSnapshotListener{querySnapshot, error in
            guard let documents = querySnapshot?.documents else{return}
            
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            for document in documents{
                if userInfo?.studentNo == AES256Util.decrypt(encoded: document.get("studentNo") as? String ?? ""){
                    let dateTime = document.get("dateTime") as? String ?? ""
                    let number = document.get("number") as? Int ?? 0
                    let product = document.get("product") as? String ?? ""
                    let isReturned = document.get("isReturned") as? Bool ?? false
                    
                    var iconName = ""
                    
                    switch product{
                    case "고데기":
                        iconName = "ic_curlingiron"
                        
                    case "농구공":
                        iconName = "ic_basketball"

                    case "부심기":
                        iconName = "ic_flag"

                    case "족구공":
                        iconName = "ic_football"

                    case "풋살공":
                        iconName = "ic_football"

                    case "돗자리":
                        iconName = "ic_mat"

                    case "족구네트":
                        iconName = "ic_net"

                    case "축구공":
                        iconName = "ic_soccerball"

                    case "조끼 (파랑)":
                        iconName = "ic_uniform_b"

                    case "조끼 (초록)":
                        iconName = "ic_uniform_g"

                    case "조끼 (핑크)":
                        iconName = "ic_unifrom_p"

                    default:
                        iconName = ""
                    }
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
                    let dayAsDate = formatter.date(from: dateTime)
                    let dayLimit = Calendar.current.date(byAdding: .day, value : 3, to: dayAsDate!)
                    let id = document.documentID
                    
                    if !self.productLogList.contains(where: {$0.id == id}){
                        self.productLogList.append(ProductLogDataModel(id: id, productName: product, icName: iconName, isReturned: isReturned, dateTime: dateTime, number: String(number), dayLimit: formatter.string(from: dayLimit!)))
                    }
                    
                }
            }
            
            completion(true)
        }
    }
    
    func getProductList(type : String, completion : @escaping(_ result : Bool?) -> Void){
        productList.removeAll()
        
        switch type{
        case "CH":
            db.collection("Products").document("CH").getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                if document != nil{
                    let data = document?.data() as [String : Any]
                    
                    for index in data{
                        let dataMap = index.value as! [String : Any]
                        let productName = index.key
                        
                        let all = dataMap["all"] as? Int ?? 0
                        let late = dataMap["late"] as? Int ?? 0
                        
                        var productName_KR = ""
                        var iconName = ""
                        
                        switch productName{
                        case "CurlingIron":
                            productName_KR = "고데기"
                            iconName = "ic_curlingiron"
                            
                        case "basketBall":
                            productName_KR = "농구공"
                            iconName = "ic_basketball"

                        case "flag":
                            productName_KR = "부심기"
                            iconName = "ic_flag"

                        case "footBall":
                            productName_KR = "족구공"
                            iconName = "ic_football"

                        case "futsalBall":
                            productName_KR = "풋살공"
                            iconName = "ic_football"

                        case "mat":
                            productName_KR = "돗자리"
                            iconName = "ic_mat"

                        case "net":
                            productName_KR = "족구네트"
                            iconName = "ic_net"

                        case "soccerBall":
                            productName_KR = "축구공"
                            iconName = "ic_soccerball"

                        case "uniform_blue":
                            productName_KR = "조끼 (파랑)"
                            iconName = "ic_uniform_b"

                        case "uniform_green":
                            productName_KR = "조끼 (초록)"
                            iconName = "ic_uniform_g"

                        case "uniform_pink":
                            productName_KR = "조끼 (핑크)"
                            iconName = "ic_unifrom_p"

                        default:
                            productName_KR = "알 수 없음"
                        }
                        
                        self.productList.append(ProductDataModel(productName: productName, productName_KR: productName_KR, icName: iconName, all: String(all), late: String(late)))
                        
                        
                    }
                    
                    print(self.productList)
                }
            }
            
            
        default:
            completion(false)
        }
    }
}
