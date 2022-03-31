//
//  changePasswordView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import SwiftUI

struct changePasswordView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var helper : UserManagement
    @State private var isSignOut = false
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var showAlert = false
    @State private var alertModel : changePasswordResultModel?
    @State private var changeView = false
    @State private var showOverlay = false
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    
                    HStack{
                        Image(systemName : "key.fill")
                        
                        SecureField("새 비밀번호", text : $password)
                            .submitLabel(.done)
                    }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                        .padding([.horizontal],15))
                    
                    HStack{
                        Image(systemName : "key.fill")
                        
                        SecureField("비밀번호 확인", text : $checkPassword)
                            .submitLabel(.done)
                    }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                        .padding([.horizontal],15))
                    
                    Spacer().frame(height : 20)

                    HStack{
                        CheckBox(checked: $isSignOut)
                        Text("로그아웃")
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Text("보안을 위해 6자리 이상의 비밀번호를 입력해주세요.")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer().frame(height : 20)
                    
                    Button(action : {
                        showOverlay = true
                        
                        helper.changePassword(password : password, isSignOut : isSignOut){result in
                            guard let result = result else{return}
                            
                            showOverlay = false
                            
                            if !result{
                                alertModel = .fail
                                showAlert = true
                            }
                            
                            else if result && isSignOut{
                                alertModel = .signedOut
                                showAlert = true
                            }
                            
                            else{
                                alertModel = .success
                                showAlert = true
                            }
                        }
                    }){
                        HStack {
                            Text("비밀번호 변경")
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding([.horizontal], 80)
                        .padding([.vertical], 20)
                        .background(RoundedRectangle(cornerRadius: 30).shadow(radius : 5))
                    }.isHidden(password != checkPassword || password.count < 6)

                }.padding(20)
                    .navigationBarTitle("비밀번호 변경")
                    .navigationBarItems(trailing: Button("닫기"){
                        self.presentationMode.wrappedValue.dismiss()
                    })
                
                    .fullScreenCover(isPresented: $changeView, content: {
                        SignInView()
                    })
                
                    .overlay(ProgressView().isHidden(!showOverlay))
                
                    .alert(isPresented : $showAlert){
                        switch alertModel{
                        case .success:
                            return Alert(title: Text("비밀번호 변경 완료"), message: Text("비밀번호가 변경되었습니다."), dismissButton: .default(Text("확인")){
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                        case .signedOut:
                            return Alert(title : Text("비밀번호 변경 완료"), message : Text("비밀번호가 변경되어 로그아웃 처리되었습니다."), dismissButton: .default(Text("확인")){
                                changeView = true
                            })
                            
                        case .fail :
                            return Alert(title: Text("오류"), message: Text("요청을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                            
                        case .none:
                            return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))
                        }
                    }
            }
        }
    }
}
