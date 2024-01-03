//
//  SupportedLanguageModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/06/13.
//

import SwiftUI

struct SupportedLanguageModel: View {
    let language : String?
    let code : String?
    
    var body: some View {
        VStack{
            HStack {
                Text(language ?? "")
                    .fontWeight(.semibold)
                .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            HStack {
                Text(code ?? "")
                    .font(.caption)
                .foregroundColor(.gray)
                
                Spacer()
            }
        }.padding(10)
            .background(RoundedRectangle(cornerRadius:15).foregroundColor(.btnColor).shadow(radius: 5))
            
    }
}
