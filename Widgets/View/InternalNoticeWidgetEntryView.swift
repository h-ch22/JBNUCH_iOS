//
//  InternalNoticeWidgetEntryView.swift
//  WidgetsExtension
//
//  Created by 하창진 on 2022/02/23.
//

import SwiftUI
import WidgetKit

struct InternalNoticeWidgetEntryView : View{
    @Environment(\.widgetFamily) var family
    
    var maxCount : Int{
        switch family{
        case .systemLarge,
                .systemSmall,
                .systemMedium,
                .systemExtraLarge:
            return 1
            
        @unknown default:
            return 1
        }
    }
    
    @ViewBuilder
    var body : some View{
        Link(destination : URL(string:"internalWidget://widgetAction?param=goToInternalNotice")!){
            ZStack {
                Color.accentColor
                
                VStack{
                    Image("ic_logo_w_no_slogan")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .topLeading)
                    
                    HStack {
                        Text("교내 공지 바로가기")
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        Image(systemName : "arrow.right.circle.fill")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
            }
        }

    }
}

struct InternalNoticeWidgetEntryView_Previews : PreviewProvider{
    static var previews: some View{
        InternalNoticeWidgetEntryView()
    }
}
