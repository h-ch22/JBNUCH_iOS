//
//  HandWritingContentsModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import SwiftUI

struct HandWritingContentsModel: View {
    let title : String
    let contents : String
    
    var body: some View {
        VStack{
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.txtColor)
            
            Divider()
            
            HStack {
                Text(contents)
                    .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .foregroundColor(.txtColor)
                
                Spacer()
            }
        }.padding(20)
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
    }
}
