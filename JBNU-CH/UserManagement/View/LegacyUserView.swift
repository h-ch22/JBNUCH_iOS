//
//  LegacyUserView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/24.
//

import SwiftUI

struct LegacyUserView: View {
    let email : String
    @StateObject private var helper = UserManagement()
    @State private var showAlert = false
    @State private var alertModel : LegacyDataRemoveAlertModel? = nil
    @State private var showOverlay = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer().frame(height : 20)

                    Group{
                        Image("ic_legacy")
                            .resizable()
                            .frame(width : 100, height : 100)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        Spacer().frame(height : 20)
                        
                        Text("전북대 공대앱 이용자이셨나요?".localized())
                            .font(.title)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        Spacer().frame(height : 20)

                        Text("전북대 공대앱은 이제 총학생회 앱과 통합되었습니다.\n아래 버튼을 눌러 학우님의 데이터를 이관하시면, 별도 가입 없이 계속 서비스를 이용하실 수 있습니다!".localized())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Group{
                        NavigationLink(destination : EULAView(entryPoint : .legacyUser, email : email)){
                            HStack {
                                Text("데이터 이관".localized())
                                
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding([.horizontal], 80)
                            .padding([.vertical], 20)
                            .background(RoundedRectangle(cornerRadius: 30))
                        }
                        
                        Spacer().frame(height : 20)

                        Button(action : {
                            helper.removeLegacyData(email: email){result in
                                guard let result = result else{return}
                                
                                if result{
                                    alertModel = .SUCCESS
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .FAIL
                                    showAlert = true
                                }
                            }
                        }){
                            Text("데이터 제거".localized())
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer().frame(height : 20)

                }.padding([.horizontal], 20)
                    .alert(isPresented : $showAlert, content: {
                        switch alertModel{
                        case .some(.SUCCESS):
                            return Alert(title: Text("데이터 제거 완료"), message: Text("데이터가 제거되었습니다.".localized()), dismissButton: .default(Text("확인".localized())){
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                        case .some(.FAIL):
                            return Alert(title : Text("오류".localized()), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인한 후 다시 시도하십시오.".localized()), dismissButton: .default(Text("확인".localized())))
                            
                        case .none:
                            return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인".localized())))
                        }
                    })
                
                    .overlay(ProgressView().isHidden(!showOverlay))
            }.navigationBarHidden(true)

        }
    }
}
