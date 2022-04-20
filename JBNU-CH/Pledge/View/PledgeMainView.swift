//
//  PledgeMainView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import SwiftUI

struct PledgeMainView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var userManagement : UserManagement
    
    var body: some View {
        VStack{
            Picker("학생회 선택", selection : $selectedTab){
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
            .isHidden(userManagement.userInfo?.collegeCode != .SOC && userManagement.userInfo?.collegeCode != .CON)
            
            switch selectedTab{
            case 0:
                PledgeView(college : "CH")
                    .animation(.easeOut)

            case 1:
                PledgeView(college : userManagement.convertCollegeCodeAsString(collegeCode: userManagement.userInfo?.collegeCode))
                    .animation(.easeOut)

            default:
                PledgeView(college : "CH")
                    .animation(.easeOut)

            }
        }.onAppear{
            let apparence = UITabBarAppearance()
            apparence.configureWithOpaqueBackground()
            if #available(iOS 15.0, *) {UITabBar.appearance().scrollEdgeAppearance = apparence}
        }
    }
}
