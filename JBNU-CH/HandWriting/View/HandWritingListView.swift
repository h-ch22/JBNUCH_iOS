//
//  HandWritingListView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import SwiftUI

struct HandWritingListView: View {
    @StateObject var helper = HandWritingHelper()
    @EnvironmentObject var userManagement : UserManagement
    @State private var searchText = ""
    @State private var showSheet = false
    
    private var filtertedList : [HandWritingDataModel]{
        if searchText.isEmpty{
            return helper.handWritingList
        }
        
        else{
            return helper.handWritingList.filter{$0.title.localizedCaseInsensitiveContains(searchText) as! Bool || $0.examName.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                List{
                    ForEach(filtertedList, id : \.self){index in
                        NavigationLink(destination : HandWritingDetailView(data : index).environmentObject(userManagement).environmentObject(helper)){
                            HandWritingListModel(data : index)
                        }
                    }
                }.searchable(text : $searchText, prompt : "제목, 시험명으로 수기를 검색해보세요!".localized())
                    .refreshable {
                        helper.getHandWritingList(){result in
                            guard let result = result else{return}
                        }
                    }
                
                
            }.navigationBarTitle("합격자 수기 공유")
                .onAppear{
                    helper.getHandWritingList(){result in
                        guard let result = result else{return}
                    }
                }
                .navigationBarItems(trailing: Button(action : {
                    showSheet = true
                }){
                    Image(systemName : "plus")
                        .foregroundColor(.red)
                })
            
                .sheet(isPresented : $showSheet){
                    addHandWritingView().environmentObject(userManagement)
                }
            
                .animation(.easeOut)
        }
    }
}

struct HandWritingListView_Previews: PreviewProvider {
    static var previews: some View {
        HandWritingListView()
    }
}
