//
//  MarketHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import Foundation
import Firebase
import FirebaseFirestore

class MarketHelper : ObservableObject{
    @Published var productList : [MarketDataModel] = []
    @Published var urlList : [URL] = []
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func addProduct(model : MarketDataModel, images : [URL], completion : @escaping(_ result : Bool?) -> Void){
        let docRef = self.db.collection("Market").document()
        
        docRef.setData([
            "title" : model.title,
            "seller" : model.seller,
            "price" : model.price,
            "sellerInfo" : model.sellerInfo,
            "contents" : model.contents,
            "quantity" : model.quantity,
            "status" : "ONSALE",
            "date" : model.date,
            "imgCount" : model.imgCount,
            "category" : self.convertCateogryAsEnglish(cateogry: model.category ?? "")
        ]){error in
            if error != nil{
                print(error)
                
                completion(false)
                
                return
            }
            
            else{
                let storageRef = self.storage.reference()

                for i in 0..<images.count{
                    let marketRef = storageRef.child("market/\(docRef.documentID)/\(i).png")
                    let uploadTask = marketRef.putFile(from: images[i], metadata : nil){metadata, error in
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
    
    func getProductList(completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Market").addSnapshotListener{querySnapshot, error in
            if let error = error{
                print(error)
                
                completion(false)
                return
            }
            
            querySnapshot?.documentChanges.forEach{diff in
                let id = diff.document.documentID
                let title = diff.document.get("title") as? String ?? ""
                let seller = diff.document.get("seller") as? String ?? ""
                let price = diff.document.get("price") as? Int ?? 0
                let sellerInfo = diff.document.get("sellerInfo") as? String ?? ""
                let contents = diff.document.get("contents") as? String ?? ""
                let quantity = diff.document.get("quantity") as? Int ?? 0
                let status = diff.document.get("status") as? String ?? ""
                let date = diff.document.get("date") as? String ?? ""
                let imgCount = diff.document.get("imgCount") as? Int ?? 0
                let category = diff.document.get("category") as? String ?? ""
                var statusAsModel : ProductStatusModel = .SOLD
                
                switch(status){
                case "ONSALE" :
                    statusAsModel = .ONSALE
                    
                case "RESERVED" :
                    statusAsModel = .RESERVED
                    
                case "SOLD" :
                    statusAsModel = .SOLD
                    
                default:
                    statusAsModel = .SOLD
                }
                
                let imgRef = self.storage.reference(withPath: "market/\(id)/\(0).png")
                
                imgRef.downloadURL{url, error in
                    if error != nil{
                        print(error)
                        completion(false)
                        
                        return
                    }
                    
                    else{
                        switch diff.type{
                        case .added,
                         .modified:
                            if !self.productList.contains(where : {$0.id == id}){
                                self.productList.append(MarketDataModel(id: id, seller: seller, price: price, sellerInfo: self.convertSellerInfo(sellerInfo: sellerInfo), title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), thumbnail: url!, quantity: quantity, status: statusAsModel, date: date, category: self.convertCateogryAsKorean(category: category), imgCount: imgCount))
                            }
                            
                            else{
                                let index = self.productList.firstIndex(where: {$0.id == id})
                                
                                if index != nil{
                                    self.productList[index!] = MarketDataModel(id: id, seller: seller, price: price, sellerInfo: self.convertSellerInfo(sellerInfo: sellerInfo), title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), thumbnail: url!, quantity: quantity, status: statusAsModel, date: date, category: self.convertCateogryAsKorean(category: category), imgCount: imgCount)
                                }
                                
                                else{
                                    self.productList.append(MarketDataModel(id: id, seller: seller, price: price, sellerInfo: self.convertSellerInfo(sellerInfo: sellerInfo), title: AES256Util.decrypt(encoded: title), contents: AES256Util.decrypt(encoded: contents), thumbnail: url!, quantity: quantity, status: statusAsModel, date: date, category: self.convertCateogryAsKorean(category: category), imgCount: imgCount))
                                }
                            }
                            
                        case .removed:
                            let index = self.productList.firstIndex(where: {$0.id == id})

                            if index != nil{
                                self.productList.remove(at: index!)
                            }
                        }
                    }
                }
            }
        }
    }

    func convertCateogryAsKorean(category : String) -> String {
        var categoryAsKorean = ""
        
        switch category{
        case "clothes_women":
            categoryAsKorean = "여성의류"
            
        case "clothes_men":
            categoryAsKorean = "남성의류"
            
        case "shoes":
            categoryAsKorean = "신발"
            
        case "bag":
            categoryAsKorean = "가방"
            
        case "accessories":
            categoryAsKorean = "액세서리"
            
        case "digital":
            categoryAsKorean = "디지털/가전"
            
        case "sports" :
            categoryAsKorean = "스포츠"
            
        case "goods":
            categoryAsKorean = "굿즈"
            
        case "music":
            categoryAsKorean = "악기/음반"
            
        case "book":
            categoryAsKorean = "도서/티켓/문구"
            
        case "beauty":
            categoryAsKorean = "뷰티/미용"
            
        case "interior":
            categoryAsKorean = "가구/인테리어"
            
        case "life":
            categoryAsKorean = "생활"
            
        case "food":
            categoryAsKorean = "식품"
            
        case "ability":
            categoryAsKorean = "재능/구직/구인"
            
        case "others":
            categoryAsKorean = "기타"
            
        default:
            categoryAsKorean = "기타"
        }
        
        return categoryAsKorean
    }

    func convertCateogryAsEnglish(cateogry : String) -> String{
        var categoryAsEnglish = ""
        
        switch cateogry{
        case "여성의류":
            categoryAsEnglish = "clothes_women"
            
        case "남성의류":
            categoryAsEnglish = "clothes_men"
            
        case "신발":
            categoryAsEnglish = "shoes"
            
        case "가방":
            categoryAsEnglish = "bag"
            
        case "액세서리":
            categoryAsEnglish = "accessories"
            
        case "디지털/가전":
            categoryAsEnglish = "digital"
            
        case "스포츠" :
            categoryAsEnglish = "sports"
            
        case "굿즈":
            categoryAsEnglish = "goods"
            
        case "악기/음반":
            categoryAsEnglish = "music"
            
        case "도서/티켓/문구":
            categoryAsEnglish = "book"
            
        case "뷰티/미용":
            categoryAsEnglish = "beauty"
            
        case "가구/인테리어":
            categoryAsEnglish = "interior"
            
        case "생활":
            categoryAsEnglish = "life"
            
        case "식품":
            categoryAsEnglish = "food"
            
        case "재능/구직/구인":
            categoryAsEnglish = "ability"
            
        case "기타":
            categoryAsEnglish = "others"
            
        default:
            categoryAsEnglish = "others"
        }
        
        return categoryAsEnglish
    }
    
    func convertSellerInfo(sellerInfo : String) -> String{
        var seller = ""
        let seller_splited = AES256Util.decrypt(encoded: sellerInfo).components(separatedBy: ", ")
        
        if seller_splited != nil && seller_splited.count == 3{
            var nameAsArray = seller_splited[2].map{$0}
            
            if seller_splited[2].count > 2{
                nameAsArray[1] = "*"
                nameAsArray[2] = "*"
            }
            
            else{
                nameAsArray[1] = "*"
            }
            
            var studentNoAsArray = seller_splited[1].map{$0}
            
            for i in 4..<studentNoAsArray.count{
                studentNoAsArray[i] = "*"
            }
            
            seller = "\(seller_splited[0]) \(String(studentNoAsArray)) \(String(nameAsArray))"
        }
        
        return seller
    }
    
    func downloadImage(id : String, imgIndex : Int, completion : @escaping(_ result : Bool?) -> Void){
        self.urlList.removeAll()
        
        for i in 0..<imgIndex{
            let storageRef = self.storage.reference().child("market/\(id)/\(i).png")

            storageRef.downloadURL(){url, error in
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                else{
                    if url != nil{
                        self.urlList.append(url!)
                    }
                }
            }
        }
    }

}
