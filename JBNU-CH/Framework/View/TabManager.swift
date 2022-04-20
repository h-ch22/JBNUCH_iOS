//
//  TabView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct TabManager: View {
    @EnvironmentObject var helper : UserManagement
    
    var body: some View {
        TabView{
            HomeView().environmentObject(helper)
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            AllianceView().environmentObject(helper)
                .tabItem{
                    Image(systemName: "location.fill.viewfinder")
                    Text("제휴업체")
                }
            
//            TimeTableView()
//                .tabItem{
//                    Image(systemName: "calendar.badge.clock.rtl")
//                    Text("시간표")
//                }
            
            NoticeView().environmentObject(helper)
                .tabItem{
                    Image(systemName: "bell.fill")
                    Text("공지사항")
                }
            
            MoreView().environmentObject(helper)
                .tabItem{
                    Image(systemName: "ellipsis.circle.fill")
                    Text("더 보기")
                }
        }.accentColor(.accent)
        
        
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
