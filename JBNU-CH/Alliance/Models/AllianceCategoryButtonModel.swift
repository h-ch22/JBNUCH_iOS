//
//  AllianceCategoryButtonModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct AllianceCategoryButtonModel: View {
    let imageName : String
    let categoryName : String
    
    var body: some View {
        VStack{
            Image(imageName)
                .resizable()
                .frame(width : 60, height : 60)
            
            Text(categoryName)
                .foregroundColor(.txtColor)
        }.padding(20)
        .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btnColor))
    }
}

struct AllianceCategoryButtonModel_Previews: PreviewProvider {
    static var previews: some View {
        AllianceCategoryButtonModel(imageName : "ic_all", categoryName: "전체")
    }
}
