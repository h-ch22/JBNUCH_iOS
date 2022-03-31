//
//  PledgeListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct PledgeListModel: View {
    let data : PledgeDataModel
    
    var body: some View {
        VStack {
            HStack {
                Text(data.pledgeName)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.txtColor)
                
                Spacer()
                
                Text(data.pledgeCategory)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height : 10)
            
            switch data.pledgeStatus{
            case .Preparing:
                HStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(.red).frame(width : 10, height : 10)
                    
                    Spacer().frame(width : 5)
                    
                    Text("준비 중")
                        .font(.caption)

                    Spacer()
                }
                
            case .InProgress:
                HStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(.orange).frame(width : 10, height : 10)
                    
                    Spacer().frame(width : 5)
                    
                    Text("진행 중")
                        .font(.caption)

                    Spacer()

                }
                
            case .Complete:
                HStack {
                    RoundedRectangle(cornerRadius: 15).foregroundColor(.green).frame(width : 10, height : 10)
                    
                    Spacer().frame(width : 5)
                    
                    Text("완료")
                        .font(.caption)

                    Spacer()

                }
            }
        }.padding(20)
        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
    }
}
