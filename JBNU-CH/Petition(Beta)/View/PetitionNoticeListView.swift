//
//  PetitionNoticeListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/07/01.
//

import SwiftUI

struct PetitionNoticeListView: View {
    private var filtertedList : [NoticeDataModel]{
        if searchText.isEmpty{
            return helper.noticeList
        }
        
        else{
            return helper.noticeList.filter{$0.title?.localizedCaseInsensitiveContains(searchText) as! Bool || $0.contents?.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    @StateObject var helper : PetitionHelperBeta
    @EnvironmentObject var userManagement : UserManagement
    @State private var searchText = ""
    @State private var showModal = false
    @State private var selectedTab = 0
    
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack{
                    ForEach(helper.noticeList, id : \.self){index in
                        NavigationLink(destination : PetitionNoticeDetailView(data : index, userInfo : userManagement.userInfo, helper : helper, userManagement: userManagement)){
                            PetitionNoticeListModel(data: index)
                        }
                    }.padding([.horizontal], 20)
                        .refreshable{
                            helper.getNotice(){result in
                                guard let result = result else{return}
                                
                                if result{
                                    helper.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
                                }
                            }
                        }
                }
                
                .searchable(text : $searchText, prompt : "공지사항 검색".localized())
            }
            .onAppear{
                helper.noticeList.removeAll()
                helper.urlList.removeAll()
                
                helper.getNotice(){result in
                    guard let result = result else{return}
                    
                    if result{
                        helper.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
                        
                    }
                }
            }
            .navigationTitle(Text("Notice"))
            .navigationBarItems(trailing: Button(action : {
                self.showModal = true
            }){
                Image(systemName: "plus")
                    .foregroundColor(.red)
            }.isHidden(!userManagement.detectNoticePermission()))
            
            .sheet(isPresented: $showModal, content: {
                addPetitionNoticeView(helper : helper).environmentObject(helper)
            })
            
        }
    }
}
