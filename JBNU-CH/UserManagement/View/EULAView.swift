//
//  EULAView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/24.
//

import SwiftUI

struct EULAView: View {
    @State private var acceptEULA = false
    @State private var acceptPrivacyLicense = false
    @State private var showAlert = false
    @State private var changeView = false
    
    let entryPoint : RegisterEntryPointModel?
    let email : String?
    
    var body: some View {
        ZStack {
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
                        Text("안녕하세요 학우님!")
                            .font(.title)
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("계속 하려면 이용약관을 읽고 동의해주세요.")
                        
                        Spacer()
                    }
                }
                
                Spacer().frame(height : 60)
                
                HStack{
                    Text("전북대 총학생회 애플리케이션 최종 사용자 계약서")
                    
                    Spacer()
                    
                    NavigationLink(destination : PDFViewer(url : Bundle.main.url(forResource: "EULA", withExtension: "pdf")!).navigationBarTitle("이용 약관", displayMode: .inline)){
                        Text("읽기")
                    }
                    
                    CheckBox(checked: $acceptEULA)
                }
                
                Spacer().frame(height : 20)
                
                HStack{
                    Text("전북대 총학생회 애플리케이션 개인정보 처리 방침")
                    
                    Spacer()
                    
                    NavigationLink(destination : PDFViewer(url : Bundle.main.url(forResource: "PrivacyLicense", withExtension: "pdf")!).navigationBarTitle("개인정보 처리 방침", displayMode: .inline)){
                        Text("읽기")
                    }
                    
                    CheckBox(checked: $acceptPrivacyLicense)
                }
                
                Spacer().frame(height : 20)

                Button(action:{
                    if acceptEULA && acceptPrivacyLicense{
                        changeView = true
                    }
                    
                    else{
                        showAlert = true
                    }
                }){
                    HStack {
                        Text("다음 단계로")
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .padding([.horizontal], 80)
                    .padding([.vertical], 20)
                    .background(RoundedRectangle(cornerRadius: 30))
                }
                
            }.padding([.horizontal], 20)
                .alert(isPresented : $showAlert, content : {
                    return Alert(title: Text("약관 동의 필요"), message: Text("이용약관에 동의해주세요."), dismissButton: .default(Text("확인")))
                })
            
                .fullScreenCover(isPresented : $changeView, content : {
                    switch entryPoint{
                    case .legacyUser:
                        TransferDataView(email: email!)
                        
                    case .newUser:
                        SignUpView()
                        
                    case .none:
                        EmptyView()
                    }
                })
            
            
        }
    }
}
