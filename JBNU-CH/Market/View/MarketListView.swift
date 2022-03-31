//
//  MarketListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import SwiftUI

struct MarketListView: View {
    private var filtertedList : [MarketDataModel]{
        if searchText.isEmpty{
            return helper.productList
        }
        
        else{
            return helper.productList.filter{$0.title.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    @StateObject var helper = MarketHelper()
    @EnvironmentObject var userManagement : UserManagement
    @State private var searchText = ""
    @State private var showModal = false
    
    var body: some View {
        VStack{
            List{
                ForEach(filtertedList, id : \.self){item in
                    NavigationLink(destination : MarketDetailView(data : item)){
                        MarketListModel(data : item)
                    }
                }
            }.listStyle(SidebarListStyle())
                .refreshable{
                    helper.getProductList(){result in
                        guard let result = result else{return}
                    }
                }
                .searchable(text : $searchText, prompt : "원하시는 상품을 검색해보세요!")
        }.navigationBarTitle(Text("중고 장터"))
            .toolbar{
                ToolbarItemGroup(placement : .navigationBarTrailing){
                    Button(action : {
                        showModal = true
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.red)
                    }
                    
                    NavigationLink(destination : EmptyView()){
                        Image(systemName: "person.circle.fill")
                        
                    }
                }
            }
        
            .sheet(isPresented : $showModal){
                addProductView()
            }
            .onAppear{
                helper.getProductList{result in
                    guard let result = result else{return}
                }
            }
            .animation(.easeOut)
    }
}
