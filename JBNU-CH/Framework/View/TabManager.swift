//
//  TabView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct TabManager: View {
    @EnvironmentObject var helper : UserManagement
    @State private var showCountryView = false
    @State private var showBetaWarning = false
    
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
            .onAppear{
                helper.detectCountry(){result in
                    guard let result = result else{return}
                    
                    if result == .unknown{
                        showCountryView = true
                    }
                }
            }
            .fullScreenCover(isPresented: $showCountryView, content: {
                CountrySelectionView(helper : helper)
            })
            .alert(isPresented : $showBetaWarning, content : {
                return Alert(title: Text("Beta Software Warning"), message:Text("You are currently using a beta version of the software.\nThe beta version is unstable, and some unexpected errors may occur.\nWe recommend installing and using the official version in the App Store."), dismissButton: .default(Text("OK")))
            })
        
        
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
