//
//  EnterStudyRoomReservationCodeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/05/05.
//

import SwiftUI

struct EnterStudyRoomReservationCodeView: View {
    @State private var reservationCode = ""
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                Text("스터디룸 예약 코드를 입력하십시오.")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer().frame(height : 15)
                
                HStack{
                    Image(systemName : "key.fill")
                    
                    TextField("예약 코드", text : $reservationCode)
                        .submitLabel(.done)
                }
                    .padding(20)
                    .padding([.horizontal], 20)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                    .padding([.horizontal],15))
                
                Spacer().frame(height : 15)
                
                NavigationLink(destination : EmptyView()){
                    Text("QR코드로 예약 참여")
                }
            }.navigationBarItems(trailing: NavigationLink(destination : EmptyView()){
                Text("다음")
            }.isHidden(self.reservationCode == ""))
        }
    }
}

struct EnterStudyRoomReservationCodeView_Previews: PreviewProvider {
    static var previews: some View {
        EnterStudyRoomReservationCodeView()
    }
}
