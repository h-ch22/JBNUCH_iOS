//
//  AllianceAdView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI
import SwiftUIPager

struct AllianceAdView: View {
    @State private var page : Page = .first()
    @EnvironmentObject var helper : AllianceHelper
    
    let userInfo : UserInfoModel?
    
    func adView(_ page : Int) -> some View{
        Image(uiImage: helper.imgList[page])
            .resizable()
            .frame(width : 300, height : 200)
            .cornerRadius(20)
            .shadow(radius: 10)
    }
    
    var body: some View {
        Pager(page : self.page,
              data : helper.imgList.indices,
              id: \.self){
            self.adView($0)
        }.interactive(scale : 0.8)
            .interactive(opacity: 0.5)
            .itemSpacing(10)
            .pagingPriority(.simultaneous)
            .itemAspectRatio(1.3, alignment: .start)
            .sensitivity(.high)
            .preferredItemSize(CGSize(width : 300, height : 200))
            .onPageWillChange({(newIndex) in
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            })
            .frame(height : 200)
            .onAppear{
                helper.getAdList(){result in
                    guard let result = result else{return}
                    
                }
                
                helper.allianceList.removeAll()
            }
    }
}
