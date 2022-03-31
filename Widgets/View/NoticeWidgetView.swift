//
//  NoticeWidgetView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import SwiftUI
import WidgetKit

struct NoticeWidgetView: Widget {
    static let kind : String = "NoticeListWidget"
    
    public var body : some WidgetConfiguration{
        StaticConfiguration(kind : NoticeWidgetView.kind, provider : NoticeProvider()){entry in
            NoticeWidgetEntryView(entry : entry)
        }
        .configurationDisplayName("공지사항")
        .description("총학생회 공지사항을 위젯에서 확인하실 수 있습니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}
