//
//  QRResultView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import SwiftUI

struct QRResultView: View {
    @Environment(\.presentationMode) private var presentationMode
    let result : QRCodeModel
    
    var body: some View {
        VStack{
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.green)
            
            Text("등록이 완료되었어요!")
                .fontWeight(.semibold)
            
            Spacer().frame(height : 30)
            
            HStack{
                Text("등록 업체")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(AES256Util.decrypt(encoded: result.store))
                    .font(.caption)
            }
            
            HStack{
                Text("만료일")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(result.expireDate)
                    .font(.caption)
            }
            
            HStack{
                Text("혜택")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(AES256Util.decrypt(encoded: result.benefits))
                    .multilineTextAlignment(.leading)
                    .font(.caption)
            }
            
            Spacer().frame(height : 15)
            
            Text("학우님의 데이터가 안전하게 서버로 전송되었습니다.")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer().frame(height : 20)

            Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }){
                HStack{
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                    
                    Text("뒤로")
                        .foregroundColor(.white)
                }.padding([.horizontal], 50)
                    .padding(20)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.blue))
            }

        }.padding(20)
    }
}
