//
//  addHandWritingView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import SwiftUI

struct addHandWritingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var examName = ""
    @State private var selectedDate = Date.now
    @State private var meter = ""
    @State private var term = ""
    @State private var review = ""
    @State private var howTO = ""
    @State private var title = ""
    @State private var showAlert = false
    @State private var showOverlay = false
    @State private var showPicker = false
    @State private var alertModel : addHandWritingAlertModel?
    
    @StateObject private var helper = HandWritingHelper()
    @ObservedObject var mediaItems = PickedMediaItems()
    @EnvironmentObject var userManagement : UserManagement

    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        Group{
                            HStack{
                                Text("📝 게시글 제목")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            TextField("게시글 제목", text : $title)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(.btnColor)
                                        .shadow(radius: 5)
                                        .padding([.horizontal],15)
                                )
                            
                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text("✏️ 시험 이름")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            TextField("시험 이름", text : $examName)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(.btnColor)
                                        .shadow(radius: 5)
                                        .padding([.horizontal],15)
                                )
                            
                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)

                        }
                        
                        Group{
                            HStack{
                                Text("🗓 시험 날짜")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            DatePicker("날짜 선택", selection : $selectedDate, in : ...Date.now, displayedComponents: .date)

                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                        }
                        
                        Group{
                            HStack{
                                Text("💭 시험을 준비하게 된 계기")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            TextEditor(text : $meter)
                                .background(Color.btnColor)
                                .padding().lineSpacing(5).frame(height : 150)
                                .shadow(radius : 5)

                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text("⏰ 시험 준비 기간")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            TextField("준비 기간", text : $term)
                                .padding(20)
                                .padding([.horizontal], 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundColor(.btnColor)
                                        .shadow(radius: 5)
                                        .padding([.horizontal],15)
                                )
                            
                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                            

                            

                        }
                        
                        Group{
                            HStack{
                                Text("🙋🏻‍♀️ 시험을 본 후기")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            TextEditor(text : $review)
                                .background(Color.btnColor)
                                .padding().lineSpacing(5).frame(height : 150)
                                .shadow(radius : 5)

                            
                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text("📚 자신만의 공부법")
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            
                            TextEditor(text : $howTO)
                                .background(Color.btnColor)
                                .padding().lineSpacing(5).frame(height : 150)
                                .shadow(radius : 5)

                            Spacer().frame(height : 20)
                            
                            Divider()
                            
                            Spacer().frame(height : 20)
                        }
                        
                        HStack{
                            Button(action : {
                                self.mediaItems.items.removeAll()
                                self.showPicker = true
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
                }.background(Color.background.edgesIgnoringSafeArea(.all))
                    .overlay(ProgressView().isHidden(!showOverlay))
                    .sheet(isPresented : $showPicker){
                        PhotoPicker(isPresented : $showPicker, mediaItems : mediaItems){didSelectItems in
                            showPicker = false
                            
                            if didSelectItems && !mediaItems.items.isEmpty{
                                
                            }
                        }
                    }
                
                    .alert(isPresented : $showAlert){
                        switch alertModel{
                        case .emptyField:
                            return Alert(title: Text("공백 필드"), message: Text("모든 필드를 채워주세요."), dismissButton: .default(Text("확인")))
                            
                        case .fail:
                            return Alert(title: Text("오류"), message: Text("요청을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                            
                        case .success:
                            return Alert(title: Text("업로드 완료"), message: Text("합격자 수기가 업로드되었습니다."), dismissButton: .default(Text("확인")){
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                        case .none:
                            return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))
                        }
                    }
                    .navigationBarTitle("수기 작성하기", displayMode : .inline)
                        .navigationBarItems(leading: Button("닫기"){
                            self.presentationMode.wrappedValue.dismiss()
                        }, trailing : Button(action : {
                            if self.title == "" || meter == "" || examName == "" || review == "" || howTO == ""{
                                self.alertModel = .emptyField
                                showAlert = true
                            }
                            
                            else{
                                showOverlay = true
                                
                                var urlList : [URL] = []
                                
                                if !mediaItems.items.isEmpty{
                                    for items in mediaItems.items{
                                        urlList.append(items.url!)
                                    }
                                }
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
                                
                                helper.uploadHandWriting(data: HandWritingDataModel(date: dateFormatter.string(from: Date()),
                                                                                    examName: examName,
                                                                                    howTO: howTO,
                                                                                    meter: meter,
                                                                                    review: review,
                                                                                    term: term,
                                                                                    examDate: dateFormatter.string(from: selectedDate),
                                                                                    college: userManagement.userInfo?.college ?? "",
                                                                                    studentNo: userManagement.userInfo?.studentNo ?? "",
                                                                                    name: userManagement.userInfo?.name ?? "",
                                                                                    uid: userManagement.userInfo?.uid ?? "",
                                                                                    id: "",
                                                                                    imageIndex: self.mediaItems.items.count,
                                                                                    title: title,
                                                                                    recommend : 0), images: urlList){result in
                                    guard let result = result else{return}
                                    
                                    showOverlay = false
                                    
                                    if !result{
                                        alertModel = .fail
                                        showAlert = true
                                    }
                                    
                                    else{
                                        alertModel = .success
                                        showAlert = true
                                    }
                                }
                            }
                        }){
                            Image(systemName : "paperplane.fill")
                        })
            }
        }
    }
}
