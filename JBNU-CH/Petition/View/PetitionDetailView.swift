//
//  PetitionDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI
import SwiftUIPager

struct PetitionDetailView: View {
    let item : PetitionDataModel
    
    @StateObject var userInfo : UserManagement
    @StateObject var helper : PetitionHelper
    
    @State private var showAlert = false
    @State private var showOverlay = false
    @State private var alertModel : PetitionAlertModel? = nil
    @State private var page : Page = .first()

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
        ScrollView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    PetitionStatusModel(status: item.status)
                    
                    if item.imageIndex ?? 0 > 0{
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
                    
                    HStack{
                        Text(item.contents ?? "")
                            .lineSpacing(5)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(role: .cancel, action: {
                        alertModel = .recommend
                        showAlert = true
                    }, label: {
                        HStack{
                            Image(systemName: "hand.thumbsup.fill")
                            
                            Text("청원하기")
                        }
                    }).buttonStyle(.bordered)
                    .controlSize(.large)
                    .isHidden(self.userInfo.userInfo?.uid == AES256Util.decrypt(encoded: self.item.author ?? "") || helper.recommenders.contains(where: {$0.uid == self.userInfo.userInfo?.uid}))
                    
                    Spacer().frame(width : 20).isHidden(self.userInfo.userInfo?.uid == AES256Util.decrypt(encoded: self.item.author ?? "") || helper.recommenders.contains(where: {$0.uid == self.userInfo.userInfo?.uid}))
                    
                    Button(role: .destructive, action: {
                        alertModel = .remove
                        showAlert = true
                    }, label: {
                        HStack{
                            Image(systemName: "xmark")
                            
                            Text("삭제하기")
                        }
                    }).buttonStyle(.bordered)
                    .controlSize(.large)
                    .isHidden(self.userInfo.userInfo?.uid != AES256Util.decrypt(encoded: self.item.author ?? ""))
                    
                    Spacer().frame(width : 20)
                    
                    ForEach(helper.recommenders, id : \.self){item in
                        PetitionParticipantsListModel(data : item)
                    }
                }.padding([.horizontal], 20)
            }

        }.background(Color.background.edgesIgnoringSafeArea(.all))
        .navigationTitle(item.title ?? "")
        .alert(isPresented: $showAlert, content: {
            switch alertModel{
            case .recommend:
                return Alert(title: Text("청원"), message: Text("이 청원에 청원하시겠습니까?"), primaryButton: .default(Text("예")){
                    showOverlay = true
                    
                    helper.recommend(userInfo: userInfo.userInfo, id: item.id ?? ""){result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                        
                        if result{
                            alertModel = .recommendSuccess
                            showAlert = true
                        }
                        
                        else{
                            alertModel = .recommendFail
                            showAlert = true
                        }
                    }
                    
                }, secondaryButton: .default(Text("아니오")))
                
            case .remove:
                return Alert(title: Text("삭제"), message: Text("이 청원을 제거하시겠습니까?"), primaryButton: .default(Text("예")){
                    showOverlay = true
                    
                    helper.removePetition(id: item.id ?? ""){result in
                        guard let result = result else{return}
                        showOverlay = false

                        if result{
                            alertModel = .removeSuccess
                            showAlert = true
                        }
                        
                        else{
                            alertModel = .removeFail
                            showAlert = true
                        }
                    }
                }, secondaryButton: .default(Text("아니오")))
                
            case .removeSuccess:
                return Alert(title: Text("삭제 완료"), message: Text("청원이 삭제되었습니다."), dismissButton: .default(Text("확인")))

            case .removeFail:
                return Alert(title: Text("오류"), message: Text("청원을 삭제하는 중 문제가 발생했습니다.\n나중에 다시 시도하세요."), dismissButton: .default(Text("확인")))

            case .recommendSuccess:
                return Alert(title: Text("청원 완료"), message: Text("청원하였습니다."), dismissButton: .default(Text("확인")))
                
            case .recommendFail:
                return Alert(title: Text("오류"), message: Text("청원 중 문제가 발생했습니다.\n나중에 다시 시도하세요."), dismissButton: .default(Text("확인")))

            case .none:
                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))
            }
        })
        .overlay(ProgressView().isHidden(!showOverlay))
        
        .onAppear{
            helper.getRecommender(id : item.id ?? ""){result in
                guard let result = result else{return}
                
            }
            
            if item.imageIndex ?? 0 > 0{
                helper.downloadImage(id: item.id ?? "", imageIndex: item.imageIndex ?? 0)
            }
        }
    }
}
