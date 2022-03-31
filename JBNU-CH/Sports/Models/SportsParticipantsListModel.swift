//
//  SportsParticipantsModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct SportsParticipantsListModel: View {
    let data : SportsParticipantsDataModel
    
    var body: some View {
        HStack{
            Image("ic_logo_no_slogan")
                .resizable()
                .frame(width : 30, height : 30)
            
            Spacer().frame(width : 20)
            
            VStack{
                HStack {
                    Text(data.name)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                
                Spacer().frame(height : 10)
                
                HStack {
                    Text(data.college + " " + data.studentNo)
                        .font(.caption)
                    .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                Spacer().frame(height : 5)
                
                HStack {
                    Text(data.phone)
                        .font(.caption)
                    .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }.padding(20)
            .background(RoundedRectangle(cornerRadius: 15.0)
                            .shadow(radius: 2, x: 0, y: 2)
                            .foregroundColor(.btnColor))
    }
}
