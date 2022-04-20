//
//  FeedbackHubView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct FeedbackHubView: View {
    let feedbackCategory : FeedbackHubCategoryModel?
    @State private var feedbackTitle = ""
    @State private var feedbackContents = ""
    @State private var feedbackType : FeedbackHubTypeModel?
    @State private var showAlert = false
    @State private var alertModel : FeedbackHubAlertModel?
    @State private var showOverlay = false
    @State private var helper = FeedbackHubHelper()
    
    @StateObject var userManagement : UserManagement
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    Image("ic_feedbackHubMain")
                        .resizable()
                        .frame(width : 250, height : 250)
                    
                    Text("학우님의 의견을 들려주세요.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.txtColor)
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Button(action: {
                            self.feedbackType = .Good
                        }){
                            VStack{
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(self.feedbackType == .Good ? Color.red : Color.gray)
                                
                                Text("칭찬해요")
                                    .fontWeight(.semibold)
                                    .foregroundColor(self.feedbackType == .Good ? Color.red : Color.gray)
                            }
                        }.frame(width : 70,
                                height : 70)
                            .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20)
                                    .stroke(self.feedbackType == .Good ? Color.red : Color.gray, lineWidth: 3))
                        
                        Button(action: {
                            self.feedbackType = .Bad
                        }){
                            VStack{
                                Image(systemName: "chevron.right.2")
                                    .resizable()
                                    .frame(width : 30, height : 30)
                                    .foregroundColor(self.feedbackType == .Bad ? Color.blue : Color.gray)
                                    .rotationEffect(Angle(degrees: -90))

                                Text("개선해주세요")
                                    .fontWeight(.semibold)
                                    .foregroundColor(self.feedbackType == .Bad ? Color.blue : Color.gray)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }.frame(width : 70,
                                height : 70)
                            .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20)
                                    .stroke(self.feedbackType == .Bad ? Color.blue : Color.gray, lineWidth: 3))
                        
                        Button(action: {
                            self.feedbackType = .Question
                        }){
                            VStack{
                                Image(systemName: "questionmark")
                                    .resizable()
                                    .frame(width : 20, height : 30)
                                    .foregroundColor(self.feedbackType == .Question ? Color.orange : Color.gray)
                                
                                Text("궁금해요")
                                    .fontWeight(.semibold)
                                    .foregroundColor(self.feedbackType == .Question ? Color.orange : Color.gray)
                            }
                        }.frame(width : 70,
                                height : 70)
                        .padding(20)
                        .background(RoundedRectangle(cornerRadius: 20)
                                    .stroke(self.feedbackType == .Question ? Color.orange : Color.gray, lineWidth: 3))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    TextField("피드백 제목", text : $feedbackTitle)
                        .foregroundColor(.txtColor)
                            .padding(20)
                            .padding([.horizontal], 20)
                            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                            .padding([.horizontal],15))
                    
                    Spacer().frame(height : 20)
                    
                    TextEditor(text : $feedbackContents)
                        .frame(height : 200)
                        .padding([.horizontal], 20)
                        .foregroundColor(.txtColor)
                        .lineSpacing(5)
                        .shadow(radius : 5)
                }
            }.background(Color.background.edgesIgnoringSafeArea(.all))
                .animation(.easeOut)

            .navigationBarTitle("피드백 허브", displayMode : .inline)
                .navigationBarItems(trailing: Button(action: {
                    alertModel = .confirm
                    showAlert = true
                }){
                    Image(systemName : "paperplane.fill")
                        .isHidden(feedbackTitle.isEmpty || feedbackContents.isEmpty || feedbackType == nil)
                })
            
                .overlay(ProgressView().isHidden(!showOverlay))
            
                .alert(isPresented: $showAlert, content: {
                    switch alertModel{
                    case .confirm :
                        return Alert(title: Text("피드백 보내기"), message : Text("피드백을 보낼까요?"), primaryButton: .default(Text("예")){
                            showOverlay = true
                            
                            helper.sendFeedback(userModel: userManagement.userInfo, feedbackType: feedbackType, feedbackCategory: feedbackCategory, feedbackTitle: feedbackTitle, feedbackContents: feedbackContents){result in
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
                        return Alert(title: Text("피드백 전송 완료"), message: Text("피드백을 성공적으로 전송하였습니다.\n보내주신 의견은 관련부서로 전달하여, 충분히 검토한 후 빠른 시일 내에 답변드릴 수 있도록 노력하겠습니다.\n감사합니다."), dismissButton: .default(Text("확인")))
                        
                    case .fail:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .none:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))

                    }
                })
        }
    }
}
