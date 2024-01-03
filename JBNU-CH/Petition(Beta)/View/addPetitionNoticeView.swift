//
//  addPetitionNoticeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/07/01.
//

import SwiftUI

struct addPetitionNoticeView: View {
    @State private var noticeTitle = ""
    @State private var noticeContents = ""
    @State private var showPhotoPicker = false
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var url = ""
    @State private var alertModel : addNoticeAlertModel? = nil
    
    @StateObject var helper : PetitionHelperBeta
    @ObservedObject var mediaItems = PickedMediaItems()
    @EnvironmentObject var userManagement : UserManagement
    @Environment(\.presentationMode) var presentationMode

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
                
                HStack{
                    Button(action : {
                        self.mediaItems.items.removeAll()
                        self.showPhotoPicker = true
                    }){
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .resizable()
                            .frame(width : 20, height : 20)
                            .foregroundColor(.accent)
                    }
                    
                    if !mediaItems.items.isEmpty{
                        ScrollView(.horizontal){
                            HStack {
                                ForEach(mediaItems.items, id : \.self){item in
                                    ZStack(alignment : .topTrailing) {
                                        Image(uiImage : item.photo!)
                                            .resizable()
                                            .frame(width : 50, height : 50)
                                            .scaledToFit()
                                        
                                        Button(action : {
                                            let index = mediaItems.items.firstIndex(where: {$0.id == item.id})
                                            
                                            if index != nil{
                                                mediaItems.items.remove(at: index!)
                                            }
                                        }){
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }

                    }
                    

                }
            }.padding(20)
                .navigationBarTitle("공지사항 추가", displayMode: .inline)
                .navigationBarItems(leading: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                }, trailing : Button("업로드"){
                    alertModel = .upload
                    showAlert = true
                })
                .sheet(isPresented : $showPhotoPicker){
                    PhotoPicker(isPresented : $showPhotoPicker, mediaItems : mediaItems){didSelectItems in
                        showPhotoPicker = false
                        
                        if didSelectItems && !mediaItems.items.isEmpty{
                            
                        }
                    }
                }
            
                .overlay(ProcessView().isHidden(!showOverlay))
            
                .alert(isPresented : $showAlert){
                    switch alertModel{
                    case .upload:
                        return Alert(title: Text("업로드"), message: Text("공지사항을 업로드할까요?"), primaryButton: .default(Text("예")){
                            showOverlay = true
                            
                            var urlList : [URL] = []
                            
                            if !mediaItems.items.isEmpty{
                                for items in mediaItems.items{
                                    urlList.append(items.url!)
                                }
                            }

                            helper.uploadNotice(images: urlList,
                                                url: url,
                                                imageIndex: mediaItems.items.count,
                                                title: noticeTitle ?? "",
                                                contents: noticeContents ?? ""){result in
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
