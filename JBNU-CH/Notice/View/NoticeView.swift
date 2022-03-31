//
//  NoticeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct NoticeView: View {
    @State private var selectedTab = 0

    var body: some View {
        NavigationView{
            VStack(alignment : .leading) {
                Picker("공지사항 종류 선택", selection : $selectedTab){
                    ForEach(0..<2){index in
                        if index == 0{
                            Text("학생회 공지").tag(index)
                        }
                        
                        else{
                            Text("교내 공지").tag(index)
                        }
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(20)
                
                switch selectedTab{
                case 0:
                    NoticeListView(helper: NoticeHelper())

                case 1:
                    InternalNoticeView()

                default:
                    NoticeListView(helper: NoticeHelper())

                }
            }.navigationTitle("공지사항")
        }

    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
