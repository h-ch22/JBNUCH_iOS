//
//  MoreView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

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
                                    if cache.get(forKey: "profile") != nil{
                                        Image(uiImage: cache.get(forKey: "profile")!)
                                            .resizable()
                                                .clipShape(Circle())
                                                .frame(width : 50, height : 50)
                                                .aspectRatio(contentMode: .fit)
                                    }
                                    
                                    else{
                                        if helper.userInfo?.profile != nil{
                                            AsyncImage(url : helper.userInfo?.profile!, content : {phase in
                                                switch phase{
                                                case .empty :
                                                    ProgressView()
                                                        .overlay(Circle().stroke(Color.accent, lineWidth : 2))
                                                        .padding(5)
                                                    
                                                case .success(let image) :
                                                    image.resizable()
                                                        .clipShape(Circle())
                                                        .frame(width : 50, height : 50)
                                                        .aspectRatio(contentMode: .fit)
                                                        .onAppear{
                                                            cache.set(forKey: "profile", image: image.asUIImage())
                                                        }
                                                    
                                                case .failure :
                                                    Image("ic_logo_no_slogan")
                                                        .resizable()
                                                        .frame(width : 50, height : 50)
                                                    
                                                @unknown default :
                                                    Image("ic_logo_no_slogan")
                                                        .resizable()
                                                        .frame(width : 50, height : 50)
                                                }
                                            })
                                                .shadow(radius: 5)
                                        }
                                        
                                        
                                        else{
                                            Image("ic_logo_no_slogan")
                                                .resizable()
                                                .frame(width : 50, height : 50)
                                        }
                                    }
                                    
                                    VStack{
                                        HStack{
                                            Text(helper.userInfo?.name ?? "알 수 없는 사용자")
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
                            NavigationLink(destination : StudentAssociationView()){
                                PlainButtonFramework(imageName: "ic_logo_no_slogan", txt: "총학생회 소개")
                            }
                            
                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : PetitionListView(helper : PetitionHelper(), userInfo : helper)){
                                PlainButtonFramework(imageName: "ic_jbnu", txt: "전대 청원제도")
                            }
                            
                            Spacer().frame(height : 20)

                            NavigationLink(destination : CampusMapView()){
                                PlainButtonFramework(imageName: "ic_map", txt: "캠퍼스 맵")
                            }
                            
                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : SportsListView().environmentObject(helper)){
                                PlainButtonFramework(imageName: "ic_sports", txt: "스포츠 용병 제도")
                            }
                            
//                            Spacer().frame(height : 20)
//                            
//                            NavigationLink(destination : EmptyView()){
//                                PlainButtonFramework(imageName: "ic_calendar", txt: "취업/대외활동/학사일정 캘린더")
//                            }
                            
                            Spacer().frame(height : 20)

                        }
                        
                        Group{
//                            NavigationLink(destination : MealView()){
//                                PlainButtonFramework(imageName: "ic_meal", txt: "이 주의 학식")
//                            }
//
//                            Spacer().frame(height : 20)

                            NavigationLink(destination : HandWritingListView().environmentObject(helper)){
                                PlainButtonFramework(imageName: "ic_crown", txt: "합격자 수기 공유")
                            }
                            
                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : PledgeMainView().environmentObject(helper)){
                                PlainButtonFramework(imageName: "ic_percentage", txt: "실시간 공약 이행률")
                            }
                        }
                        
                        Group{
//                            Spacer().frame(height : 20)
//
//                            if helper.userInfo?.collegeCode == CollegeCodeModel.COH || helper.userInfo?.collegeCode == CollegeCodeModel.COM || helper.userInfo?.collegeCode == CollegeCodeModel.SOC || helper.userInfo?.admin == AdminCodeModel.CH_PRD_President{
//                                NavigationLink(destination : EmptyView()){
//                                    PlainButtonFramework(imageName: "ic_studyRoom", txt: "스터디룸 예약")
//                                }
//
//                                Spacer().frame(height : 20)
//
//                            }
//
//                            if helper.userInfo?.collegeCode == CollegeCodeModel.COH || helper.userInfo?.admin == AdminCodeModel.CH_PRD_President{
//                                NavigationLink(destination : EmptyView()){
//                                    PlainButtonFramework(imageName: "ic_library", txt: "인문대 독서실 좌석 예약")
//                                }
//
//                                Spacer().frame(height : 20)
//                            }
//
//                            NavigationLink(destination : MarketListView().environmentObject(helper)){
//                                PlainButtonFramework(imageName: "ic_market", txt: "중고 장터")
//                            }
                            
                            Spacer().frame(height : 20)
                            
                            NavigationLink(destination : ProductsMainView().environmentObject(helper)){
                                PlainButtonFramework(imageName: "ic_products", txt: "대여사업 물품 잔여수량 확인")
                            }
                            
                            Spacer().frame(height : 20)

                            NavigationLink(destination : FeedbackHubMainView(userManagement : helper)){
                                PlainButtonFramework(imageName: "ic_feedbackHub", txt: "피드백 허브")
                            }
                            
                            if helper.userInfo?.admin == .CH_PRD_President{
                                Spacer().frame(height : 20)

                                Button(action : {
                                    self.showModal = true
                                }){
                                    PlainButtonFramework(imageName: "ic_gear", txt: "Change College")
                                }
                            }
                            
                            Spacer().frame(height : 20)

                            NavigationLink(destination : InfoView()){
                                PlainButtonFramework(imageName: "ic_info", txt: "정보")
                            }
                        }
                    }
                    .padding([.horizontal], 20)
                    .background(Color.background.edgesIgnoringSafeArea(.all))
                    .animation(.easeOut)
                    .sheet(isPresented: $showModal, content: {
                        ChangeCollegeView().environmentObject(helper)
                    })

                    
                }

            }.navigationBarHidden(true)

        }
    }
}
