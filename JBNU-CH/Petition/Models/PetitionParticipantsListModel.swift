//
//  PetitionParticipantsListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct PetitionParticipantsListModel: View {
    let data : PetitionParticipantsModel
    
    var body: some View {
        VStack{
            HStack {
                Text("동의합니다.")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)
            
            HStack {
                Text("\(data.college) \(data.studentNo) \(data.name)")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .fontWeight(.semibold)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)

            HStack {
                Text(data.date)
                    .foregroundColor(.gray)
                    .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
        }.padding(20)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
    }
}
