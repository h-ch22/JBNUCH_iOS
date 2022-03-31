//
//  MarketListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import SwiftUI

struct MarketListModel: View {
    let data : MarketDataModel
    
    var body: some View {
        HStack{
            AsyncImage(url: data.thumbnail,
                       content : {phase in
                switch phase{
                case .empty:
                    ProgressView()
                    
                case .success(let image) :
                    image.resizable()
                        .aspectRatio(contentMode : .fit)
                        .frame(width : 80, height : 80)
                    
                case .failure :
                    EmptyView()
                    
                @unknown default:
                    EmptyView()
                    
                }

            })
                .cornerRadius(15)
                .shadow(radius: 5)
            
            VStack{
                HStack {
                    Text(data.title ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.txtColor)
                    
                    Spacer()
                    
                    Text(data.category ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height : 10)
                
                HStack {
                    Text("\(String(data.price ?? 0))원")
                        .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                    
                    Spacer()
                }
                
                Spacer().frame(height : 10)

                HStack {
                    Text("\(data.sellerInfo ?? "")개")
                        .font(.caption)
                    .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
    }
}
