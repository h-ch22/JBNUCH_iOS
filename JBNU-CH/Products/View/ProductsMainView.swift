//
//  ProductsMainView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/05.
//

import SwiftUI

struct ProductsMainView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var userManagement : UserManagement
    
    var body: some View {
        Picker("학생회 선택", selection: $selectedTab){
            ForEach(0..<2){index in
                if index == 0{
                    Text("총학생회").tag(index)
                }
                
                else{
                    Text("단과대학 학생회").tag(index)
                }
            }
        }.pickerStyle(SegmentedPickerStyle())
            .padding([.horizontal], 20)
            .isHidden(userManagement.userInfo?.collegeCode != .SOC && userManagement.userInfo?.collegeCode != .COM && userManagement.userInfo?.collegeCode != .COH && userManagement.userInfo?.collegeCode != .CON && userManagement.userInfo?.collegeCode != .CHE)
        
        switch selectedTab{
        case 0:
            ProductView(userManagement: userManagement, type : "CH")
            
        case 1:
            ProductView(userManagement: userManagement, type : "College")
            
        default :
            ProductView(userManagement: userManagement, type : "CH")
        }
    }
}

struct ProductsMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsMainView()
    }
}
