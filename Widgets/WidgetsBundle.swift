//
//  Widgets.swift
//  Widgets
//
//  Created by 하창진 on 2022/02/23.
//

import WidgetKit
import SwiftUI
import Intents
import UIKit
import Firebase

@main
struct WidgetsBundle : WidgetBundle{
    init(){
        FirebaseApp.configure()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    var body : some Widget{
        NoticeWidgetView()
        InternalNoticeWidget()
    }
}

extension String{
    func createRandomStr(length : Int) -> String{
        let str = (0..<length).map{ _ in self.randomElement()!}
        
        return String(str)
    }
}
