//
//  PlainButtonFramework.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/03.
//

import SwiftUI

struct PlainButtonFramework: View {
    let imageName : String
    let txt : String
    
    var body: some View {
        HStack {
            if imageName == "ic_jbnu"{
                Image(imageName)
                    .resizable()
                    .frame(width : 25, height : 30)
            }
            
            else if imageName == "ic_signout"{
                Image(imageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.txtColor)
            }
            
            else if imageName == "ic_phone"{
                Image(systemName : "phone.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.txtColor)
            }
            
            else if imageName == "ic_info"{
                Image(imageName)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.txtColor)
            }
            
            else{
                Image(imageName)
                    .resizable()
                    .frame(width : 30, height : 30)
            }

            Text(txt)
                .foregroundColor(.txtColor)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
        }.padding(20)
        
            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btnColor).shadow(radius: 5)).padding([.horizontal], 10)
    }
}

struct PlainButtonFramework_Previews: PreviewProvider {
    static var previews: some View {
        PlainButtonFramework(imageName : "ic_jbnu", txt : "")
    }
}
