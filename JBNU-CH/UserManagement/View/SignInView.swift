//
//  SignInView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/23.
//

import SwiftUI

struct SignInView: View {
    @AppStorage("SignIn_email") var SignIn_email : String = UserDefaults.standard.string(forKey: "SignIn_email") ?? ""
    @AppStorage("SignIn_password") var SignIn_password : String = UserDefaults.standard.string(forKey: "SignIn_password") ?? ""
    
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var convertView = false
    @State private var email = ""
    @State private var password = ""
    @State private var errorCode : UserManagementResultModel? = nil
    @State private var convertViewModel : EntryPointModel? = nil
    @StateObject private var helper = UserManagement()
    
    @FocusState private var activeField : UserManagementFocusField?
    
    private let alertModel = UserManagementAlertModel()
    
    var body: some View {

        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Group{
                        Image("ic_logo_no_slogan")
                            .resizable()
                            .frame(width : 200, height : 200)
                        
                        Text("반가워요!")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Text("계속 진행하려면 로그인이 필요합니다.")
                            .foregroundColor(.gray)
                    }

                    Spacer().frame(height : 20)
                    
                    Group{
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

                        HStack{
                            Image(systemName : "key.fill")
                            
                            SecureField("비밀번호", text : $password)
                                .focused($activeField, equals : .field_password)
                                .submitLabel(.done)
                        }.foregroundColor(activeField == .field_password ? .accent : .txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                            .padding([.horizontal],15))
                    }
                    
                    Spacer().frame(height : 40)

                    Group{
                        Button(action: {
                            if email == "" || password == ""{
                                errorCode = .emptyField
                                showAlert = true
                            }
                            
                            else{
                                showOverlay = true
                                
                                helper.signIn(email : email, password : password){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result != .success && result != .legacyUser{
                                        errorCode = result
                                        showAlert = true
                                    }
                                    
                                    else{
                                        if result == .success{
                                            convertViewModel = .home
                                        }
                                        
                                        else{
                                            convertViewModel = .legacyUserView
                                        }
                                        
                                        convertView = true
                                    }
                                }
                            }
                        }){
                            HStack {
                                Text("로그인")
                                
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding([.horizontal], 80)
                            .padding([.vertical], 20)
                            .background(RoundedRectangle(cornerRadius: 30).shadow(radius : 5))
                        }
                        
                        Spacer().frame(height : 20)

                        HStack{
                            NavigationLink(destination : SendResetPasswordEmailView()){
                                Text("비밀번호 재설정")
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            NavigationLink(destination : EULAView(entryPoint : .newUser, email : nil)){
                                Text("회원가입")
                            }
                        }
                        
                        Spacer().frame(height : 20)

                        Text("© 2022 Public Relations Department of Jeonbuk National University Student Association.")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                    }
                    
                }.padding([.horizontal], 20)
                .onAppear{
                    if SignIn_email != "" && SignIn_password != ""{
                        showOverlay = true
                        
                        helper.signIn(email : SignIn_email, password : SignIn_password){result in
                            guard let result = result else{return}
                            
                            showOverlay = false
                                                        
                            if result != .success && result != .legacyUser{
                                errorCode = result
                                showAlert = true
                            }
                            
                            else{
                                if result == .success{
                                    convertViewModel = .home
                                }
                                
                                else{
                                    convertViewModel = .legacyUserView
                                }
                                
                                convertView = true
                            }
                        }
                    }
                }
                
                .overlay(ProcessView().isHidden(!showOverlay))
                
                .alert(isPresented : $showAlert, content : {
                    alertModel.showAlert(code: errorCode!)
                })
                
                .fullScreenCover(isPresented : $convertView, content : {
                    switch convertViewModel!{
                    case .home:
                        TabManager().environmentObject(helper)
                        
                    case .legacyUserView:
                        LegacyUserView(email : email)
                    }
                })
                
                .navigationBarHidden(true)
            }

        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
