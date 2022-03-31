//
//  addNoticeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import SwiftUI

struct addNoticeView: View {
    @State private var noticeTitle = ""
    @State private var noticeContents = ""
    @State private var showPhotoPicker = false
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var url = ""
    @State private var alertModel : addNoticeAlertModel? = nil
    
    @StateObject var helper : NoticeHelper
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
                            
                            switch userManagement.userInfo?.admin{
                            case .CH_President,
                                    .CH_VicePresident,
                                    .CH_PRD_President,
                                    .CH_PRD_VicePresident,
                                    .CH_PRD_Member:
                                
                                helper.uploadNotice(images: urlList,
                                                    url: url,
                                                    imageIndex: mediaItems.items.count,
                                                    admin: "CH",
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
                                
                            case .COM_President,
                                    .COM_VicePresident,
                                    .COM_PRD_President,
                                    .COM_PRD_VicePresident:
                                helper.uploadNotice(images: urlList,
                                                    url: url,
                                                    imageIndex: mediaItems.items.count,
                                                    admin: "COM",
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
                                
                            case .SOC_President,
                                    .SOC_VicePresident,
                                    .SOC_PRD_President,
                                    .SOC_PRD_VicePresident:
                                helper.uploadNotice(images: urlList,
                                                    url: url,
                                                    imageIndex: mediaItems.items.count,
                                                    admin: "SOC",
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
                                
                            case .COH_President,
                                    .COH_VicePresident,
                                    .COH_PRD_President,
                                    .COH_PRD_VicePresident:
                                helper.uploadNotice(images: urlList,
                                                    url: url,
                                                    imageIndex: mediaItems.items.count,
                                                    admin: "COH",
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
                                
                            case .CON_President,
                                    .CON_VicePresident,
                                    .CON_PRD_President,
                                    .CON_PRD_VicePresident:
                                helper.uploadNotice(images: urlList,
                                                    url: url,
                                                    imageIndex: mediaItems.items.count,
                                                    admin: "CON",
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
                                
                            case .CHE_President,
                                    .CHE_VicePresident,
                                    .CHE_PRD_President,
                                    .CHE_PRD_VicePresident:
                                helper.uploadNotice(images: urlList,
                                                    url: url,
                                                    imageIndex: mediaItems.items.count,
                                                    admin: "CHE",
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

//struct addNoticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        addNoticeView()
//    }
//}
