//
//  PetitionListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI

struct PetitionListModel: View {
    let data : PetitionDataModel
    
    var body: some View {
        VStack{
            HStack{
                Text(data.category ?? "")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.orange))
                
                Spacer().frame(width : 10)
                
                Text(data.title ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
                if data.recommend ?? 0 >= 100{
                    Spacer().frame(width : 15)
                    
                    Image(systemName : "crown.fill")
                        .resizable()
                        .frame(width : 20, height : 15)
                        .foregroundColor(.orange)
                    
                    Text("채택")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
                
                Spacer()
            }
            
            Spacer().frame(height : 5)
            
            HStack{
                Text(data.timeStamp ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .frame(width : 15, height: 15)
                    .foregroundColor(.red)
                
                Text(String(data.recommend ?? 0))
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
