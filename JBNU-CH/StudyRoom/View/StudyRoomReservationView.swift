//
//  StudyRoomReservationView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/05/05.
//

import SwiftUI

struct StudyRoomReservationView: View {
    @State private var today = Date()
    @State private var accept = false
    var dateRange : ClosedRange<Date>{
        let min = Calendar.current.date(byAdding : .second, value: 0, to : Date())!
        let max = Calendar.current.date(byAdding : .day, value : 7, to : Date())!
        
        return min...max
    }
    
    @State private var selectedRange = Date()
    var selectionRange : ClosedRange<Date>{
        let min = Calendar.current.date(byAdding : .second, value: 0, to : today)!
        let max = Calendar.current.date(byAdding : .hour, value : 2, to : today)!
        
        return min...max
    }
    
    var body: some View {
        ScrollView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    DatePicker("예약일 선택",
                               selection : $today,
                               in: dateRange,
                               displayedComponents: [.date, .hourAndMinute])
                    
                    Spacer().frame(height : 20)
                    
                    DatePicker("퇴장시각 선택",
                               selection : $selectedRange,
                               in: selectionRange,
                               displayedComponents: [.date, .hourAndMinute])
                                        
                    Spacer().frame(height : 40)

                    HStack{
                        Text("스터디룸 이용 방침")
                        
                        Spacer()
                        
                        NavigationLink(destination : PDFViewer(url : Bundle.main.url(forResource: "PrivacyLicense", withExtension: "pdf")!, page: nil).navigationBarTitle("개인정보 처리 방침", displayMode: .inline)){
                            Text("읽기")
                        }
                        
                        CheckBox(checked: $accept)
                    }
                    
                }.padding(20)
            }.navigationTitle("예약일 선택")
        }.background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct StudyRoomReservationView_Previews: PreviewProvider {
    static var previews: some View {
        StudyRoomReservationView()
    }
}
