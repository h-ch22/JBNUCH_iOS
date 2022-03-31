//
//  HandWritingListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import SwiftUI

struct HandWritingListModel: View {
    let data : HandWritingDataModel
    
    var body: some View {
        VStack{
            HStack{
                Text(data.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .frame(width : 15, height: 15)
                    .foregroundColor(.red)
                
                Text(String(data.recommend ?? 0))
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer().frame(height : 5)
            
            HStack{
                Text(data.college + " " + data.studentNo + " " + data.name)
                    .foregroundColor(.txtColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)

            HStack {
                Text(data.examName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)

            HStack {
                Text(data.date)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
        }        .padding([.vertical], 20)
    }
}
