//
//  AllianceDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct displayMap : UIViewControllerRepresentable{
    let data : AllianceDataModel
    typealias UIViewControllerType = ViewInsideMap
    
    func makeUIViewController(context: Context) -> ViewInsideMap {
        return ViewInsideMap(location : data.location, markerTitle : data.storeName, subTitle: data.benefits)
    }
    
    func updateUIViewController(_ uiViewController: ViewInsideMap, context: Context) {
        
    }
}

struct AllianceDetailView: View {
    let data : AllianceDataModel
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    displayMap(data: data)
                        .frame(height : 300)

                    VStack {
                        HStack{
                            AsyncImage(url: data.storeLogo,
                                       content : {phase in
                                switch phase{
                                case .empty:
                                    ProgressView()
                                    
                                case .success(let image) :
                                    image.resizable()
                                        .aspectRatio(contentMode : .fit)
                                        .frame(width : 120, height : 120)
                                    
                                case .failure :
                                    EmptyView()
                                    
                                @unknown default:
                                    EmptyView()
                                    
                                }

                            })
                                .shadow(radius: 10)
                                .cornerRadius(15)
                            
                            Spacer().frame(width : 20)
                            
                            VStack{
                                HStack{
                                    Text(data.storeName ?? "")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.txtColor)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text(data.benefits ?? "")
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Spacer()
                                }
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                let url = URL(string: "tel://\(data.tel ?? "")")
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }){
                                Image(systemName: "phone.circle.fill")
                                    .resizable()
                                    .frame(width : 40, height : 40)
                                    .foregroundColor(.accent)
                                    
                            }
                        }.padding(20)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Image("ic_logo_no_slogan")
                                .resizable()
                                .frame(width : 120, height : 120)
                                .shadow(radius: 10)
                                .cornerRadius(15)
                            
                            Spacer().frame(width : 20)
                            
                            VStack{
                                HStack{
                                    Text(data.menu ?? "")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.txtColor)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("\(data.price ?? "")원")
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Spacer()
                                }
                            }
                        }
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                        .isHidden(data.menu == "")
                        
                    }.padding([.horizontal], 20)
                    
                }
                    .navigationBarTitle(data.storeName ?? "", displayMode: .inline)
            }
            

            
        }
    }
}
