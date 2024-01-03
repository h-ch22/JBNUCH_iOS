//
//  QRHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import Foundation
import Firebase
import FirebaseFirestore

class QRHelper : ObservableObject{
    private let db = Firestore.firestore()
    @Published var findResult : QRCodeModel? = nil
    @Published var couponList : [QRCodeModel] = []
    
    func changeCouponStatus(id : String, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Coupon").document(id).updateData(["status" : "expired"]){error in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            else{
                completion(true)
            }
        }
    }
    
    func getCoupon(completion : @escaping(_ result : Bool?) -> Void){
        self.couponList.removeAll()
        
        self.db.collection("Coupon").whereField("user", isEqualTo: Auth.auth().currentUser?.uid).getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                completion(false)
                
                return
            }
            
            for document in querySnapshot!.documents{
                let benefits = document.data()["benefits"] as? String ?? ""
                let couponNumber = document.data()["couponNumber"] as? String ?? ""
                let createDate = document.data()["createDate"] as? String ?? ""
                let store = document.data()["store"] as? String ?? ""
                
                let expireDate = document.data()["expireDate"] as? String ?? ""
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy. MM. dd."
                let now = formatter.date(from: formatter.string(from: Date()))
                let expireAsDate = formatter.date(from: expireDate)
                
                let status = document.data()["status"] as? String ?? ""
                
                if status == ""{
                    if now! <= expireAsDate!{
                        if !self.couponList.contains(where: {$0.number == couponNumber}){
                            self.couponList.append(QRCodeModel(benefits: benefits, number: couponNumber, createDate: createDate, expireDate: expireDate, store: store))
                        }
                    }
                }
            }
            
            completion(true)
        }
    }
    
    func findQRCode(stringValue : String, completion : @escaping(_ result : QRCodeCallbackModel?) -> Void){
        self.db.collection("Coupon").document(stringValue).getDocument(){(document, error) in
            if error != nil{
                print(error)
                completion(.UNKNOWN)
                
                return
            }
            
            else{
                if let document = document{
                    if document.exists{
                        let user = document.get("user") as? String ?? ""
                        
                        if user != ""{
                            completion(.ALREADY_EXISTS)
                            return
                        }
                        
                        let expireDate = document.get("expireDate") as? String ?? ""
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy. MM. dd."
                        let now = formatter.date(from: formatter.string(from: Date()))
                        let expireAsDate = formatter.date(from: expireDate)
                        
                        if now! > expireAsDate!{
                            completion(.EXPIRED)
                            return
                        }
                        
                        else{
                            self.db.collection("Coupon").document(stringValue).updateData(["user" : Auth.auth().currentUser?.uid ?? ""]){error in
                                if error != nil{
                                    print(error)
                                    completion(.ERROR)
                                    return
                                }
                            }
                            
                            let benefits = document.get("benefits") as? String ?? ""
                            let couponNumber = document.get("couponNumber") as? String ?? ""
                            let createDate = document.get("createDate") as? String ?? ""
                            let store = document.get("store") as? String ?? ""
                            
                            self.findResult = QRCodeModel(benefits: benefits, number: couponNumber, createDate: createDate, expireDate: expireDate, store: store)
                            
                            completion(.SUCCESS)
                        }
                    }

                    else{
                        completion(.UNKNOWN)
                        return
                    }
                }
                
                else{
                    completion(.UNKNOWN)
                    return
                }
            }
        }
    }
}
