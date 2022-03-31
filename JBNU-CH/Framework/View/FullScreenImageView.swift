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
                            .frame(width : 300, height : 300)
                        
                    case .failure :
                        EmptyView()
                        
                    @unknown default :
                        EmptyView()
                    }
                })
            }.background(Color.black)
                .navigationBarItems(trailing: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                })
        }

    }
}
