//
//  editNoticeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/28.
//

import SwiftUI

struct editNoticeView: View {
    @State private var noticeTitle : String = ""
    @State private var noticeContents : String = ""
    @State private var alertModel : addNoticeAlertModel? = nil
    @State private var showOverlay = false
    @State private var showAlert = false
    
    @StateObject var helper : NoticeHelper
    @StateObject var userManagement : UserManagement
    @Environment(\.presentationMode) var presentationMode
    
    let data : NoticeDataModel
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("공지사항 제목", text : $noticeTitle)
                    .padding(20)
                    .padding([.horizontal], 20)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                    .padding([.horizontal],15))
                
                Spacer().frame(height : 20)
                
                TextEditor(text: $noticeContents)
                    .foregroundColor(.txtColor)
                    .lineSpacing(5)
                    .border(Color.btnColor, width : 2)
                
                Spacer().frame(height : 20)
            }.padding(20)
                .onAppear{
                    noticeTitle = data.title ?? ""
                    noticeContents = data.contents ?? ""
                }
            
                .navigationBarTitle("공지사항 수정", displayMode: .inline)
            
                .navigationBarItems(leading: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                }, trailing : Button("업로드"){
                    alertModel = .upload
                    showAlert = true
                })
            
                .overlay(ProcessView().isHidden(!showOverlay))
            
                .alert(isPresented : $showAlert){
                    switch alertModel{
                    case .upload:
                        return Alert(title: Text("업로드"), message: Text("공지사항을 업로드할까요?"), primaryButton: .default(Text("예")){
                            showOverlay = true
                            
                            switch userManagement.userInfo?.admin{
                            case .CH_President,
                                    .CH_VicePresident,
                                    .CH_PRD_President,
                                    .CH_PRD_VicePresident,
                                    .CH_PRD_Member:
                                
                                helper.editNotice(id : data.id ?? "", admin : "CH", title : noticeTitle, contents : noticeContents, data : data){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        self.alertModel = .uploadSuccess
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .uploadFail
                                        showAlert = true
                                    }
                                }
                                
                            case .COM_President,
                                    .COM_VicePresident,
                                    .COM_PRD_President,
                                    .COM_PRD_VicePresident:
                                helper.editNotice(id : data.id ?? "", admin: "COM", title : noticeTitle, contents : noticeContents, data : data){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        self.alertModel = .uploadSuccess
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .uploadFail
                                        showAlert = true
                                    }
                                }
                                
                            case .SOC_President,
                                    .SOC_VicePresident,
                                    .SOC_PRD_President,
                                    .SOC_PRD_VicePresident:
                                helper.editNotice(id : data.id ?? "", admin : "SOC", title : noticeTitle, contents : noticeContents, data : data){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        self.alertModel = .uploadSuccess
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .uploadFail
                                        showAlert = true
                                    }
                                }
                                
                            case .COH_President,
                                    .COH_VicePresident,
                                    .COH_PRD_President,
                                    .COH_PRD_VicePresident:
                                helper.editNotice(id : data.id ?? "", admin : "COH", title : noticeTitle, contents : noticeContents, data : data){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        self.alertModel = .uploadSuccess
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .uploadFail
                                        showAlert = true
                                    }
                                }
                                
                            case .CON_President,
                                    .CON_VicePresident,
                                    .CON_PRD_President,
                                    .CON_PRD_VicePresident:
                                helper.editNotice(id : data.id ?? "", admin : "CON", title : noticeTitle, contents : noticeContents, data : data){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        self.alertModel = .uploadSuccess
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .uploadFail
                                        showAlert = true
                                    }
                                }
                                
                            case .CHE_President,
                                    .CHE_VicePresident,
                                    .CHE_PRD_President,
                                    .CHE_PRD_VicePresident:
                                helper.editNotice(id : data.id ?? "", admin : "CHE", title : noticeTitle, contents : noticeContents, data : data){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if result{
                                        self.alertModel = .uploadSuccess
                                        showAlert = true
                                    }
                                    
                                    else{
                                        self.alertModel = .uploadFail
                                        showAlert = true
                                    }
                                }
                                
                            default:
                                self.alertModel = .uploadFail
                                showAlert = true
                            }
                            
                            
                            

                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .uploadFail:
                        return Alert(title: Text("오류"), message: Text("업로드 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")){
                            
                        })
                        
                    case .uploadSuccess:
                        return Alert(title: Text("업로드 완료"), message: Text("공지사항이 업로드되었습니다."), dismissButton: .default(Text("확인")){
                            self.presentationMode.wrappedValue.dismiss()
                        })

                    case .none:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))
                    }
                }
        }
    }
}
