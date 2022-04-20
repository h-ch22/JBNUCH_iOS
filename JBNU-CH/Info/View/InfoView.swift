//
//  InfoView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/10.
//

import SwiftUI

struct InfoView: View {
    @State private var version = ""
    @State private var build = ""
    
    @StateObject var helper = InfoHelper()
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    Group{
                        HStack {
                            Image("appstore")
                                .resizable().frame(width : 100, height : 100).cornerRadius(15)
                            
                            Spacer().frame(width : 10)

                            VStack(alignment : .leading) {
                                HStack {
                                    Text("전북대 총학생회")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.txtColor)
                                }
                                
                                Spacer().frame(height : 5)
                                
                                HStack{
                                    Text("버전 : \(version)")
                                        .font(.caption)
                                }
                                
                                Spacer().frame(height : 5)

                                HStack{
                                    Text("빌드 번호 : \(build)")
                                        .font(.caption)
                                }
                                
                                Spacer().frame(height : 5)
                                
                                HStack{
                                    if helper.latestVersion == version && helper.latestBuild == build{
                                        Image(systemName : "checkmark")
                                            .foregroundColor(.green)
                                        
                                        Text("최신 버전입니다.")
                                            .foregroundColor(.green)
                                            .fontWeight(.semibold)
                                        
                                    }
                                    
                                    else{
                                        Image(systemName : "exclamationmark.circle.fill")
                                            .foregroundColor(.orange)
                                        
                                        Text("업데이트가 필요합니다.")
                                            .foregroundColor(.orange)
                                            .fontWeight(.semibold)
                                        
                                    }
                                }
                                
                                if helper.latestVersion != version || helper.latestBuild != build{
                                    Spacer().frame(height : 5)
                                    
                                    HStack{
                                        Button(action : {}){
                                            Text("업데이트")
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                            }
                        }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor))
                        
                        Spacer().frame(height : 20)
                        
                        Group{
                            NavigationLink(destination : PDFViewer(url: Bundle.main.url(forResource: "EULA", withExtension: "pdf")!).navigationBarTitle("서비스 이용 약관", displayMode: .inline)){
                                PlainButtonFramework(imageName : "ic_eula", txt : "서비스 이용 약관 읽기")
                            }
                            
                            Spacer().frame(height : 20)

                            NavigationLink(destination : PDFViewer(url: Bundle.main.url(forResource: "PrivacyLicense", withExtension: "pdf")!).navigationBarTitle("개인정보 처리 방침", displayMode: .inline)){
                                PlainButtonFramework(imageName : "ic_privacy", txt : "개인정보 처리 방침 읽기")
                            }
                            
                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : OpenSourceLicenseinfoView()){
                                PlainButtonFramework(imageName : "ic_opensource", txt : "오픈소스 라이센스 정보")
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
            }.background(Color.background.edgesIgnoringSafeArea(.all))
        }.navigationBarTitle("정보", displayMode: .inline)
            .onAppear{
                guard let dictionary = Bundle.main.infoDictionary,
                      let version = dictionary["CFBundleShortVersionString"] as? String,
                      let build = dictionary["CFBundleVersion"] as? String                 else{
                          return
                      }

                
                self.version = version
                self.build = build
                
                helper.getLatestInfo(){result in
                    guard let result = result else{return}
                }
            }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .preferredColorScheme(.dark)
    }
}
