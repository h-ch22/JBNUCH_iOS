//
//  FeedbackHubDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/04.
//

import SwiftUI

struct FeedbackHubDetailView: View {
    let data : FeedbackHubDataModel
    let type : String
    
    @StateObject var userManagement : UserManagement
    @StateObject var helper : FeedbackHubHelper
    
    @State private var answer : String = ""
    @State private var showAlert = false
    @State private var showOverlay = false
    @State private var alertModel : FeedbackHubAnswerAlertModel?
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    Group{
                        FeedbackHubListModel(data: data, type: type)
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Text(data.contents)
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.txtColor)
                            
                            Spacer()
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                        
                        Spacer().frame(height : 20)

                    }
                    
                    if data.answer != ""{
                        VStack{
                            Group{
                                Spacer().frame(height : 20)

                                Text("피드백에 대한 답변입니다.")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txtColor)
                                
                                Spacer().frame(height : 20)
                                
                                Divider()
                                
                                Spacer().frame(height : 20)
                                
                                HStack {
                                    Text(data.answer)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                        .foregroundColor(.txtColor)
                                        .padding(20)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height : 20)
                                
                                Divider()
                                
                                Spacer().frame(height : 20)
                                
                                HStack{
                                    Image(systemName : "checkmark.shield.fill")
                                        .foregroundColor(.green)
                                    
                                    Text("답변 작성자 : \(data.answer_author)")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                }
                            }

                            
                            Spacer().frame(height : 10)
                            
                            Text(data.answer_date)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer().frame(height : 20)

                        }
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    if type == "Admin"{
                        Group{
                            Text("피드백 답변 등록하기")
                                .fontWeight(.semibold)
                            
                            TextEditor(text: $answer)
                                .padding([.horizontal], 20)
                                .frame(height : 200)
                        }

                    }
                    
                }.padding(20)
            }.background(Color.background.edgesIgnoringSafeArea(.all))
                .overlay(ProgressView().isHidden(!showOverlay))
                .navigationBarTitle(data.title, displayMode: .inline)
                .navigationBarItems(trailing: Button(action : {
                    alertModel = .confirm
                    showAlert = true
                }){
                    Image(systemName : "paperplane.fill")
                }.isHidden(self.answer == "" || self.type != "Admin"))
                .animation(.easeOut)

                .alert(isPresented : $showAlert, content : {
                    switch alertModel{
                    case .confirm:
                        return Alert(title: Text("답변 등록"), message: Text("답변을 등록하시겠습니까?"), primaryButton: .default(Text("예")){
                            showOverlay = true
                            
                            helper.writeAnswer(model: data, answer: answer, userModel: userManagement.userInfo){result in
                                guard let result = result else{return}
                                
                                showOverlay = false
                                
                                if result{
                                    alertModel = .success
                                    showAlert = true
                                }
                                
                                else{
                                    alertModel = .fail
                                    showAlert = true
                                    
                                }
                            }
                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .success:
                        return Alert(title: Text("답변 등록 완료"), message: Text("답변이 등록되었습니다."), dismissButton: .default(Text("확인")))
                        
                    case .fail:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    case .none:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))

                    }
                })
        }
    }
}
