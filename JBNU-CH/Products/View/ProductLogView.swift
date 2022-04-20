//
//  ProductLogView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI

struct ProductLogView: View {
    @StateObject private var helper = ProductHelper()
    @StateObject var userManagement : UserManagement
    let type : String
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView{
                    LazyVStack{
                        ForEach(helper.productLogList, id : \.self){product in
                            ProductLogListModel(imgName: product.icName, productName: product.productName, number: product.number, isReturned: product.isReturned, dayLimit: product.dayLimit, day: product.dateTime)
                                .padding(5)
                        }
                    }
                }.background(Color.background.edgesIgnoringSafeArea(.all))
            }.padding(20)
        }.onAppear{
            helper.getLog(type : type, userInfo : userManagement.userInfo){result in
                guard let result = result else{return}
            }
        }
        .navigationBarTitle("대여 기록", displayMode: .inline)
        .animation(.easeOut)

    }
}
