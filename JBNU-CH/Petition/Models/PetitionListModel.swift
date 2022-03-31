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
                Text(data.title ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
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
