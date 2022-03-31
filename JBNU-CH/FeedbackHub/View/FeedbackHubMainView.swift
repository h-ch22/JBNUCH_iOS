//
//  FeedbackHubMainView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct FeedbackHubMainView: View {
    @State var selectedCategory : FeedbackHubCategoryModel?
    @StateObject var userManagement : UserManagement

    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    Image("ic_feedbackHubMain")
                        .resizable()
                        .frame(width : 250, height : 250)
                    
                    Text("먼저 카테고리를 선택해주세요.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.txtColor)
                    
                    Spacer().frame(height : 20)
                    
                    Group{
                        HStack{
                            Button(action : {
                                selectedCategory = .Facility
                            }){
                                HStack{
                                    Image(systemName: "wrench.and.screwdriver.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(selectedCategory == .Facility ? .accent : Color.gray)
                                    
                                    Text("시설")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedCategory == .Facility ? .accent : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedCategory == .Facility ? .accent : Color.gray, lineWidth: 2))

                            Button(action : {
                                selectedCategory = .Welfare
                            }){
                                HStack{
                                    Image(systemName: "cross.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(selectedCategory == .Welfare ? .accent : Color.gray)
                                    
                                    Text("복지")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedCategory == .Welfare ? .accent : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedCategory == .Welfare ? .accent : Color.gray, lineWidth: 2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Button(action : {
                                selectedCategory = .Communication
                            }){
                                HStack{
                                    Image(systemName: "bubble.left.and.bubble.right.fill")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(selectedCategory == .Communication ? .accent : Color.gray)
                                    
                                    Text("소통")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedCategory == .Communication ? .accent : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedCategory == .Communication ? .accent : Color.gray, lineWidth: 2))

                            Button(action : {
                                selectedCategory = .Pledge
                            }){
                                HStack{
                                    Image(systemName: "list.bullet.rectangle")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(selectedCategory == .Pledge ? .accent : Color.gray)
                                    
                                    Text("공약")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedCategory == .Pledge ? .accent : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedCategory == .Pledge ? .accent : Color.gray, lineWidth: 2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        HStack{
                            Button(action : {
                                selectedCategory = .Event
                            }){
                                HStack{
                                    Image(systemName: "rays")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .foregroundColor(selectedCategory == .Event ? .accent : Color.gray)
                                    
                                    Text("행사")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedCategory == .Event ? .accent : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedCategory == .Event ? .accent : Color.gray, lineWidth: 2))

                            Button(action : {
                                selectedCategory = .App
                            }){
                                HStack{
                                    Image(systemName: "apps.iphone")
                                        .resizable()
                                        .frame(width : 20, height : 30)
                                        .foregroundColor(selectedCategory == .App ? .accent : Color.gray)
                                    
                                    Text("앱")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedCategory == .App ? .accent : Color.gray)
                                }
                            }.frame(width : 120,
                                    height : 40)
                            .padding(30)
                            .background(RoundedRectangle(cornerRadius: 20)
                            .stroke(selectedCategory == .App ? .accent : Color.gray, lineWidth: 2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        Button(action : {
                            selectedCategory = .Others
                        }){
                            HStack{
                                Image(systemName: "ellipsis.circle.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(selectedCategory == .Others ? .accent : Color.gray)
                                
                                Text("기타")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedCategory == .Others ? .accent : Color.gray)
                            }
                        }.frame(width : 120,
                                height : 40)
                        .padding(30)
                        .background(RoundedRectangle(cornerRadius: 20)
                        .stroke(selectedCategory == .Others ? .accent : Color.gray, lineWidth: 2))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    NavigationLink(destination : FeedbackHubView(feedbackCategory : selectedCategory, userManagement : userManagement)){
                        HStack {
                            Text("다음 단계로")
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.white)
                        .padding([.horizontal], 120)
                        .padding([.vertical], 20)
                        .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.accent).shadow(radius : 5))
                        .isHidden(selectedCategory == nil)
                    }
                    
                    Spacer().frame(height : 20)
                        .isHidden(userManagement.userInfo?.admin == nil)
                    
                    NavigationLink(destination : AllFeedbackView(userManagement : userManagement)){
                        Text("전체 피드백")
                    }.isHidden(userManagement.userInfo?.admin == nil)
                }.padding(20)
            }.background(Color.background.edgesIgnoringSafeArea(.all))
            .animation(.easeOut)
            .navigationBarTitle("피드백 허브", displayMode : .inline)
            .navigationBarItems(trailing: NavigationLink(destination : MyFeedbackView(userManagement : userManagement)){
                Text("보낸 피드백")
            })
        }
    }
}
