//
//  PetitionNoticeListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/07/01.
//

import SwiftUI

struct PetitionNoticeListModel: View {
    let data : NoticeDataModel
    
    var body: some View {
        VStack{
            HStack{
                Text(data.title ?? "")
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            Spacer().frame(height : 5)
            
            HStack{
                Text(data.dateTime ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
        }.padding(5)
    }
}
