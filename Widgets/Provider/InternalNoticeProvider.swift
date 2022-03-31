//
//  InternalNoticeProvider.swift
//  WidgetsExtension
//
//  Created by 하창진 on 2022/02/23.
//

import Foundation
import WidgetKit

class InternalNoticeProvider : TimelineProvider{
    typealias Entry = InternalNoticeEntry
    
    func placeholder(in context: Context) -> InternalNoticeEntry {
        Entry(date : Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (InternalNoticeEntry) -> Void) {
        let entry = Entry(date : Date())
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<InternalNoticeEntry>) -> Void) {
        let currentDate = Date()
        let entries : [InternalNoticeEntry] = [InternalNoticeEntry(date : currentDate)]
        
        let timeline = Timeline(entries: entries, policy: .never)
        
        completion(timeline)
    }
}
