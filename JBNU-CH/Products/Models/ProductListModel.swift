//
//  ProductListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI

struct ProductListModel: View {
    let imgName : String
    let productName : String
    let all : String
    let late : String
    
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
                
                Text(productName)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            HStack{
                Text("\(late) / \(all)")
                    .foregroundColor(.txtColor)
                
                Spacer()
            }
        }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
    }
}
