//
//  CalendarView.swift
//  JBNU-CH
//
//  Created by Changjin Ha on 2022/09/23.
//

import SwiftUI
import KVKCalendar

struct CalendarMainView: View {
    @State private var typeCalendar = CalendarType.day
    @State private var events: [Event] = []
    @State private var updatedDate: Date?
    
    var body: some View {
        DisplayCalendar(events: $events, type: $typeCalendar, updatedDate: $updatedDate)
            .navigationBarTitle("취업/대외활동/학사일정 캘린더", displayMode: .inline)
            .edgesIgnoringSafeArea(.bottom)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    HStack{
                        Picker("", selection : $typeCalendar, content : {
                            ForEach(CalendarType.allCases, content : {type in
                                Text(type.rawValue.capitalized)
                            })
                        }).pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
    }
}

struct CalendarMainView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarMainView()
    }
}
