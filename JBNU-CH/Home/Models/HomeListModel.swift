//
//  HomeListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/23.
//

import SwiftUI

struct HomeListModel: View {
    let title : String
    let dateTime : String
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            Spacer().frame(height : 10)
            
            HStack{
                Text(dateTime)
                    .foregroundColor(.gray)
                    .font(.caption)
                
                Spacer()
            }
        }
        .padding([.horizontal], 20)
        .padding([.vertical], 10)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius : 3))
    }
}
