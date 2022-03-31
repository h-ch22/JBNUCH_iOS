//
//  ProfileView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var helper : UserManagement
    @State private var alertModel : ProfileAlertModel?
    @State private var showAlert = false
    @State private var showSheet = false
    @State private var changeView = false
    @State private var showOverlay = false
    @State private var showChangePhoneView = false
    @State private var showPicker = false
    @State private var pickerType : UIImagePickerController.SourceType = .photoLibrary
    @State private var pickedImage : Image?

    private let cache = ImageCache()
    private let profileHelper = ProfileManager()

    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                Group{
                    if cache.get(forKey: "profile") != nil{
                        Image(uiImage: cache.get(forKey: "profile")!)
                            .resizable()
                                .clipShape(Circle())
                                .aspectRatio(contentMode: .fit)
                                .frame(width : 200, height : 200)
                    }
                    
                    else{
                        if helper.userInfo?.profile != nil{
                            AsyncImage(url : helper.userInfo?.profile!, content : {phase in
                                switch phase{
                                case .empty :
                                    ProgressView()
                                        .overlay(Circle().stroke(Color.accent, lineWidth : 2))
                                        .padding(5)
                                    
                                case .success(let image) :
                                    image.resizable()
                                        .clipShape(Circle())
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width : 200, height : 200)
                                        .onAppear{
                                            cache.set(forKey: "profile", image: image.asUIImage())
                                        }
                                    
                                case .failure :
                                    Image("ic_logo_no_slogan")
                                        .resizable()
                                        .frame(width : 200, height : 200)
                                        .shadow(radius: 5)
                                    
                                @unknown default :
                                    Image("ic_logo_no_slogan")
                                        .resizable()
                                        .frame(width : 200, height : 200)
                                        .shadow(radius: 5)
                                }
                            })
                                .shadow(radius: 5)
                        }
                        
                        else{
                            Image("ic_logo_no_slogan")
                                .resizable()
                                .frame(width : 200, height : 200)
                                .shadow(radius: 5)

                        }
                    }
                    
                    Spacer().frame(height : 5)

                    Button(action: {
                        showPicker = true
                    }){
                        Text("프로필 이미지 변경")
                            .foregroundColor(.accent)
                    }
                    
                    Spacer().frame(height : 20)
                }

                Text(helper.userInfo?.name ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
                Spacer().frame(height : 5)
                
                Text("\(helper.userInfo?.college ?? "") \(helper.userInfo?.studentNo ?? "")")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Group{
                    Spacer().frame(height : 20)

                    Button(action: {
                        showChangePhoneView = true
                    }){
                        PlainButtonFramework(imageName: "ic_phone", txt: "연락처 변경")
                    }
                    
                    Spacer().frame(height : 10)
                    
                    Button(action: {
                        showSheet = true
                    }){
                        PlainButtonFramework(imageName: "ic_password", txt: "비밀번호 변경")
                    }
                    
                    Spacer().frame(height : 10)

                    Button(action: {
                        alertModel = .confirmSignOut
                        showAlert = true
                    }){
                        PlainButtonFramework(imageName: "ic_signout", txt: "로그아웃")
                    }
                    
                    Spacer().frame(height : 10)

                    Button(action: {
                        alertModel = .confirmSecession
                        showAlert = true
                    }){
                        PlainButtonFramework(imageName: "ic_cancel", txt: "회원 탈퇴")
                    }
                }
                
            }.overlay(ProgressView().isHidden(!showOverlay))
            .fullScreenCover(isPresented: $changeView, content: {
                SignInView()
            })
            
                .sheet(isPresented : $showSheet, content : {
                    changePasswordView(helper : helper)
                })
            
                .sheet(isPresented : $showChangePhoneView, content : {
                    updatePhoneView(helper : helper)
                })
            
                .sheet(isPresented: $showPicker, content: {
                    ImagePickerView(sourceType: pickerType){(image) in
                        self.pickedImage = Image(uiImage: image)
                        
                        if self.pickedImage != nil{
                            showOverlay = true
                            
                            profileHelper.updateProfileImage(uid : helper.userInfo?.uid ?? "",image : self.pickedImage!){result in
                                guard let result = result else{return}
                                
                                showOverlay = false
                                
                                if !result{
                                    alertModel = .profileUpdateFail
                                    showAlert = true
                                }
                                
                                else{
                                    helper.getUserInfo(){result in
                                        guard let result = result else{return}
                                    }
                                }
                            }
                        }
                    }
                })
            
            .alert(isPresented : $showAlert, content : {
                switch alertModel{
                case .confirmSecession:
                    return Alert(title: Text("회원 탈퇴"), message: Text("회원 탈퇴 시 계정 정보가 제거되며, 가입 기간 중 활동 내역(예 : 합격자 수기 공유)는 제거되지 않습니다.\n계속하시겠습니까?"), primaryButton: .default(Text("예")), secondaryButton: .default(Text("아니오")))
                    
                case .secessionSuccess:
                    return Alert(title : Text("회원 탈퇴 완료"), message: Text("회원 탈퇴가 완료되었습니다.\n그 동안 서비스를 이용해주셔서 감사드리며, 더 좋은 모습으로 다시 찾아뵐 수 있도록 항상 노력하겠습니다."), dismissButton: .default(Text("확인")))
                    
                case .secessionFail:
                    return Alert(title : Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))

                case .confirmSignOut:
                    return Alert(title: Text("로그아웃"), message: Text("로그아웃 시 자동 로그인이 자동으로 해제되며, 재로그인하셔야합니다.\n계속하시겠습니까?"), primaryButton: .default(Text("예")){
                        showOverlay = true
                        
                        helper.signOut(){result in
                            guard let result = result else{return}
                            
                            showOverlay = false
                            
                            if result{
                                alertModel = .signOutSuccess
                                showAlert = true
                            }
                            
                            else{
                                alertModel = .signOutFail
                                showAlert = true
                            }
                        }
                    }, secondaryButton: .default(Text("아니오")))
                    
                case .signOutSuccess:
                    return Alert(title : Text("로그아웃 완료"), message: Text("로그아웃이 완료되었습니다."), dismissButton: .default(Text("확인")){
                        changeView = true
                    })

                case .signOutFail:
                    return Alert(title : Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))

                case .profileUpdateFail:
                    return Alert(title : Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    
                case .none:
                    return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))
                }
            })
        }

    }
}
