//
//  NoticeEntry.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import Foundation
import WidgetKit

struct NoticeEntry : TimelineEntry{
    var date = Date()
    let noticeList : [NoticeDataModel]
}
