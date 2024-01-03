//
//  StudyRoomStatusView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import SwiftUI

struct StudyRoomStatusView: View {
    @ObservedObject var helper = StudyRoomHelper()
    @StateObject var userManagement : UserManagement
    @State private var showModal = false
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    if helper.studyRoomStatus_1 != nil{
                        StudyRoomListModel(data: helper.studyRoomStatus_1!)
                        
                        Spacer().frame(height : 20)
                    }

                    if helper.studyRoomStatus_2 != nil{
                        StudyRoomListModel(data: helper.studyRoomStatus_2!)
                    }
                }.padding(20)
            }.background(Color.background.edgesIgnoringSafeArea(.all))
        }.onAppear{
            helper.getStatus(userInfo: userManagement.userInfo){result in
                guard let result = result else{return}
            }
        }
        .sheet(isPresented: $showModal, content: {
            StudyRoomReserveMainView()
        })
        
        .navigationBarItems(trailing: Button(action : {
            self.showModal = true
        }){
            Image(systemName: "plus").foregroundColor(.red)
        })
        
        .navigationBarTitle("스터디룸 예약", displayMode: .inline)
    }
}
