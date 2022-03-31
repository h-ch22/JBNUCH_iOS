//
//  MarketDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import SwiftUI
import SwiftUIPager

struct MarketDetailView: View {
    let data : MarketDataModel
    let helper = MarketHelper()
    
    @State private var page : Page = .first()
    @State private var showSheet = false
    @State private var selectedImg : URL? = nil

    func imgView(_ page : Int) -> some View{
        AsyncImage(url : helper.urlList[page], content : {phase in
            switch phase{
            case .empty :
                ProgressView().padding(5)
                
            case .success(let image) :
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width : 300, height : 300)
                    .onTapGesture {
                        self.selectedImg = helper.urlList[page]
                        
                        if selectedImg != nil{
                            showSheet = true
                        }
                    }
            case .failure :
                EmptyView()
                
            @unknown default :
                EmptyView()
            }
        })
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius : 15).stroke(Color.accent, lineWidth : 2))
            .shadow(radius: 5)
    }
    
    var body: some View {
        VStack{
            if data.imgCount! > 0 && !helper.urlList.isEmpty{
                Pager(page : self.page,
                      data : helper.urlList.indices,
                      id : \.self){
                    self.imgView($0)
                }.interactive(scale : 0.8)
                    .interactive(opacity: 0.5)
                    .itemSpacing(10)
                    .pagingPriority(.simultaneous)
                    .itemAspectRatio(1.3, alignment: .start)
                    .padding(20)
                    .sensitivity(.high)
                    .preferredItemSize(CGSize(width : 300, height : 300))
                    .onPageWillChange({(newIndex) in
                        let generator = UIImpactFeedbackGenerator(style: .soft)
                        generator.impactOccurred()
                    })
                
                    .frame(height : 300)
            }
            
            HStack {
                Text(data.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                .foregroundColor(.txtColor)
                
                Spacer()
                
            }
            
            HStack{
                Text(String(data.price ?? 0))
                    .foregroundColor(.txtColor)
                
                Spacer()
            }
            
            Spacer()
            
            ScrollView{
                Text(data.contents ?? "")
                    .foregroundColor(.txtColor)
                    .lineSpacing(5)
            }.frame(height : 250)
            
            HStack{
                Button(action : {}){
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width : 20, height : 20)
                        .foregroundColor(.white)
                        .padding(20)
                }.background(RoundedRectangle(cornerRadius: 15).foregroundColor(.gray))
                
                NavigationLink(destination : EmptyView()){
                    Text("판매자와 채팅하기")
                        .foregroundColor(.white)
                        .padding(20)
                        .padding([.horizontal], 60)
                }.background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent))
                
            }.background(Rectangle().foregroundColor(.btnColor))
        }.padding(20)
            .onAppear{
                helper.downloadImage(id : data.id ?? "", imgIndex : data.imgCount ?? 0){result in
                    guard let result = result else{return}
                }
            }
    }
}
