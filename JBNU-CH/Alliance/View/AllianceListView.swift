//
//  AllianceListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct displayMapList : UIViewControllerRepresentable{
    let data : [AllianceDataModel]
    let userManagement : UserManagement
    let helper : AllianceHelper
    typealias UIViewControllerType = StoreListMapView
    
    func makeUIViewController(context: Context) -> StoreListMapView {
        return StoreListMapView(models: data, userManagement : userManagement, helper : helper)
    }
    
    func updateUIViewController(_ uiViewController: StoreListMapView, context: Context) {
        
    }
}

struct AllianceListView: View {
    let category : String
    @EnvironmentObject var helper : AllianceHelper
    @StateObject var userManagement : UserManagement
    
    @State private var searchText = ""
    @State private var showAlert = false
    @State private var selectedIndex = 0
    @State private var indexes = ["전체", "전북대", "객사", "신시가지", "기타", "즐겨찾기"]
    
    private var filtertedList : [AllianceDataModel]{
        if searchText.isEmpty{
            return helper.allianceList
        }
        
        else{
            return helper.allianceList.filter{$0.storeName?.localizedCaseInsensitiveContains(searchText) as! Bool || $0.menu?.localizedCaseInsensitiveContains(searchText) as! Bool || $0.benefits?.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal){
                HStack{
                    ForEach(indexes.indices, id : \.self){item in
                        Button(action: {
                            selectedIndex = item
                            
                        }){
                            Text(indexes[item])
                                .padding(10)
                                .foregroundColor(selectedIndex == item ? .white : .accent)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(selectedIndex == item ? .accent : .white))
                        }
                    }
                }.padding([.horizontal], 10)
            }

            List{
                ForEach(filtertedList, id : \.self){index in
                    switch selectedIndex{
                    case 1:
                        if index.pos == "deokjin"{
                            NavigationLink(destination : AllianceDetailView(data : index, college : userManagement.userInfo?.collegeCode, helper : helper)){
                                AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                            }
                        }
                        
                    case 2:
                        if index.pos == "gosa"{
                            NavigationLink(destination : AllianceDetailView(data : index, college : userManagement.userInfo?.collegeCode, helper : helper)){
                                AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                            }
                        }
                        
                    case 3:
                        if index.pos == "hyoja"{
                            NavigationLink(destination : AllianceDetailView(data : index, college : userManagement.userInfo?.collegeCode, helper : helper)){
                                AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                            }
                        }
                        
                    case 4:
                        if index.pos == "others"{
                            NavigationLink(destination : AllianceDetailView(data : index, college : userManagement.userInfo?.collegeCode, helper : helper)){
                                AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                            }
                        }
                        
                    case 5:
                        if index.isFavorite!{
                            NavigationLink(destination : AllianceDetailView(data : index, college : userManagement.userInfo?.collegeCode, helper : helper)){
                                AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                            }
                        }
                        
                    default:
                        NavigationLink(destination : AllianceDetailView(data : index, college : userManagement.userInfo?.collegeCode, helper : helper)){
                            AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                        }
                    }
                }
                
            }.searchable(text : $searchText, placement : .navigationBarDrawer(displayMode: .always))

            
        }
        .onAppear{
            helper.getAllianceList(category: category){result in
                guard let result = result else{return}
                
                if !result{
                    showAlert = true
                }
            }

        }
        .navigationTitle(category.localized())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination : displayMapList(data : helper.allianceList, userManagement : userManagement, helper : helper).navigationBarTitle("지도 보기".localized(), displayMode: .inline)){
            Image(systemName: "map.fill")
        })
        
    }
}
