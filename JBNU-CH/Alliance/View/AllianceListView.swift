//
//  AllianceListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct displayMapList : UIViewControllerRepresentable{
    let data : [AllianceDataModel]
    typealias UIViewControllerType = StoreListMapView
    
    func makeUIViewController(context: Context) -> StoreListMapView {
        return StoreListMapView(models: data)
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
            List{
                ForEach(filtertedList, id : \.self){index in
                    NavigationLink(destination : AllianceDetailView(data : index)){
                        AllianceListModel(data: index, college : userManagement.userInfo?.collegeCode)
                    }
                    
                }
                 
            }.searchable(text : $searchText, prompt : "이름, 메뉴 또는 혜택으로 업체를 찾아보세요!")

        }
        .onAppear{
            helper.getAllianceList(category: category){result in
                guard let result = result else{return}
                
                if !result{
                    showAlert = true
                }
            }
        }
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: NavigationLink(destination : displayMapList(data : helper.allianceList).navigationBarTitle("지도 보기", displayMode: .inline)){
            Image(systemName: "map.fill")
        })

    }
}
