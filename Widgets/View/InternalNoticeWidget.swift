//
//  InternalNoticeWidget.swift
//  WidgetsExtension
//
//  Created by 하창진 on 2022/02/23.
//

import SwiftUI
import WidgetKit

struct InternalNoticeWidget: Widget{
    static let kind : String = "InternalNoticeWidget"
    
    var body: some WidgetConfiguration{
        StaticConfiguration(kind : InternalNoticeWidget.kind, provider : InternalNoticeProvider()){entry in
            InternalNoticeWidgetEntryView()
        }.configurationDisplayName("교내 공지")
            .description("교내 공지 페이지로 빠르게 이동할 수 있습니다.")
            .supportedFamilies([.systemSmall])
    }
}
