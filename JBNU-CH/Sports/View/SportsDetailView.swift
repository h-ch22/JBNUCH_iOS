//
//  SportsDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct displaySportsMap : UIViewControllerRepresentable{
    let data : SportsDataModel
    typealias UIViewControllerType = ViewInsideMap
    
    func makeUIViewController(context: Context) -> ViewInsideMap {
        return ViewInsideMap(location : data.location, markerTitle : data.roomName ?? "", subTitle : data.sportsType ?? "")
    }
    
    func updateUIViewController(_ uiViewController: ViewInsideMap, context: Context) {
        
    }
}

struct SportsDetailView: View {
    let data : SportsDataModel
    
    @EnvironmentObject var userManagement : UserManagement
    @StateObject var helper : SportsHelper
    @State private var isManager = false
    @State private var isParticipant = false
    @State private var alertModel : SportsDetailViewAlertModel?
    @State private var showAlert = false
    @State private var showOverlay = false
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    if !data.isOnline{
                        displaySportsMap(data: data)
                            .frame(height : 300)
                    }

                    VStack {
                        SportsListModel(data: data)
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 15.0)
                                            .shadow(radius: 2, x: 0, y: 2)
                                        .foregroundColor(.btnColor))
                        
                        if isManager || isParticipant{
                            if helper.participantsList.isEmpty{
                                Text("아직 참가자가 없습니다.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            else{
                                ForEach(helper.participantsList, id : \.self){item in
                                    SportsParticipantsListModel(data : item)
                                }
                            }
                        }
                        
                        if !isManager && !isParticipant{
                            Button(action : {
                                alertModel = .confirmApply
                                showAlert = true
                            }){
                                HStack {
                                    Text("지원하기")
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                                .padding([.horizontal], 120)
                                .padding([.vertical], 20)
                                .background(RoundedRectangle(cornerRadius: 30).shadow(radius : 5))
                            }
                        }
                        
                        else if isParticipant{
                            Button(action : {
                                alertModel = .confirmCancel
                                showAlert = true
                            }){
                                HStack {
                                    Text("지원 취소")
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                                .padding([.horizontal], 120)
                                .padding([.vertical], 20)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.red).shadow(radius : 5))
                            }
                        }
                        

                    }.padding(20)
                    
                }
                .navigationBarTitle(data.roomName, displayMode: .inline)
                .onAppear{
                    if userManagement.userInfo?.uid == data.manager{
                        isManager = true
                    }
                    
                    helper.getParticipants(id: data.id){result in
                        guard let result = result else{return}
                        
                        if result{
                            if helper.participantsList.contains(where: {$0.uid == userManagement.userInfo?.uid}){
                                isParticipant = true
                            }
                        }
                    }

                }
                
                .navigationBarItems(trailing: Button(action : {
                    alertModel = .confirmRemove
                    showAlert = true
                }){
                    Image(systemName : "xmark")
                        .foregroundColor(.red)
                }.isHidden(!isManager))
                
                .alert(isPresented : $showAlert){
                    switch alertModel{
                    case .confirmApply:
                        return Alert(title: Text("지원 확인"), message: Text("지원하시겠습니까?"), primaryButton: .default(Text("예")){
                            showOverlay = true
                            
                            helper.participate(id : data.id, userInfo : userManagement.userInfo){result in
                                guard let result = result else{return}
                                
                                showOverlay = false
                                
                                if result{
                                    alertModel = .successApply
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .failApply
                                    showAlert = true
                                }
                            }
                            
                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .successApply:
                        return Alert(title: Text("지원 완료"), message: Text("정상적으로 처리되었습니다."), dismissButton: .default(Text("확인")))
                        
                    case .failApply:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .confirmCancel:
                        return Alert(title: Text("지원 취소"), message: Text("지원을 취소하시겠습니까?"), primaryButton: .default(Text("예")){
                            helper.cancel(id : data.id, userModel : userManagement.userInfo){result in
                                guard let result = result else{return}
                                
                                if result{
                                    alertModel = .successCancel
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .failCancel
                                    showAlert = true
                                }
                            }
                        }, secondaryButton: .default(Text("아니오")))

                    case .successCancel:
                        return Alert(title: Text("취소 완료"), message: Text("정상적으로 처리되었습니다."), dismissButton: .default(Text("확인")))

                    case .failCancel:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))

                    case .confirmRemove:
                        return Alert(title: Text("제거 확인"), message: Text("방을 제거하시겠습니까?"), primaryButton: .default(Text("예")){
                            helper.removeRoom(id: data.id, userModel: userManagement.userInfo){result in
                                guard let result = result else{return}
                                
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
                        return Alert(title: Text("제거 완료"), message: Text("정상적으로 처리되었습니다."), dismissButton: .default(Text("확인")))

                    case .failRemove:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))

                    case .none:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("")))
                    }
                }
                
                .overlay(ProgressView().isHidden(!showOverlay))
            }
            

            
        }
    }
}
