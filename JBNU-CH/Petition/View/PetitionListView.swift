//
//  PetitionMainView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI

struct PetitionListView: View {
    private var filtertedList : [PetitionDataModel]{
        if searchText.isEmpty{
            return helper.petitionList
        }
        
        else{
            return helper.petitionList.filter{$0.title?.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    @StateObject var helper : PetitionHelper
    @StateObject var userInfo : UserManagement
    @State private var searchText = ""
    @State private var showSheet = false
    
    var body: some View {
        VStack{
            List{
                ForEach(filtertedList, id : \.self){index in
                    NavigationLink(destination : PetitionDetailView(item: index, userInfo : userInfo, helper : helper)){
                        PetitionListModel(data: index)
                    }
                }
            }.refreshable{
                
            }
            .searchable(text : $searchText, prompt : "청원 검색")
        }.navigationBarTitle("전대 청원제도", displayMode: .large)
            .navigationBarItems(trailing: Button(action : {
                self.showSheet = true
            }){
                Image(systemName: "plus")
                    .foregroundColor(.red)
            })
        
            .sheet(isPresented : $showSheet){
                addPetitionMainView()
            }
        
            .onAppear{
                helper.getPetitionList(){result in
                    guard let result = result else{return}
                }
            }
    }
}
