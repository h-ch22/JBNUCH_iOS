//
//  StudyRoomReserveMainView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/05/04.
//

import SwiftUI

struct StudyRoomReserveMainView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    NavigationLink(destination : StudyRoomReservationView()){
                        VStack(alignment : .leading, spacing: 5){
                            Image(systemName: "calendar.badge.clock.rtl")
                                .resizable()
                                .frame(width : 50, height : 40)
                                .foregroundColor(.accent)
                            
                            Text("예약하기")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.txtColor)
                            
                            Text("원하는 스터디룸을 선택하고, 일정을 예약하고, 예약 코드를 발급받습니다.\n기존에 발급받은 예약 코드가 없는 경우 이 옵션을 선택하세요.")
                                .foregroundColor(.txtColor)
                                .multilineTextAlignment(.leading)
                            
                            Spacer().frame(height : 15)
                            
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width : 25, height : 20)
                                .foregroundColor(.txtColor)
                        }
                    }.padding(15).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor))
                    
                    Spacer().frame(height : 10)
                    
                    NavigationLink(destination : EnterStudyRoomReservationCodeView()){
                        VStack(alignment : .trailing, spacing: 5){
                            Image(systemName: "keyboard")
                                .resizable()
                                .frame(width : 50, height : 40)
                                .foregroundColor(.accent)

                            Text("예약 코드 입력하기")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.txtColor)
                            
                            Text("스터디룸을 예약한 대표로부터 예약 코드를 받은 경우 이 옵션을 선택해 스터디룸 예약의 구성원으로 참여하세요.")
                                .foregroundColor(.txtColor)
                                .multilineTextAlignment(.trailing)
                            
                            Spacer().frame(height : 15)
                            
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width : 25, height : 20)
                                .foregroundColor(.txtColor)
                        }
                    }.padding(15).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor))
                }.padding(20)
            }.navigationBarTitle("스터디룸 예약")
            .navigationBarItems(leading: Button("닫기"){
                self.presentationMode.wrappedValue.dismiss()
        })
        }
    }
}

struct StudyRoomReserveMainView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomReserveMainView()
    }
}
