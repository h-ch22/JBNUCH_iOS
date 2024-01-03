//
//  changePassword.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI
import Firebase

struct changePassword: View {
    @State private var changeView = false
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                Image(systemName : "at.circle.fill")
                    .resizable()
                    .frame(width : 150, height : 150)
                    .foregroundColor(.accent)
                
                Text("E-Mail을 확인해주세요!".localized())
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.accent)
                
                Spacer().frame(height : 20)
                
                Text("보안을 위해 본인인증이 필요합니다.\n입력한 E-Mail에서 비밀번호를 설정하신 후 로그인해주세요.".localized())
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height : 60)
                
                Button(action: {
                    changeView = true
                }){
                    HStack {
                        Text("로그인 화면으로 이동".localized())
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .padding([.horizontal], 60)
                    .padding([.vertical], 20)
                    .background(RoundedRectangle(cornerRadius: 30))
                }
                
                Button(action: {
                    let mail = Auth.auth().currentUser?.email ?? ""
                    
                    if mail != ""{
                        let domain = mail.components(separatedBy: "@")
                        var url = ""
                        var domainAsString = domain[1]
                        
                        switch domainAsString{
                        case "naver.com":
                            url = "https://mail.naver.com"
                            
                        case "daum.net":
                            url = "https://mail.daum.net"
                            
                        case "nate.com":
                            url = "https://mail.nate.com"
                            
                        case "jbnu.ac.kr":
                            url = "https://gmail.com"
                            
                        case "gmail.com":
                            url = "https://gmail.com"
                            
                        case "google.com":
                            url = "https://gmail.com"
                            
                        case "kakao.com":
                            url = "https://mail.kakao.com"
                            
                        default :
                            url = ""
                        }
                        
                        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
                    }
                }){
                    Text("E-Mail 열기".localized())
                }
            }.padding([.horizontal], 20)
                .fullScreenCover(isPresented: $changeView, content: {
                    SignInView()
            })
        }
    }
}

struct changePassword_Previews: PreviewProvider {
    static var previews: some View {
        changePassword()
    }
}
