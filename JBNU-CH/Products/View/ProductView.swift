//
//  ProductView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI

struct ProductView: View {
    @StateObject private var helper = ProductHelper()
    @StateObject var userManagement : UserManagement

    let type : String
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                LazyVStack{
                    VStack{
                        if helper.isAvailable{
                            Image(systemName: "checkmark.circle")
                                .resizable()
                                .frame(width : 80, height : 80)
                                .foregroundColor(.green)
                            
                            Text("민원사업을 정상적으로 이용하실 수 있습니다.")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .multilineTextAlignment(.center)
                        }
                        
                        else{
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width : 80, height : 80)
                                .foregroundColor(.red)
                            
                            Text("지금은 민원사업을 이용하실 수 없습니다.\n평일 오전 9시부터 오후 6시 (점심시간 : 13시 ~ 14시)에 다시 이용해주세요.")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                    
                    Spacer().frame(height : 20)
                    
                    ForEach(helper.productList, id : \.self){product in
                            ProductListModel(imgName: product.icName, productName: product.productName_KR, all: product.all, late: product.late)
                    }
                    
                    
                }.padding(20)
            }.background(Color.background.edgesIgnoringSafeArea(.all))
                .navigationTitle(Text("대여사업 물품 잔여수량 확인"))
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: NavigationLink(destination : ProductLogView_Tabs().environmentObject(userManagement)){
                    Text("대여 기록")
                })
            

        }.onAppear{
            helper.calcTime()
            
            switch type{
            case "CH":
                helper.getProductList(userManagement : userManagement, type : "CH"){ result in
                    guard let result = result else{return}
                }
                
            case "College":
                helper.getProductList(userManagement : userManagement, type : "College"){ result in
                    guard let result = result else{return}
                }
                
            default:
                helper.getProductList(userManagement : userManagement, type : "CH"){ result in
                    guard let result = result else{return}
                }
            }
        }
    }
}
