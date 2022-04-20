//
//  FullScreenImageView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import SwiftUI

struct FullScreenImageView: View {
    let image : String?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            VStack {
                AsyncImage(url : URL(string: image ?? ""), content : {phase in
                    switch phase{
                    case .empty :
                        ProgressView().padding(5)
                        
                    case .success(let image) :
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                        
                    case .failure :
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .frame(width : 200, height : 200)
                            .foregroundColor(.red)
                        
                    @unknown default :
                        ProgressView().padding(5)
                    }
                })
            }.background(Color.black)
                .navigationBarItems(trailing: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                })
        }

    }
}
