//
//  AllFeedbackView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/04.
//

import SwiftUI

struct AllFeedbackView: View {
    @StateObject var userManagement : UserManagement
    @StateObject var helper = FeedbackHubHelper()
    
    @State private var searchText = ""
    @State private var showAlert = false
    
    private var filtertedList : [FeedbackHubDataModel]{
        if searchText.isEmpty{
            return helper.feedbackList
        }
        
        else{
            return helper.feedbackList.filter{$0.title.localizedCaseInsensitiveContains(searchText) as! Bool || $0.contents.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                List{
                    ForEach(filtertedList, id : \.self){ index in
                        NavigationLink(destination :  FeedbackHubDetailView(data : index, type : "Admin", userManagement: userManagement, helper : helper)){
                            FeedbackHubListModel(data : index, type : "Admin")
                        }
                    }
                }.refreshable{
                    helper.getAllFeedback(userInfo : userManagement.userInfo){result in
                        guard let result = result else{return}
                        
                        if !result{
                            showAlert = true
                        }
                    }
                }
                .searchable(text : $searchText, prompt : "피드백 검색")
            }.navigationBarTitle("전체 피드백")

                .onAppear{
                    helper.getAllFeedback(userInfo : userManagement.userInfo){result in
                        guard let result = result else{return}
                        
                        if !result{
                            showAlert = true
                        }
                    }
                }
            
                .alert(isPresented: $showAlert){
                    return Alert(title: Text("오류"), message: Text("피드백을 불러오는 중 오류가 발생했습니다.\n액세스 권한이 있는지 확인하시거나, 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                }
        }
    }
}
