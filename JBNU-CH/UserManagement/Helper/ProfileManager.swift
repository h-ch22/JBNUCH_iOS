//
//  ProfileManager.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import Foundation
import Firebase
import SwiftUI

class ProfileManager : ObservableObject{
    private let storage = Storage.storage()
    
    func updateProfileImage(uid : String, image : Image, completion : @escaping(_ result : Bool?) -> Void){
        let storageRef = self.storage.reference(withPath: "/Profile/\(uid).png")
        
        let uiImage = image.asUIImage()
        
        guard let data = uiImage.jpegData(compressionQuality: 0.5) else {return}
        
        storageRef.putData(data, metadata : nil){metadata, error in
            guard let metadata = metadata else{
                completion(false)
                
                return
            }
        }
        
        completion(true)
    }
}
