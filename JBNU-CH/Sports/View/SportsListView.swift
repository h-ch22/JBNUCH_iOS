//
//  SportsListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import SwiftUI

struct SportsListView: View {
    @State private var showSheet = false
    @State private var isAdmin = false
    @State private var searchText = ""
    @StateObject private var helper = SportsHelper()
    @EnvironmentObject var userManagement : UserManagement
    
    private var filtertedList : [SportsDataModel]{
        if searchText.isEmpty{
            return helper.sportsList
        }
        
        else{
            return helper.sportsList.filter{$0.roomName.localizedCaseInsensitiveContains(searchText) as! Bool || $0.sportsType.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    var body: some View {
        VStack{
            List{
                Section(header : Text("관리 중인 방")){
                    ForEach(filtertedList, id : \.self){item in
                        if item.manager == userManagement.userInfo?.uid ?? ""{
                            NavigationLink(destination : SportsDetailView(data : item, helper : helper)){
                                SportsListModel(data : item)
                            }
                        }
                    }
                }

                Section(header : Text("모집 중인 방")){
                    ForEach(filtertedList, id : \.self){item in
                        if item.manager != userManagement.userInfo?.uid ?? "" {
                            NavigationLink(destination : SportsDetailView(data : item, helper : helper)){
                                SportsListModel(data : item)
                            }
                        }
                    }
                }

            }.listStyle(SidebarListStyle())
                .refreshable{
                    helper.getSportsList(userInfo : userManagement.userInfo){result in
                        guard let result = result else{return}
                    }
                }
                .searchable(text : $searchText, prompt : "방 이름, 종목으로 방을 검색해보세요!")
        }
        .navigationBarItems(leading:
                                NavigationLink(destination : EmptyView()){
            Image(systemName : "map.fill")
        },
            trailing: Button(action : {
                self.showSheet = true
            }){
                Image(systemName: "plus")
                .foregroundColor(.red)
            })
        .navigationBarTitle(Text("스포츠 용병 제도"))
        
        .sheet(isPresented : $showSheet){
            addSportsView(receiver : SportsLocationReceiver())
        }
        
        .onAppear{
            helper.getSportsList(userInfo : userManagement.userInfo){result in
                guard let result = result else{return}
            }
        }
        
        .animation(.easeIn)
    }
}
