//
//  NoticeDetailView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/11.
//

import SwiftUI
import SwiftUIPager
import SDWebImageSwiftUI

struct NoticeDetailView: View {
    @State var data : NoticeDataModel
    let userInfo : UserInfoModel?
    
    @StateObject var helper : NoticeHelper
    @StateObject var userManagement : UserManagement
    @State private var contents : String = ""
    @State private var showSelectLanguage = false
    @State private var showAlert = false
    @State private var alertModel : NoticeRemoveAlertModel? = nil
    @State private var showOverlay = false
    @State private var page : Page = .first()
    @State private var showSheet = false
    @State private var showEditWindow = false
    @State private var selectedImg : URL? = nil
    @State private var redrawPreview = false
    @State private var downloadState = false
    @State private var useTranslate = false
    @State private var url : [String] = []
    
    var body: some View {
        ScrollView{
            VStack{
                if data.imageIndex! > 0 && downloadState && !helper.urlList.isEmpty{
                        Pager(page : self.page,
                              data : helper.urlList.indices,
                              id : \.self,
                              content : {index in

                            WebImage(url : helper.urlList[index].url!)
                                .onSuccess{image, data, cacheType in
                                    print("notice Image loaded successfully.")
                                }
                                .placeholder{
                                    ProcessView()
                                }
                                .onFailure(perform: {error in
                                    print("notice Image Error : " + error.localizedDescription)
                                })
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width : 300, height : 300)
                                .onTapGesture {
                                    self.selectedImg = helper.urlList[index].url!

                                    if selectedImg != nil{
                                        showSheet = true
                                    }
                                }
                                .onAppear{
                                    print("notice Image loading...")
                                }

                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius : 15).stroke(Color.accent, lineWidth : 2))
                            .shadow(radius: 5)
                        }).interactive(scale : 0.8)
                            .interactive(opacity: 0.5)
                            .itemSpacing(10)
                            .pagingPriority(.simultaneous)
                            .itemAspectRatio(1.3, alignment: .start)
                            .padding(20)
                            .sensitivity(.high)
                            .preferredItemSize(CGSize(width : 300, height : 300))
                            .onPageWillChange({(newIndex) in
                                let generator = UIImpactFeedbackGenerator(style: .soft)
                                generator.impactOccurred()
                            })

                            .frame(height : 300)
                            .onAppear{
                                print("Pager loading...")
                            }
                    
                
                    
                }
                
                else if data.imageIndex! > 0 && (!downloadState || helper.urlList.isEmpty){
                    VStack{
                        ProgressView()
                    }
                }
                
                Spacer().frame(height : 20)
                
                HStack{
                    if useTranslate{
                        if helper.translatedText == nil{
                            ProgressView()
                        }
                        
                        else{
                            Text(helper.translatedText ?? data.contents!)
                                .lineLimit(nil)
                                .font(.body)
                                .foregroundColor(.txtColor)
                            
                            Spacer()
                        }
                    }
                    
                    else{
                        Text(data.contents!)
                            .lineLimit(nil)
                            .font(.body)
                            .foregroundColor(.txtColor)
                        
                        Spacer()
                    }
                }
                
                if !url.isEmpty{
                    ForEach(url, id : \.self){item in
                        Spacer().frame(height : 10)
                        
                        LinkRow(previewURL : item, redraw : self.$redrawPreview)
                    }
                }
                
                
            }.padding([.horizontal], 20)
            
            
        }.background(Color.background.edgesIgnoringSafeArea(.all)).navigationTitle(data.title!)
            .sheet(isPresented : $showSheet){
                FullScreenImageView(image: selectedImg?.absoluteString ?? "").onAppear{
                    print("\(helper.urlList), \(downloadState), \(data.imageIndex!)")
                }
            }
        
            .sheet(isPresented : $showEditWindow){
                editNoticeView(helper : helper, userManagement: userManagement, data : data)
            }
        
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action : {
                        showEditWindow = true
                    }){
                        Image(systemName: "pencil")
                    }.isHidden(userManagement.userInfo?.admin == nil)
                    
                    Button(action : {
                        alertModel = .confirm
                        showAlert = true
                    }){
                        Image(systemName: "xmark").foregroundColor(.red)
                    }.isHidden(userManagement.userInfo?.admin == nil)
                    
                    Button(action : {
                        TranslationManager.shared.detectLanguage(forText : data.contents ?? ""){(language) in
                            if let language = language{
                                self.showSelectLanguage = true
                            }
                            
                            else{
                                
                            }
                        }
                    }){
                        Image(systemName : "t.bubble.fill")
                    }
                }
            }
        
            .alert(isPresented : $showAlert){
                switch alertModel{
                case .confirm :
                    return Alert(title: Text("공지사항 제거"), message: Text("공지사항을 제거하시겠습니까?"), primaryButton: .default(Text("예")){
                        showOverlay = true
                        
                        helper.removeNotice(id : data.id ?? "", type : data.type){result in
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
                    return Alert(title : Text("제거 완료"), message: Text("공지사항이 제거되었습니다."), dismissButton: .default(Text("확인")))
                    
                case .fail:
                    return Alert(title : Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    
                case .none:
                    return Alert(title : Text(""), message: Text(""), dismissButton: .default(Text("확인")))
                    
                }
            }
            .fullScreenCover(isPresented : $showSelectLanguage, content : {
                SelectLanguageToTranslateView(data : self.data, helper : self.helper).onAppear{
                    self.useTranslate = true
                }
            })
            .overlay(ProcessView().isHidden(!showOverlay))
            .animation(.easeOut)
            .onAppear{
                self.contents = data.contents ?? ""
                if data.imageIndex ?? 0 > 0{
                    helper.downloadImage(userInfo: userInfo, id: data.id!, type: data.type, imageIndex: data.imageIndex ?? 0){result in
                        guard let result = result else{return}
                        
                        self.downloadState = result
                        
                        if !result{
                            print("download Notice Image Error")
                        }
                    }
                }
                
                else{
                    self.downloadState = true
                }
                
                let detector = try! NSDataDetector(types : NSTextCheckingResult.CheckingType.link.rawValue)
                
                let matches = detector.matches(in: data.contents!, options: [], range: NSRange(location: 0, length: data.contents!.utf16.count))
                
                for match in matches {
                    guard let range = Range(match.range, in: data.contents!) else { continue }
                    let url = data.contents![range]
                    self.url.append(String(url))
                }
                
                redrawPreview = true
            }
    }
}
