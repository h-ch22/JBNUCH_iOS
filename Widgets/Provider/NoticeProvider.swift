//
//  NoticeProvider.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

import Foundation
import WidgetKit

class NoticeProvider : TimelineProvider{
    typealias Entry = NoticeEntry
    private let helper = NoticeHelper()
    private let userInfo = UserManagement()
    
    func placeholder(in context: Context) -> NoticeEntry {
        return NoticeEntry(noticeList: [NoticeDataModel(id: nil, title: "공지사항 제목", contents: nil, dateTime: "2022. 01. 01.", imageIndex: nil, url: nil, type: NoticeTypeModel.CH)])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (NoticeEntry) -> Void) {
        helper.getNotice(userInfo : userInfo.userInfo){ result in
            guard let result = result else{return}
            
            if result{
                let entry = Entry(noticeList : self.helper.noticeList)
                completion(entry)
            }
            
            else{
                
            }
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<NoticeEntry>) -> Void) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding : .minute, value : 30, to : currentDate)!
        
        helper.getNotice(userInfo : userInfo.userInfo){result in
            guard let result = result else{
                return
            }
            
            if result{
                let entry = NoticeEntry(date: currentDate, noticeList: self.helper.noticeList)
                let timeline = Timeline(entries : [entry] , policy : .after(refreshDate))
                
                completion(timeline)
            }
            
            else{
                let entry = Entry(date: currentDate, noticeList: [NoticeDataModel(id: "Notice_FAIL", title: "데이터를 가져올 수 없음", contents: "", dateTime: "", imageIndex: nil, url: nil, type: NoticeTypeModel.CH)])
                
                let entries : [Entry] = [entry]
                
                let timeline = Timeline(entries : entries, policy : .after(refreshDate))
                
                completion(timeline)
            }
        }
    }
}
