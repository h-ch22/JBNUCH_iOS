//
//  AllianceView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct AllianceView: View {
    @EnvironmentObject var userManagement : UserManagement
    @State private var showSheet = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    AllianceAdView(userInfo: userManagement.userInfo).environmentObject(AllianceHelper(userInfo: userManagement.userInfo))
                    
                    Spacer().frame(height : 20)
                    
                    Text("원하시는 카테고리를 선택하세요!")
                        .foregroundColor(.txtColor)
                    
                    Spacer().frame(height : 10)
                    
                    HStack {
                        NavigationLink(destination : AllianceListView(category : "전체", userManagement: userManagement)
                            .environmentObject(AllianceHelper(userInfo: userManagement.userInfo))){
                                AllianceCategoryButtonModel(imageName: "ic_all", categoryName: "전체".localized())
                            }
                        
                        NavigationLink(destination : AllianceListView(category : "식사", userManagement: userManagement).environmentObject(AllianceHelper(userInfo: userManagement.userInfo))){
                            AllianceCategoryButtonModel(imageName: "ic_alliance_meal", categoryName: "식사".localized())
                        }
                        
                        NavigationLink(destination : AllianceListView(category: "카페", userManagement: userManagement).environmentObject(AllianceHelper(userInfo: userManagement.userInfo))){
                            AllianceCategoryButtonModel(imageName: "ic_cafe", categoryName: "카페".localized())
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack {
                        NavigationLink(destination : AllianceListView(category: "술", userManagement: userManagement).environmentObject(AllianceHelper(userInfo: userManagement.userInfo))){
                            AllianceCategoryButtonModel(imageName: "ic_liquor", categoryName: "술".localized())
                        }
                        
                        NavigationLink(destination : AllianceListView(category : "편의", userManagement: userManagement).environmentObject(AllianceHelper(userInfo: userManagement.userInfo))){
                            AllianceCategoryButtonModel(imageName: "ic_convenience", categoryName: "편의".localized())
                        }
                        
                        NavigationLink(destination : CouponView()){
                            AllianceCategoryButtonModel(imageName: "ic_coupon", categoryName: "쿠폰".localized())
                        }
                    }
                }.navigationTitle(Text("제휴업체"))
                    .navigationBarItems(trailing: Button(action : {
                        showSheet = true
                    }){
                        Image(systemName: "qrcode.viewfinder")
                    })
                
                    .sheet(isPresented: $showSheet, content: {
                        QRView()
                    })
            }
            
        }
    }
}

struct AllianceView_Previews: PreviewProvider {
    static var previews: some View {
        AllianceView()
            .preferredColorScheme(.dark)
    }
}
