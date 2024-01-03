//
//  CouponListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import SwiftUI

struct CouponListModel: View {
    let data : QRCodeModel
    
    var body: some View {
        VStack(alignment : .leading){
            HStack {
                Text(AES256Util.decrypt(encoded: data.benefits))
                    .font(.title2)
                    .fontWeight(.semibold)
                .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            Spacer().frame(height : 10)
            
            Text("교환처 : \(AES256Util.decrypt(encoded: data.store))")
                .font(.caption)
                .foregroundColor(.accent)
            
            Spacer().frame(height : 10)

            Text("유효 기간 : \(data.expireDate)")
                .font(.caption)
                .foregroundColor(.gray)
            
        }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor))
    }
}
