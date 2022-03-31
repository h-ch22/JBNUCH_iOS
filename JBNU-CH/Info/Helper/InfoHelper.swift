//
//  InfoHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/10.
//

import Foundation
import Firebase

class InfoHelper : ObservableObject{
    @Published var latestVersion = ""
    @Published var latestBuild = ""
    
    private let db = Firestore.firestore()
    
    func getLatestInfo(completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("Version").document("iOS").getDocument(){(document, error) in
            if error != nil{
                completion(false)
                
                return
            }
            
            if let document = document{
                if document.exists{
                    self.latestVersion = document.get("Version") as? String ?? ""
                    self.latestBuild = document.get("Build") as? String ?? ""
                    
                    completion(true)
                }
            }
            
            else{
                completion(false)
                
                return
            }
        }
    }
}
