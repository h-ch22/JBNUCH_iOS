//
//  NoticeWidgetEntryView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import SwiftUI
import WidgetKit

struct NoticeWidgetEntryView: View {
    let entry : NoticeEntry
    @Environment(\.widgetFamily) var family
    
    var maxCount : Int{
        switch family{
        case .systemSmall:
            return 1
            
        case .systemMedium :
            return 3
            
        case .systemLarge :
            return 5
            
        case .systemExtraLarge :
            return 7
            
        @unknown default:
            return 3
        }
    }
    
    @ViewBuilder
    var body: some View {
        VStack(alignment : .leading){
            ForEach(0..<min(maxCount, entry.noticeList.count), id : \.self){index in
                let notice = entry.noticeList[index]
                
                Text(notice.title ?? "")
                    .font(.caption2)
                    .fontWeight(.semibold)
                
                Text(notice.dateTime ?? "")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                if index < maxCount{
                    Divider().foregroundColor(.gray)
                }
            }
        }.padding(20)
    }
}

struct NoticeWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeWidgetEntryView(entry: NoticeEntry(noticeList: [NoticeDataModel(id: "", title: "title", contents: "", dateTime: "date", imageIndex: nil, url: nil, type: NoticeTypeModel.CH)]))
    }
}
