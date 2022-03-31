//
//  PledgeHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import Foundation
import Firebase

class PledgeHelper : ObservableObject{
    private let db = Firestore.firestore()
    @Published var pledges : [PledgeDataModel] = []
    
    func getAllPledges(college : String, completion : @escaping(_ result : Bool?) -> Void){
        self.pledges.removeAll()
        
        self.db.collection("Pledge").document(college).collection("Status").getDocuments(){(querySnapshot, error) in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            for document in querySnapshot!.documents{
                var category = ""
                
                if college == "CH"{
                    switch document.documentID{
                    case "App":
                        category = "앱 (App.)"
                        
                    case "Bachelor" :
                        category = "취·창업 및 학사"
                        
                    case "Culture" :
                        category = "문화 및 예술"
                        
                    case "Dorm":
                        category = "생활관"
                        
                    case "Facility" :
                        category = "시설 및 안전"
                        
                    case "HumanRights":
                        category = "인권"
                        
                    case "Welfare":
                        category = "복지"
                        
                    default:
                        category = "기타"
                    }
                }
                
                else{
                    switch document.documentID{
                    case "Bachelor":
                        category = "취업 및 학습"
                        
                    case "Communication":
                        category = "소통"
                        
                    case "Culture":
                        category = "문화 및 예술"
                        
                    case "Succession":
                        category = "승계 공약"
                        
                    case "Welfare" :
                        category = "복지"
                        
                    case "Facility":
                        category = "시설"
                        
                    default:
                        category = "기타"
                    }
                }
                
                let keys = document.data().keys
                
                for key in keys{
                    let index = document.data().index(forKey: key)
                    
                    if index != nil{
                        var status : PledgeStatusModel?
                        let value = document.data()[key]
                                                
                        switch value as? String ?? ""{
                        case "InProgress":
                            status = .InProgress

                        case "Preparing":
                            status = .Preparing

                        case "Complete":
                            status = .Complete

                        default:
                            status = .Preparing
                        }
                        
                        self.pledges.append(PledgeDataModel(pledgeName: key, pledgeCategory: category, pledgeStatus: status!))
                    }
                }
            }
            
            completion(true)
        }
    }
}
