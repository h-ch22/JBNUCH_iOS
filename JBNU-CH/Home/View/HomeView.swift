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
    @StateObject private var homeHelper = HomeCalendarHelper()
    @State private var today = ""
    @State private var month = ""
    @State private var day = ""
    
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
                                
                                VStack(alignment : .trailing){
                                    Text(today)
                                        .font(.caption)
                                        .fontWeight(.light)
                                        .foregroundColor(.gray)
                                    
                                    Text(day)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                }
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

                                NavigationLink(destination : ProductsMainView().environmentObject(helper)){
                                    VStack{
                                        Image("ic_products")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                        
                                        Text("대여사업")
                                            .foregroundColor(.txtColor)
                                    }
                                }.frame(width : 60, height : 60)
                                
                                Spacer().frame(width : 50)
                                
                                NavigationLink(destination : CalendarMainView().environmentObject(helper)){
                                    VStack{
                                        Image("ic_calendar")
                                            .resizable()
                                            .frame(width : 40, height : 40)
                                        
                                        Text("캘린더")
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
                                        NavigationLink(destination : NoticeDetailView(data : index, userInfo : helper.userInfo, helper : noticeHelper, userManagement: helper)){
                                            HomeListModel(title: index.title ?? "", dateTime: index.dateTime ?? "")
                                                .padding(5)

                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer().frame(height : 40)
                        
                        Group{
                            HStack{
                                Text("🗓 다가올 취업/대외활동/학사일정")
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 20)

                            ScrollView(.horizontal){
                                HStack(spacing : 15){
                                    ForEach(homeHelper.data, id : \.self){index in
                                        NavigationLink(destination : CalendarMainView()){
                                            if index.isAllDay{
                                                HomeListModel(title: index.title, dateTime: "\(index.startDate)")
                                                    .padding(5)
                                            }
                                            
                                            else{
                                                HomeListModel(title: index.title, dateTime: "\(index.startDate) ~ \(index.endDate)")
                                                    .padding(5)
                                            }
                                            
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
                                                .padding(5)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }.padding([.horizontal], 20)
                }
            }.background(Color.background.edgesIgnoringSafeArea(.all))
                .navigationBarHidden(true)
                .animation(.easeOut)

                .onAppear{
                    var formatter = DateFormatter()
                    formatter.dateFormat = "MM/dd"
                    
                    today = formatter.string(from: Date())
                    
                    var formatter_day = DateFormatter()
                    formatter_day.dateFormat = "E"
                    
                    day = formatter_day.string(from: Date())
                    
                    homeHelper.getData(){ result in
                        guard let result = result else{return}
                    }
                    
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
