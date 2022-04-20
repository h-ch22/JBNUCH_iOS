//
//  OpenSourceListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/19.
//

import SwiftUI

struct OpenSourceListModel: View {
    let data : OpenSourceDataModel
    
    var body: some View {
        VStack(alignment : .leading){
            Text(data.title)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)

            Link(data.url, destination: URL(string : data.url)!)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(data.copyrightInfo)
                .font(.caption)
                .foregroundColor(.gray)
                .fixedSize(horizontal: false, vertical: true)

            Text(data.licenseType)
                .font(.caption)
                .fontWeight(.bold)
                .fixedSize(horizontal: false, vertical: true)

        }
    }
}
