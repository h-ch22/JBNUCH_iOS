//
//  StudyRoomListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import SwiftUI

struct StudyRoomListModel: View {
    let data : StudyRoomDataModel
    
    var body: some View {
        VStack{
            HStack{
                Image("ic_studyRoom")
                    .resizable()
                    .frame(width : 50, height : 50)
                
                Text(data.roomName)
                    .foregroundColor(.txtColor)
                    .fontWeight(.semibold)
                
                Spacer()
                
                switch data.status{
                case .available:
                    HStack{
                        Circle().foregroundColor(.green).frame(width : 20, height : 20)

                        Text("이용 가능")
                            .foregroundColor(.green)
                    }

                case .preparing:
                    HStack{
                        Circle().foregroundColor(.orange).frame(width : 20, height : 20)
                        
                        Text("예약자 입실 대기")
                            .foregroundColor(.orange)
                    }
                    
                case .unavailable:
                    HStack{
                        Circle().foregroundColor(.red).frame(width : 20, height : 20)
                        
                        Text("이용 중")
                            .foregroundColor(.red)
                    }
            
                }
            }
            
            Spacer().frame(height : 20)
            
            HStack{
                NavigationLink(destination : EmptyView()){
                    HStack {
                        Text("이용 현황")
                        Image(systemName: "chevron.right")
                    }
                }
                
                Spacer()
                
                NavigationLink(destination : EmptyView()){
                    HStack {
                        Image(systemName: "calendar.badge.clock")
                        Text("예약하기")
                    }
                }
            }
        }.padding(20)
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
    }
}
