//
//  ProductLogListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI

struct ProductLogListModel: View {
    let imgName : String
    let productName : String
    let number : String
    let isReturned : Bool
    let dayLimit : String
    let day : String
    
    var body: some View {
        VStack{
            HStack{
                if imgName == "ic_football"{
                    Image(imgName)
                        .resizable()
                        .frame(width : 60, height : 60)
                        .foregroundColor(.txtColor)

                }
                
                else{
                    Image(imgName)
                        .resizable()
                        .frame(width : 60, height : 60)
                }
                
                Text("\(day) : \(productName)")
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            HStack{
                Text("\(number) 개")
                    .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            HStack{
                if isReturned{
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width : 25, height : 25)
                        .foregroundColor(.green)
                    
                    Text("반납 완료")
                        .foregroundColor(.green)
                    
                    Spacer()
                }
                
                else{
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width : 25, height : 25)
                        .foregroundColor(.red)
                    
                    Text("미반납 (반납 기일 : \(dayLimit))")
                        .foregroundColor(.red)
                    
                    Spacer()
                }
            }
        }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
    }
}
