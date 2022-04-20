//
//  addPetitionView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI

struct addPetitionView: View {
    @FocusState private var activeField : WritePetitionFocusField?
    @Environment(\.presentationMode) var presentationMode

    @State private var title = ""
    @State private var contents = ""
    @State private var showOverlay = false
    @State private var helper = PetitionHelper()
    @State private var showAlert = false
    @State private var showPicker = false
    @State private var alertModel : addPetitionAlertModel?
    @State private var selectedCategory = 1
    @ObservedObject var mediaItems = PickedMediaItems()
    
    var body: some View {
        VStack{
            HStack{
                Text("카테고리 선택")
                    .foregroundColor(.txtColor)
                
                Spacer()
                
                Picker("카테고리 선택", selection: $selectedCategory){
                    ForEach(1..<6){index in
                        switch index{
                        case 1:
                            Text("학사").tag(index)
                            
                        case 2:
                            Text("시설").tag(index)
                            
                        case 3:
                            Text("복지").tag(index)
                            
                        case 4:
                            Text("문화 및 예술").tag(index)
                            
                        case 5:
                            Text("기타").tag(index)
                            
                        default:
                            Text("학사").tag(index)
                        }
                    }
                }
            }.padding(20)
            
            HStack{
                TextField("청원 제목", text : $title)
                    .focused($activeField, equals : .field_title)
                    .submitLabel(.continue)
            }.foregroundColor(activeField == .field_title ? .accent : .txtColor)
                .padding(20)
                .padding([.horizontal], 20)
                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                .padding([.horizontal],15))
            
            Spacer().frame(height : 20)
            
            TextEditor(text : $contents)
                .foregroundColor(.txtColor)
                .lineSpacing(5)
                .shadow(radius : 5)

            Spacer().frame(height : 20)

            
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
        }.padding([.horizontal], 20)
            .navigationTitle("청원 작성하기")
            .navigationBarItems(trailing: Button(action: {
                if title == "" || contents == ""{
                    alertModel = .emptyField
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
                    
                    helper.uploadPetition(title : title, contents : contents, images : urlList, category : selectedCategory){result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                        
                        if result{
                            alertModel = .success
                        }
                        
                        else{
                            alertModel = .failed
                        }
                        
                        showAlert = true
                    }
                }

            }){
                Text("완료")
            })
            .overlay(ProcessView().isHidden(!showOverlay))
        
            .sheet(isPresented : $showPicker){
                PhotoPicker(isPresented : $showPicker, mediaItems : mediaItems){didSelectItems in
                    showPicker = false
                    
                    if didSelectItems && !mediaItems.items.isEmpty{
                        
                    }
                }
            }
        
            .alert(isPresented : $showAlert){
                switch alertModel{
                case .success:
                    return Alert(title: Text("청원 업로드 완료"),
                                 message: Text("청원이 업로드 되었습니다."),
                                 dismissButton: .default(Text("확인")){
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    
                case .failed:
                    return Alert(title: Text("청원 업로드 실패"),
                                 message: Text("청원 업로드 중 문제가 발생했습니다.\n나중에 다시 시도하십시오."),
                                 dismissButton: .default(Text("확인")))
                    
                case .emptyField:
                    return Alert(title: Text("공백 필드"),
                                 message: Text("모든 필드를 채워주세요."),
                                 dismissButton: .default(Text("확인")))
                    
                case .none:
                    return Alert(title: Text(""),
                                 message: Text(""),
                                 dismissButton: .default(Text("")))
                }
            }
    }
}

struct addPetitionView_Previews: PreviewProvider {
    static var previews: some View {
        addPetitionView()
    }
}
