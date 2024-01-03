//
//  PetitionMainView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI

struct PetitionListView_Beta: View {
    private var filtertedList : [PetitionDataModel]{
        if searchText.isEmpty{
            return helper.petitionList
        }
        
        else{
            return helper.petitionList.filter{$0.title?.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    @StateObject var helper : PetitionHelperBeta
    @StateObject var userInfo : UserManagement
    @State private var searchText = ""
    @State private var showSheet = false
    @State private var selectedTab = 0
    @State private var selectedCategory = 0
    
    var body: some View {
        VStack{
            Group{
                HStack{
                    Picker("", selection : $selectedTab){
                        ForEach(0..<2){index in
                            switch index{
                            case 0:
                                Text("진행 중").tag(index)
                                
                            case 1:
                                Text("완료/만료됨").tag(index)
                                
                            default:
                                Text("진행 중").tag(index)
                            }
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                    
                    Picker("카테고리 선택", selection: $selectedCategory){
                        ForEach(0..<6){index in
                            switch index{
                            case 0:
                                Text("전체").tag(index)
                                
                            case 1:
                                Text("학사").tag(index)
                                
                            case 2:
                                Text("시설").tag(index)
                                
                            case 3:
                                Text("복지").tag(index)
                                
                            case 4:
                                Text("문화 및 예술").tag(index)
                                
                            case 5:
                                Text("기타").tag(index)
                                
                            default:
                                Text("전체").tag(index)
                            }
                        }
                    }
                }.padding([.horizontal], 20)
            }
            
            Group {
                VStack{
                    HStack{
                        Text("Notice")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        NavigationLink(destination : PetitionNoticeListView(helper: helper).environmentObject(userInfo)){
                            Text("More")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if !helper.noticeList.isEmpty{
                        Group{
                            Spacer().frame(height : 5)
                            
                            NavigationLink(destination : PetitionNoticeDetailView(data: helper.noticeList[0], userInfo: userInfo.userInfo, helper: helper, userManagement: userInfo)){
                                PetitionNoticeListModel(data : helper.noticeList[0])
                            }
                        }
                    }
                }
                .padding([.horizontal],20)
                
                List{
                    ForEach(filtertedList, id : \.self){index in
                        switch selectedCategory{
                        case 0:
                            if selectedTab == 1 {
                                if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                    NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                        PetitionListModel(data: index)
                                    }
                                }
                            }
                            
                            else{
                                if index.status == .InProcess{
                                    NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                        PetitionListModel(data: index)
                                    }
                                }

                            }
                            
                        case 1:
                            if index.category == "학사"{
                                if selectedTab == 1 {
                                    if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                                
                                else{
                                    if index.status == .InProcess{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                            }
                            
                        case 2:
                            if index.category == "시설"{
                                if selectedTab == 1 {
                                    if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                                
                                else{
                                    if index.status == .InProcess{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                            }
                            
                        case 3:
                            if index.category == "복지"{
                                if selectedTab == 1 {
                                    if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                                
                                else{
                                    if index.status == .InProcess{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                            }
                            
                        case 4:
                            if index.category == "문화 및 예술"{
                                if selectedTab == 1 {
                                    if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                                
                                else{
                                    if index.status == .InProcess{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                            }
                            
                        case 5:
                            if index.category == "기타"{
                                if selectedTab == 1 {
                                    if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                                
                                else{
                                    if index.status == .InProcess{
                                        NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                            PetitionListModel(data: index)
                                        }
                                    }
                                }
                            }
                            
                        default:
                            if selectedTab == 1 {
                                if index.status == .Answered || index.status == .Finish || index.status == .Cancled{
                                    NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                        PetitionListModel(data: index)
                                    }
                                }
                            }
                            
                            else{
                                if index.status == .InProcess{
                                    NavigationLink(destination : PetitionDetailView_Beta(item: index, userInfo : userInfo, helper : helper)){
                                        PetitionListModel(data: index)
                                    }
                                }
                            }
                        }
                        
                    }
                }
                .searchable(text : $searchText, prompt : "청원 검색".localized())
            }
        }.navigationBarTitle("JBNU Petiton System (Beta)", displayMode: .large)
            .navigationBarItems(trailing: Button(action : {
                self.showSheet = true
            }){
                Image(systemName: "plus")
                    .foregroundColor(.red)
            })
        
            .sheet(isPresented : $showSheet){
                addPetitionMainView_Beta()
            }
        
            .onAppear{
                helper.getNotice(){result in
                    guard let result = result else{return}
                }
                
                helper.getPetitionList(){result in
                    guard let result = result else{return}
                }
            }
    }
}
