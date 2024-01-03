//
//  MoreView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct MoreView: View {
    @EnvironmentObject var helper : UserManagement
    @State private var showModal = false
    private let cache = ImageCache()
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        Group{
                            NavigationLink(destination : ProfileView().environmentObject(helper)){
                                HStack{
                                    if helper.userInfo?.profile != nil{
                                        WebImage(url : helper.userInfo?.profile!)
                                            .onSuccess{image, data, cacheType in }
                                            .placeholder{
                                                ProgressView()
                                                    .frame(width : 50, height : 50)
                                            }
                                            .resizable()
                                            .shadow(radius: 5)
                                            .clipShape(Circle())
                                            .frame(width : 50, height : 50)
                                            .aspectRatio(contentMode: .fit)
                                    }
                                    
                                    
                                    else{
                                        Image("ic_logo_no_slogan")
                                            .resizable()
                                            .frame(width : 50, height : 50)
                                    }
                                    
                                    VStack{
                                        HStack{
                                            Text(helper.userInfo?.name ?? "알 수 없는 사용자".localized())
                                                .fontWeight(.semibold)
                                                .foregroundColor(.txtColor)
                                                .multilineTextAlignment(.leading)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Text("\(helper.userInfo?.college ?? "") \(helper.userInfo?.studentNo ?? "")")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                                .fixedSize(horizontal: false, vertical: true)
                                            
                                            Spacer()
                                        }
                                        
                                        VStack{
                                            Spacer().frame(height : 10)
                                                .isHidden(helper.userInfo?.spot ?? "" == "")
                                            HStack{
                                                Image(systemName : "checkmark.shield.fill")
                                                    .foregroundColor(.green)
                                                    .isHidden(helper.userInfo?.spot ?? "" == "")
                                                
                                                
                                                Text(helper.userInfo?.spot ?? "")
                                                    .font(.caption)
                                                    .foregroundColor(.green)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .isHidden(helper.userInfo?.spot ?? "" == "")
                                                
                                                Spacer()
                                                    .isHidden(helper.userInfo?.spot ?? "" == "")
                                                
                                            }.isHidden(helper.userInfo?.spot ?? "" == "")
                                        }.isHidden(helper.userInfo?.spot ?? "" == "")
                                    }
                                }
                                
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.btnColor).shadow(radius: 5)).padding([.horizontal], 10)
                            }
                            
                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                            
                        }
                        
                        Group {
//                            NavigationLink(destination : StudentAssociationView()){
//                                PlainButtonFramework(imageName: "ic_logo_no_slogan", txt: "총학생회 소개".localized())
//                            }
                            
//                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : EmptyView()){
                                PlainButtonFramework(imageName : "ic_logo_no_slogan", txt : "총학생회 사이트".localized())
                            }
                            
                            NavigationLink(destination : PetitionListView(helper : PetitionHelper(), userInfo : helper)){
                                PlainButtonFramework(imageName: "ic_jbnu", txt: "전대 청원제도".localized())
                            }
                            
                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : CampusMapView()){
                                PlainButtonFramework(imageName: "ic_map", txt: "캠퍼스 맵".localized())
                            }
                            
                            Spacer().frame(height : 20)
                            
//                            NavigationLink(destination : SportsListView().environmentObject(helper)){
//                                PlainButtonFramework(imageName: "ic_sports", txt: "스포츠 용병 제도".localized())
//                            }
                            
//                            Spacer().frame(height : 20)
                            
//                            NavigationLink(destination : CalendarMainView()){
//                                PlainButtonFramework(imageName: "ic_calendar", txt: "취업/대외활동/학사일정 캘린더")
//                            }
//
//                            Spacer().frame(height : 20)
                            
                        }
                        
                        Group{
//                            NavigationLink(destination : HandWritingListView().environmentObject(helper)){
//                                PlainButtonFramework(imageName: "ic_crown", txt: "합격자 수기 공유".localized())
//                            }
                            
//                            Spacer().frame(height : 20)
                            
//                            NavigationLink(destination : PledgeMainView().environmentObject(helper)){
//                                PlainButtonFramework(imageName: "ic_percentage", txt: "실시간 공약 이행률".localized())
//                            }
                        }
                        
                        Group{
//                            Spacer().frame(height : 20)
                        
                            
//                            NavigationLink(destination : ProductsMainView().environmentObject(helper)){
//                                PlainButtonFramework(imageName: "ic_products", txt: "대여사업 물품 잔여수량 확인".localized())
//                            }
                            
//                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : FeedbackHubMainView(userManagement : helper)){
                                PlainButtonFramework(imageName: "ic_feedbackHub", txt: "피드백 허브".localized())
                            }
                            
                        }
                        
//                        if helper.userInfo?.admin == .CH_PRD_President{
//                            Spacer().frame(height : 20)
//
//                            Button(action : {
//                                self.showModal = true
//                            }){
//                                PlainButtonFramework(imageName: "ic_gear", txt: "Change College")
//                            }
//                        }
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination : InfoView()){
                            PlainButtonFramework(imageName: "ic_info", txt: "정보".localized())
                        }
                    }
                    .padding([.horizontal], 20)
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                    .animation(.easeOut)
//                    .sheet(isPresented: $showModal, content: {
//                        ChangeCollegeView().environmentObject(helper)
//                    })
                    
                    
                }
                
            }.navigationBarHidden(true)
            
        }
    }
}
