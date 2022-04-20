//
//  StudentAssociationView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import SwiftUI

struct StudentAssociationView: View {
    var body: some View {
        ScrollView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Group{
                        HStack{
                            Image("ic_logo_no_slogan")
                                .resizable()
                                .frame(width : 150, height : 150)
                            
                            Spacer()
                        }
                        
                        HStack{
                            Text("총학생회 소개")
                                .fontWeight(.semibold)
                                .foregroundColor(.txtColor)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination : GreetingView()){
                            PlainButtonFramework(imageName: "ic_greet", txt: "인사말")
                        }
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination : InternalWebView(url: URL(string: "http://jbnuch.co.kr/file/")!)){
                            PlainButtonFramework(imageName: "ic_introduce_dept", txt: "총학생회 사이트")
                        }
                        
                        Spacer().frame(height : 20)
                    }
                    
                    NavigationLink(destination : InternalWebView(url: URL(string: "https://www.youtube.com/channel/UC-k_69T0cKQriqjpB09fFkw")!)){
                        PlainButtonFramework(imageName: "ic_youtube", txt: "총학생회 유튜브")
                    }
                    
                    Spacer().frame(height : 20)
                    
                    NavigationLink(destination : InternalWebView(url : URL(string: "https://linktr.ee/jbnu_ch")!)){
                        PlainButtonFramework(imageName: "ic_link", txt: "총학생회 링크트리")
                    }
                    
                    Spacer().frame(height : 20)

                    NavigationLink(destination : StudentAssociationLinker()){
                        PlainButtonFramework(imageName: "ic_introduce_map", txt: "찾아오시는 길")
                    }
                    
                    Spacer().frame(height : 20)
                }.padding(20)
            }
        }.background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationBarTitle("총학생회 소개", displayMode: .inline)
        .animation(.easeOut)

    }
}

struct StudentAssociationView_Previews: PreviewProvider {
    static var previews: some View {
        StudentAssociationView()
            .preferredColorScheme(.dark)
    }
}
