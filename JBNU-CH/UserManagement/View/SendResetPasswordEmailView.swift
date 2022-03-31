//
//  SendResetPasswordEmailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct SendResetPasswordEmailView: View {
    @State private var email = ""
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var resultCode : UserManagementResultModel? = nil
    @StateObject private var helper = UserManagement()
    @FocusState private var activeField : UserManagementFocusField?
    
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
                        Text("비밀번호 재설정")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("아래 필드에 가입한 E-Mail을 입력해주세요.")
                        
                        Spacer()
                    }
                }
                
                Spacer().frame(height : 60)
                
                HStack{
                    Image(systemName : "at.circle.fill")
                    
                    TextField("E-Mail", text : $email)
                        .focused($activeField, equals : .field_email)
                        .submitLabel(.continue)
                        .keyboardType(.emailAddress)
                }.foregroundColor(activeField == .field_email ? .accent : .txtColor)
                    .padding(20)
                    .padding([.horizontal], 20)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                    .padding([.horizontal],15))
                
                Spacer().frame(height : 20)
                
                Button(action : {
                    showOverlay = true
                    
                    helper.sendPasswordResetMail(email: email){result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                        
                        resultCode = result
                        showAlert = true
                    }
                }){
                    HStack {
                        Text("재설정 메일 발송")
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .padding([.horizontal], 60)
                    .padding([.vertical], 20)
                    .background(RoundedRectangle(cornerRadius: 30))}
            }.padding([.horizontal], 20)
                .overlay(ProcessView().isHidden(!showOverlay))
            
                .alert(isPresented : $showAlert, content : {
                    alertModel.showAlert(code: resultCode!)
                })
        }
    }
}

struct SendResetPasswordEmailView_Previews: PreviewProvider {
    static var previews: some View {
        SendResetPasswordEmailView()
    }
}
