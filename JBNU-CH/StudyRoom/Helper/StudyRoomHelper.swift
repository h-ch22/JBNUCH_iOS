//
//  StudyRoomHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/04.
//

import Foundation
import Firebase

class StudyRoomHelper : ObservableObject{
    @Published var studyRoomList : [StudyRoomDataModel] = []
    
    private let db = Firestore.firestore()
    private let helper = UserManagement()
    
    func getStatus(userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        self.db.collection("StudyRoom").document(self.helper.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).addSnapshotListener{(querySnapshot, error) in
            if let error = error{
                print(error)
                
                completion(false)
                
                return
            }
            
            
        }
    }
}
