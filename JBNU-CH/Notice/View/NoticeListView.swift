//
//  NoticeListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/11.
//

import SwiftUI

struct NoticeListView: View {
    private var filtertedList : [NoticeDataModel]{
        if searchText.isEmpty{
            return helper.noticeList
        }
        
        else{
            return helper.noticeList.filter{$0.title?.localizedCaseInsensitiveContains(searchText) as! Bool || $0.contents?.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    @StateObject var helper : NoticeHelper
    @EnvironmentObject var userManagement : UserManagement
    @State private var searchText = ""
    @State private var showModal = false
    
    var body: some View {
        VStack{
            List{
                Section(header : Text("총학생회"), content : {
                    ForEach(filtertedList, id : \.self){index in
                        if index.type == .CH{
                            NavigationLink(destination : NoticeDetailView(data : index, userInfo : userManagement.userInfo, userManagement: userManagement).environmentObject(helper)){
                                NoticeListModel(data: index)
                            }
                        }
                    }
                })

                Section(header : Text("단과대학"), content : {
                    ForEach(filtertedList, id : \.self){index in
                        if index.type == .College{
                            NavigationLink(destination : NoticeDetailView(data : index, userInfo : userManagement.userInfo, userManagement: userManagement).environmentObject(helper)){
                                NoticeListModel(data: index)
                            }
                        }
                    }
                }).isHidden(userManagement.userInfo?.collegeCode != .SOC && userManagement.userInfo?.collegeCode != .COM && userManagement.userInfo?.collegeCode != .COH && userManagement.userInfo?.collegeCode != .CON && userManagement.userInfo?.collegeCode != .CHE)
            }.listStyle(SidebarListStyle())
            .refreshable{
                helper.getNotice(userInfo : userManagement.userInfo){result in
                    guard let result = result else{return}
                    
                    if result{
                        helper.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
                    }
                }
            }
            .searchable(text : $searchText, prompt : "공지사항 검색")
        }.onAppear{
            helper.noticeList.removeAll()
            helper.urlList.removeAll()
            
            helper.getNotice(userInfo : userManagement.userInfo){result in
                guard let result = result else{return}
                
                if result{
                    helper.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
                    
                }
            }
        }
        
        .navigationBarItems(trailing: Button(action : {
            self.showModal = true
        }){
            Image(systemName: "plus")
                .foregroundColor(.red)
        }.isHidden(!userManagement.detectNoticePermission()))
        
        .sheet(isPresented: $showModal, content: {
            addNoticeView(helper : helper).environmentObject(helper)
        })
        
    }
}
