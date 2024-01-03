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
    let college : CollegeCodeModel?
    let userManagment = UserManagement()
    @StateObject var helper : AllianceHelper
    @State private var favoriteAdded = false
    @State private var favoriteRemoved = false

    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    displayMap(data: data)
                        .frame(height : 300)

                    VStack {
                        VStack {
                            VStack{
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
                                
                                Spacer().frame(height : 10)
                                
                                HStack{
                                    if data.allianceType == "단대"{
                                        Text(userManagment.convertCollegeCodeAsShortString(collegeCode: college))
                                            .font(.caption)
                                            .padding(5)
                                            .foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
                                    }
                                    
                                    else{
                                        Text(data.allianceType)
                                            .padding(5)
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accent))
                                    }
                                    
                                    Spacer().frame(width : 5)

                                    Text(data.storeName ?? "")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.txtColor)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer().frame(width : 5)
                                    
                                    Button(action : {
                                        helper.addFavorite(data : data){result in
                                            guard let result = result else{return}
                                            
                                            switch result{
                                                case true:
                                                self.favoriteAdded = true
                                                self.favoriteRemoved = false
                                                
                                               case false:
                                                self.favoriteAdded = false
                                                self.favoriteRemoved = true
                                            }
                                        }
                                    }){
                                        if favoriteAdded{
                                            Image(systemName: "star.fill").foregroundColor(.accent)

                                        }
                                        
                                        else if favoriteRemoved{
                                            Image(systemName: "star.fill").foregroundColor(.gray)

                                        }
                                        
                                        else{
                                            Image(systemName: "star.fill").foregroundColor(data.isFavorite! ? .accent : .gray)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                HStack{
                                    Text(data.benefits ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .fixedSize(horizontal: false, vertical: true)

                                    Spacer()
                                }
                            }
                            
                            Divider().frame(height : 3)
                            
                            HStack {
                                Button(action: {
                                    let url = URL(string: "tel://\(data.tel ?? "")")
                                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                                }){
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .resizable()
                                            .frame(width : 20, height : 20)
                                            .foregroundColor(.txtColor)
                                        
                                        Text("전화")
                                            .foregroundColor(.txtColor)
                                    }
                                }
                                
                                if data.URL_Naver != "" && data.URL_Naver != nil{
                                    Spacer().frame(width : 20)
                                    
                                    Button(action : {
                                        let url = URL(string : data.URL_Naver ?? "")
                                        UIApplication.shared.open(url!, options: [:])
                                    }){
                                        HStack{
                                            Image(systemName: "safari.fill")
                                                .resizable()
                                                .frame(width : 20, height : 20)
                                                .foregroundColor(.txtColor)
                                            
                                            Text("업체 정보")
                                                .foregroundColor(.txtColor)
                                        }
                                    }
                                }
                                
                                if data.URL_Baemin != "" && data.URL_Baemin != nil{
                                    Spacer().frame(width : 20)

                                    Button(action : {
                                        let url = URL(string : data.URL_Baemin ?? "")
                                        UIApplication.shared.open(url!, options: [:])
                                    }){
                                        HStack{
                                            Image(systemName: "bicycle.circle")
                                                .resizable()
                                                .frame(width : 20, height : 20)
                                                .foregroundColor(.txtColor)
                                            
                                            Text("배달")
                                                .foregroundColor(.txtColor)
                                        }
                                    }
                                }
                                
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
                                    Text("\(data.price ?? "")" + "원".localized())
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
