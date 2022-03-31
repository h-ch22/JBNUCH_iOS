//
//  NoticeListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct NoticeListModel: View {
    let data : NoticeDataModel
    
    var body: some View {
        VStack{
            HStack{
                if data.type == .CH{
                    Text("총학")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.accent))
                }
                
                else{
                    Text("단대")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 5).foregroundColor(.orange))
                }
                Spacer().frame(width : 10)

                Text(data.title ?? "")
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
                

                
                Spacer()
            }
            
            Spacer().frame(height : 5)
            
            HStack{
                Text(data.dateTime ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
            }
        }
    }
}
