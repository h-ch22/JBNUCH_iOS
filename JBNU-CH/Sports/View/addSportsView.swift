//
//  addSportsView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import SwiftUI
import NMapsMap

struct addSportsView: View {
    @ObservedObject var receiver : SportsLocationReceiver
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManagement : UserManagement
    
    @StateObject private var helper = SportsHelper()
    
    @State private var selectedDate = Date.now
    @State private var roomName = ""
    @State private var sportsType = ""
    @State private var allPeople = ""
    @State private var currentPeople = ""
    @State private var locationDescription = ""
    @State private var others = ""
    @State private var latLng : NMGLatLng? = nil
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var alertModel : addSportsAlertModel?
    @State private var isOnlinePlay = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                ZStack {
                    Color.background.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        DatePicker("마감 날짜", selection : $selectedDate, in : Date.now...)
                        
                        Spacer().frame(height : 20)
                        
                        Group{
                            TextField("방 이름", text : $roomName)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                                .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                            
                            TextField("종목", text : $sportsType)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                                .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                            
                            TextField("전체 인원 (본인 포함)", text : $allPeople)
                                .keyboardType(.numberPad)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                                .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                            
                            TextField("현재 인원 (본인 포함)", text : $currentPeople)
                                .keyboardType(.numberPad)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                                .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                        }
                        
                        Group{
                            HStack{
                                CheckBox(checked : $isOnlinePlay)
                                Text("비대면 진행")
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            VStack{
                                NavigationLink(destination : SportsLocationSelectView(receiver : receiver)
                                                .navigationBarTitle(Text("장소 선택"), displayMode : .inline)){
                                    if receiver.location.isEmpty{
                                        HStack {
                                            Image(systemName: "location.fill.viewfinder")
                                                .resizable()
                                                .frame(width : 20, height : 20)
                                            
                                            Text("장소 선택")
                                            
                                        }
                                    }
                                    
                                    else{
                                        VStack {
                                            HStack {
                                                Image(systemName: "location.fill.viewfinder")
                                                    .resizable()
                                                    .frame(width : 20, height : 20)
                                                
                                                Text(receiver.address + "\n 장소 설명 : " + receiver.description)
                                                    .multilineTextAlignment(.leading)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                
                                            }
                                            
                                            Text("다시 설정하려면 누르세요.")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                        }
                                    }
                                }.padding(20)
                                    .padding([.horizontal], 20)
                                    .foregroundColor(receiver.location.isEmpty ? .txtColor : .white)
                                    .background(RoundedRectangle(cornerRadius: 30)
                                                    .foregroundColor(receiver.location.isEmpty ? .btnColor : .accent)
                                                    .shadow(radius: 5)
                                                    .padding([.horizontal],15))
                            }.isHidden(isOnlinePlay)
                            
                        }
                        
                        Group{
                            Spacer().frame(height : 20)
                            
                            TextField("기타", text : $locationDescription)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                                .padding([.horizontal],15))
                            
                            Spacer().frame(height : 20)
                            
                            VStack{
                                Text("제3자 개인정보 제공 사항")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txtColor)
                                
                                Spacer().frame(height : 20)
                                
                                Text("제공 정보 : 성명, 학과, 학번, 연락처\n제공 목적 : 신원 확인 및 개별 연락\n아래 버튼을 클릭함으로 위 정보를 제3자에게 제공하는 것에 대해 동의하는 것으로 간주합니다.")
                                    .lineSpacing(8)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.txtColor)
                                
                                Spacer().frame(height : 20)
                                
                                Text("총학생회는 용병 구인 과정에서 중계 역할만 진행하며, 용병의 구인 ~ 스포츠 진행 과정에 발생하는 모든 문제에 대해 책임을 지지 않습니다.")
                                    .font(.caption)
                                    .lineSpacing(8)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundColor(.gray)
                            }.padding(20)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor))
                            
                            Button(action : {
                                if roomName.isEmpty || sportsType.isEmpty || allPeople.isEmpty || currentPeople.isEmpty || (!isOnlinePlay && receiver.location.isEmpty){
                                    alertModel = .emptyField
                                    showAlert = true
                                }
                                
                                else if Int(allPeople) ?? 0 <= Int(currentPeople) ?? 0{
                                    alertModel = .peopleLimit
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .confirm
                                    showAlert = true
                                }
                            }){
                                HStack {
                                    Text("용병 구인 신청하기")
                                    
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                                .padding([.horizontal], 60)
                                .padding([.vertical], 20)
                                .background(RoundedRectangle(cornerRadius: 30).shadow(radius : 5))
                            }
                        }
                        
                    }.padding(20)
                        .navigationBarTitle("용병 구인", displayMode: .inline)
                        .navigationBarItems(trailing: Button("닫기"){
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    
                        .overlay(ProgressView().isHidden(!showOverlay))
                    
                        .alert(isPresented: $showAlert, content: {
                            switch alertModel{
                            case .confirm:
                                return Alert(title: Text("업로드"), message: Text("방을 추가할까요?"), primaryButton: .default(Text("예")){
                                    self.showOverlay = true
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy.MM.dd. HH:mm"
                                    
                                    helper.uploadRoom(data: SportsDataModel(roomName: roomName, sportsType: sportsType, allPeople: Int(allPeople) ?? 0, currentPeople: Int(currentPeople) ?? 0, locationDescription: receiver.description, others: others, manager: userManagement.userInfo?.uid ?? "", location: receiver.location, dateTime: dateFormatter.string(from: selectedDate), userInfo: userManagement.userInfo, id : "", address : receiver.address, isOnline : isOnlinePlay, status : "")){result in
                                        guard let result = result else{return}
                                        
                                        showOverlay = false
                                        
                                        if !result{
                                            alertModel = .uploadFail
                                            showAlert = true
                                        }
                                        
                                        else{
                                            alertModel = .uploadSuccess
                                            showAlert = true
                                        }
                                    }
                                }, secondaryButton: .default(Text("아니오")))
                                
                            case .uploadFail:
                                return Alert(title: Text("오류"), message: Text("업로드 작업 중 문제가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                                
                            case .uploadSuccess:
                                return Alert(title: Text("업로드 완료"), message: Text("업로드가 완료되었습니다."), dismissButton: .default(Text("확인")){
                                    self.presentationMode.wrappedValue.dismiss()
                                })
                                
                            case .emptyField:
                                return Alert(title: Text("공백 필드"), message: Text("모든 필드를 채워주세요."), dismissButton: .default(Text("확인")))

                            case .peopleLimit:
                                return Alert(title: Text("인원 초과"), message: Text("모집 인원보다 현재 인원이 같거나 많을 수 없습니다."), dismissButton: .default(Text("확인")))

                            case .none:
                                return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))
                            }
                        })
                }
            }.background(Color.background.edgesIgnoringSafeArea(.all))
            
        }
    }
}
