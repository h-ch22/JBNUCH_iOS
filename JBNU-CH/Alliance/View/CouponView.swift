//
//  CouponView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import SwiftUI

struct CouponView: View {
    @ObservedObject var helper = QRHelper()
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var alertModel : CouponStateCallbackModel? = nil
    @State private var selectedID = ""
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                LazyVStack{
                    ForEach(helper.couponList, id : \.self){ item in
                        Button(action : {
                            self.selectedID = item.number
                            alertModel = .QUESTION
                            showAlert = true
                        }){
                            CouponListModel(data : item)
                        }
                    }
                }.padding(20).onAppear{
                    helper.getCoupon(){result in
                        guard let result = result else{return}
                    }
                }
            }.navigationTitle(Text("쿠폰 목록")).background(Color.background.edgesIgnoringSafeArea(.all))
                .overlay(ProgressView().isHidden(!showOverlay))
                .alert(isPresented : $showAlert, content : {
                    switch alertModel{
                    case .QUESTION:
                        return Alert(title: Text("사용 처리"), message: Text("쿠폰을 사용 처리합니다.\n사용 처리 이후에는 복구할 수 없습니다. 계속 하시겠습니까?"), primaryButton: .default(Text("예")){
                            self.showOverlay = true
                            
                            helper.changeCouponStatus(id: selectedID){ result in
                                guard let result = result else{return}
                                
                                if !result{
                                    showOverlay = false
                                    alertModel = .FAIL
                                    showAlert = true
                                }
                                
                                else{
                                    showOverlay = false
                                    alertModel = .SUCCESS
                                    showAlert = true
                                    
                                    helper.getCoupon(){result2 in
                                        guard let result2 = result2 else{return}
                                    }
                                }
                            }
                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .SUCCESS:
                        return Alert(title: Text("처리 완료"), message: Text("쿠폰을 사용 처리하였습니다."), dismissButton: .default(Text("확인")))
                        
                    case .FAIL:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .none:
                        return Alert(title: Text("알 수 없는 매개변수"), message: Text("알 수 없는 매개변수입니다."), dismissButton: .default(Text("확인")))
                    }
                })
        }
    }
}

struct CouponView_Previews: PreviewProvider {
    static var previews: some View {
        CouponView()
    }
}
