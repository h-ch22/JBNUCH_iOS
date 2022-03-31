//
//  NoticeWidgetPlaceholderView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import Foundation
import SwiftUI

struct NoticeWidgetPlaceholderView : View{
    var body : some View{
        return NoticeWidgetEntryView(entry : NoticeEntry(noticeList: []))
            .redacted(reason: .placeholder)
    }
}
