//
//  FeedbackHubListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/04.
//

import SwiftUI

struct FeedbackHubListModel: View {
    let data : FeedbackHubDataModel
    let type : String
    
    var body: some View {
        VStack{
            Group{
                HStack{
                    switch data.type{
                    case .Good:
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.txtColor)
                        
                        Text("칭찬해요")
                            .foregroundColor(.txtColor)
                            .font(.caption)
                        
                    case .Bad:
                        Image(systemName: "chevron.right.2")
                            .rotationEffect(Angle(degrees: -90))
                            .font(.caption)
                            .foregroundColor(.txtColor)

                        Text("개선해주세요")
                            .foregroundColor(.txtColor)
                            .font(.caption)

                    case .Question:
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.txtColor)
                            .font(.caption)

                        Text("궁금해요")
                            .foregroundColor(.txtColor)
                            .font(.caption)

                    case .none :
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    Text(data.date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height : 5)

                HStack {
                    Text(data.title)
                        .foregroundColor(.txtColor)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(data.college + " " + data.studentNo + " " + data.name)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                        .isHidden(self.type == "User")
                }
                
                if data.answer != ""{
                    Spacer().frame(height : 5)

                    HStack {
                        Text("피드백에 대한 답변이 등록되었습니다.")
                            .foregroundColor(.accent)
                            .font(.caption)
                        
                        Spacer()
                    }
                }
                
                else{
                    Spacer().frame(height : 5)

                    HStack {
                        Text("아직 답변이 등록되지 않은 피드백입니다.")
                            .foregroundColor(.accent)
                            .font(.caption)
                        
                        Spacer()
                    }
                }
            }
        }.padding([.vertical], 20)
    }
}
