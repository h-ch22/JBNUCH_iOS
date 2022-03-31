//
//  HomeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var helper : UserManagement
    @StateObject private var noticeHelper = NoticeHelper()
    @StateObject private var sportsHelper = SportsHelper()
    @StateObject private var petitionHelper = PetitionHelper()
    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack{
                    Color.background.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        Group{
                            HStack{
                                Text("안녕하세요,\n\(helper.userInfo?.name ?? "")님!")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)

                            HStack{
                                NavigationLink(destination : AllianceListView(category : "전체", userManagement: helper)
                                    .environmentObject(AllianceHelper(userInfo: helper.userInfo))){
                                    VStack{
                                        Image(systemName: "location.fill.viewfinder")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                            .foregroundColor(.txtColor)
                                            
                                        
                                        Text("제휴업체")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                                
                                Spacer().frame(width : 50)

                                NavigationLink(destination : NoticeListView(helper: NoticeHelper())){
                                    VStack{
                                        Image(systemName: "bell.fill")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                            .foregroundColor(.txtColor)
                                        
                                        Text("공지사항")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                                
                                Spacer().frame(width : 50)
                                
                                NavigationLink(destination : PetitionListView(helper : PetitionHelper(), userInfo : helper)){
                                    VStack{
                                        Image("ic_jbnu")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                            .foregroundColor(.txtColor)
                                        
                                        Text("청원제도")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                            }
                            
                            Spacer().frame(height : 40)

                            HStack{
                                NavigationLink(destination : FeedbackHubMainView(userManagement : helper)){
                                    VStack{
                                        Image("ic_feedbackHub")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                        
                                        Text("피드백")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                                
                                Spacer().frame(width : 50)

                                NavigationLink(destination : ProductView(userManagement: helper)){
                                    VStack{
                                        Image("ic_products")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                        
                                        Text("대여사업")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                                
                                Spacer().frame(width : 50)
                                
                                NavigationLink(destination : PledgeMainView().environmentObject(helper)){
                                    VStack{
                                        Image("ic_percentage")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                        
                                        Text("공약")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                            }
                        }
                        
                        Spacer().frame(height : 40)
                        
                        Group{
                            HStack{
                                Text("🔔 최신 공지사항")
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)

                            ScrollView(.horizontal){
                                HStack(spacing : 15){
                                    ForEach(noticeHelper.noticeList, id : \.self){index in
                                        NavigationLink(destination : NoticeDetailView(data : index, userInfo : helper.userInfo, userManagement: helper).environmentObject(noticeHelper)){
                                            HomeListModel(title: index.title ?? "", dateTime: index.dateTime ?? "")
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height : 40)
                        
                        Group{
                            HStack{
                                Text("⚽️ 스포츠로 몸을 풀어볼까요?")
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)

                            ScrollView(.horizontal){
                                HStack(spacing : 15){
                                    ForEach(sportsHelper.sportsList, id : \.self){index in
                                        NavigationLink(destination : SportsDetailView(data: index, helper: sportsHelper).environmentObject(helper)){
                                            HomeListModel(title: index.roomName ?? "", dateTime: index.dateTime ?? "")
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height : 40)
                        
                        Group{
                            HStack{
                                Text("✨ 이런 청원은 어떤가요?")
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)

                            ScrollView(.horizontal){
                                HStack(spacing : 15){
                                    ForEach(petitionHelper.petitionList, id : \.self){index in
                                        NavigationLink(destination : PetitionDetailView(item: index, userInfo: helper, helper: petitionHelper)){
                                            HomeListModel(title: index.title ?? "", dateTime: index.timeStamp ?? "")
                                        }
                                    }
                                }
                            }
                        }
                        
                    }.padding([.horizontal], 20)
                }
            }.background(Color.background.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
                .onAppear{
                    noticeHelper.noticeList.removeAll()

                    noticeHelper.getNotice(userInfo : helper.userInfo){result in
                        guard let result = result else{return}
                        
                        if result{
                            noticeHelper.noticeList.sort(by: {$0.dateTime ?? "" > $1.dateTime ?? ""})
                            
                        }
                    }
                    
                    petitionHelper.petitionList.removeAll()
                    
                    petitionHelper.getPetitionList(){result in
                        guard let result = result else{return}
                    }
                    
                    sportsHelper.sportsList.removeAll()
                    
                    sportsHelper.getSportsList(userInfo : helper.userInfo){result in
                        guard let result = result else{return}
                    }
                }

        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(UserManagement())
    }
}
