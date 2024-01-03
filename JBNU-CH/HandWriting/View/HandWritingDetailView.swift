//
//  HandWritingDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/03.
//

import SwiftUI
import SwiftUIPager

struct HandWritingDetailView: View {
    let data : HandWritingDataModel
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManagement : UserManagement
    @EnvironmentObject var helper : HandWritingHelper
    
    @State private var isRecommender = false
    @State private var page : Page = .first()
    @State private var isAuthor = false
    @State private var showAlert = false
    @State private var alertModel : HandWritingDetailViewAlertModel?
    @State private var showOverlay = false
    
    func imgView(_ page : Int) -> some View{
        AsyncImage(url : helper.urlList[page].url, content : {phase in
            switch phase{
            case .empty :
                ProgressView().padding(5)
                
            case .success(let image) :
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width : 300, height : 300)
                    .onTapGesture {
                        
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
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    if data.imageIndex > 0{
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
                            .preferredItemSize(CGSize(width : 300, height : 200))
                            .onPageWillChange({(newIndex) in
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                            })
                        
                            .frame(height : 300)
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Group{
                        HandWritingContentsModel(title: "✏️ 시험 이름".localized(), contents: data.examName)
                        
                        Spacer().frame(height : 20)
                        
                        HandWritingContentsModel(title: "🗓 시험 날짜".localized(), contents: data.examDate)
                        
                        Spacer().frame(height : 20)
                        
                        HandWritingContentsModel(title: "💭 시험을 준비하게 된 계기".localized(), contents: data.meter)
                        
                        Spacer().frame(height : 20)
                    }
                    
                    Group{
                        HandWritingContentsModel(title: "⏰ 시험 준비 기간".localized(), contents: data.term)
                        
                        Spacer().frame(height : 20)
                        
                        HandWritingContentsModel(title: "🙋🏻‍♀️ 시험을 본 후기".localized(), contents: data.review)
                        
                        Spacer().frame(height : 20)
                        
                        HandWritingContentsModel(title: "📚 자신만의 공부법".localized(), contents: data.howTO)
                        
                        Spacer().frame(height : 20)
                    }
                    
                }.padding(20)
                    .navigationBarTitle(data.title, displayMode: .large)
                
            }.background(Color.background.edgesIgnoringSafeArea(.all))
                .onAppear{
                    
                    helper.getRecommender(data : data, userModel : userManagement.userInfo){result in
                        guard let result = result else{return}
                        
                        if result{
                            isRecommender = true
                        }
                        
                        else{
                            isRecommender = false
                        }
                    }
                    
                    if data.imageIndex ?? 0 > 0{
                        helper.downloadImage(data : data){result in
                            guard let result = result else{return}
                        }
                    }
                    
                
                }
            
                .navigationBarItems(trailing: userManagement.userInfo?.uid == data.uid ? Button(action : {
                    alertModel = .confirmRemove
                    showAlert = true
                }){
                    Image(systemName : "xmark")
                        .foregroundColor(.red)
                } : Button(action : {
                    alertModel = .confirmRecommend
                    showAlert = true
                }){
                    Image(systemName : "hand.thumbsup.fill")
                        .foregroundColor(.red)
                })
            
                .overlay(ProgressView().isHidden(!showOverlay))
            
                .alert(isPresented : $showAlert){
                    switch alertModel{
                    case .confirmRemove:
                        return Alert(title: Text("삭제"), message: Text("수기를 삭제하시겠습니까?"), primaryButton: .default(Text("예")){
                            showOverlay = true
                            
                            helper.removeHandWriting(data: self.data){result in
                                guard let result = result else{return}
                                
                                showOverlay = false
                                
                                if result{
                                    alertModel = .successRemove
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .failRemove
                                    showAlert = true
                                }
                            }
                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .successRemove:
                        return Alert(title: Text("삭제 완료"), message: Text("수기가 삭제되었습니다."), dismissButton: .default(Text("확인")){
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        
                    case .failRemove:
                        return Alert(title: Text("오류"), message: Text("요청을 처리하는 중 문제가 발생하였습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .confirmRecommend:
                        return Alert(title: Text("추천"), message: Text("이 수기를 추천하시겠습니까?"), primaryButton: .default(Text("예")){
                            if isRecommender{
                                alertModel = .AlreadyRecommended
                                showAlert = true
                            }
                            
                            else{
                                showOverlay = true
                                
                                helper.recommend(data : data, userModel : userManagement.userInfo){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        
                                        helper.getRecommender(data : data, userModel : userManagement.userInfo){result in
                                            guard let result = result else{return}
                                            
                                            if result{
                                                isRecommender = true
                                            }
                                            
                                            else{
                                                isRecommender = false
                                            }
                                        }
                                        
                                        alertModel = .successRecommend
                                        showAlert = true
                                    }
                                    
                                    else{
                                        alertModel = .failRecommend
                                        showAlert = true
                                    }
                                }
                            }

                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .successRecommend:
                        return Alert(title: Text("추천"), message: Text("추천하였습니다."), dismissButton: .default(Text("확인")))

                    case .failRecommend:
                        return Alert(title: Text("오류"), message: Text("요청을 처리하는 중 문제가 발생하였습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))

                    case .AlreadyRecommended:
                        return Alert(title: Text("이미 추천한 수기"), message: Text("이미 추천한 수기입니다."), dismissButton: .default(Text("확인")))

                    case .none:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))

                    }
                }
        }
    }
}
