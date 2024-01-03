//
//  HomeCalendarDataModel.swift
//  JBNU-CH
//
//  Created by Changjin Ha on 2022/09/23.
//

import Foundation

struct HomeCalendarDataModel : Hashable{
    var title : String
    var startDate : String
    var endDate : String
    var isAllDay : Bool
    
    init(title: String, startDate: String, endDate: String, isAllDay : Bool) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isAllDay = isAllDay
    }
}
