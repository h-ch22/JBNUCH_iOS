//
//  TutorialView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI

struct TutorialView: View {
    @State private var step = 0
    
    @State private var tutorial_txt : [String] = ["전북대앱을 실행하고, 우측 상단 메뉴를 터치하세요.", "오아시스 버튼을 터치하세요.", "학사 정보 버튼을 터치하세요.", "학적-기본조회 버튼을 터치하세요.", "해당 화면을 캡처해 불러오세요."]
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    switch step{
                        case 0:
                        Image("tutorialimg_0")
                            .resizable()
                            .frame(width : 150, height : 250)
                        
                        Text(tutorial_txt[step])
                        
                        case 1:
                        Image("tutorialimg_1")
                            .resizable()
                            .frame(width : 150, height : 250)

                        Text(tutorial_txt[step])

                        case 2:
                        Image("tutorialimg_2")
                            .resizable()
                            .frame(width : 150, height : 250)

                        Text(tutorial_txt[step])

                        case 3:
                        Image("tutorialimg_3")
                            .resizable()
                            .frame(width : 150, height : 250)

                        Text(tutorial_txt[step])

                        case 4:
                        Image("tutorialimg_4")
                            .resizable()
                            .frame(width : 150, height : 250)

                        Text(tutorial_txt[step])

                    default:
                        Image("")
                    }
                    
                    HStack{
                        if step > 0{
                            Button(action : {
                                step-=1
                            }){
                                Image(systemName: "arrow.left.circle.fill")
                                    .resizable()
                                    .frame(width : 60, height : 60)
                                    .foregroundColor(.accent)
                            }
                        }
                        Spacer()
                        
                        if step < 4{
                            Button(action : {
                                step+=1
                            }){
                                Image(systemName: "arrow.right.circle.fill")
                                    .resizable()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.accent)
                            }
                        }
                        

                    }
                }.padding(20)
            }.navigationBarTitle(Text("튜토리얼"))
                .navigationBarTitleDisplayMode(.inline)
        }

    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
