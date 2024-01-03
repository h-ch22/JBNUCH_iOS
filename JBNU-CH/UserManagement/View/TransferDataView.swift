//
//  TransferDataView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct TransferDataView: View {
    @StateObject private var helper = UserManagement()
    
    @State private var showAlert = false
    @State private var showOverlay = false
    @State private var changeView = false
    @State private var errorCode : UserManagementResultModel? = nil

    let email : String
    private let alertModel = UserManagementAlertModel()

    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                Group {
                    HStack{
                        Image("ic_logo_no_slogan")
                            .resizable()
                            .frame(width : 150, height : 150)
                        
                        Spacer()
                    }
                                        
                    HStack {
                        Text("데이터 변환 시작".localized())
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("먼저 학우님의 정보가 맞는지 확인해주세요.".localized())
                        
                        Spacer()
                    }
                }
                
                Spacer().frame(height : 40)
                
                Group {
                    VStack{
                        HStack{
                            Text("이름 : \(helper.legacyUserInfo?.name ?? "알 수 없음")")
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)

                        HStack{
                            Text("학과 : \(helper.legacyUserInfo?.college ?? "알 수 없음")")
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)

                        HStack{
                            Text("학번 : \(helper.legacyUserInfo?.studentNo ?? "알 수 없음")")
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)

                        HStack{
                            Text("연락처 : \(helper.legacyUserInfo?.phone ?? "알 수 없음")")
                            
                            Spacer()
                        }
                    }.background(Rectangle().foregroundColor(.gray).opacity(0.2))

                    Spacer().frame(height : 40)

                    Button(action:{
                        showOverlay = true
                        
                        helper.transferData(email : email){result in
                            guard let result = result else{return}
                            
                            showOverlay = false
                            
                            if result != .success{
                                errorCode = result
                                showAlert = true
                            }
                            
                            else{
                                changeView = true
                            }
                        }
                    }){
                        HStack {
                            Text("다음 단계로".localized())
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding([.horizontal], 80)
                        .padding([.vertical], 20)
                        .background(RoundedRectangle(cornerRadius: 30))
                    }
                }
            }.padding([.horizontal], 20)
                .alert(isPresented : $showAlert, content : {
                    alertModel.showAlert(code: errorCode!)
                })
            
                .onAppear{
                    helper.getLegacyUserData(email: email){result in
                        guard let result = result else{return}
                        
                        if result != .success{
                            errorCode = result
                            showAlert = true
                        }
                    }
                }
            
                .fullScreenCover(isPresented : $changeView, content: {
                    changePassword()
                })
            
                .overlay(content: {
                    ProcessView().isHidden(!showOverlay)
                })
        }
    }
}
