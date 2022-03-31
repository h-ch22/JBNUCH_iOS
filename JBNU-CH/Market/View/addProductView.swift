//
//  addProductView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import SwiftUI

struct addProductView: View {
    @State private var title = ""
    @State private var contents = ""
    @State private var selectedCategory = -1
    @State private var price = ""
    @State private var quantity = 1
    
    @State private var categoryList = ["여성의류", "남성의류", "신발", "가방", "액세서리", "디지털/가전", "스포츠", "굿즈", "악기/음반", "도서/티켓/문구", "뷰티/미용", "가구/인테리어", "생활", "식품", "재능/구직/구인", "기타"]
    @State private var iconList = ["ic_clothes", "ic_clothes", "ic_shoes", "ic_bag", "ic_accessories", "ic_digital", "ic_market_sports", "ic_goods", "ic_music", "ic_books", "ic_beauty", "ic_furniture", "ic_life", "ic_food", "ic_ability", "ic_others"]
    @State private var showPhotoPicker = false
    @State private var showOverlay = false
    
    @ObservedObject var mediaItems = PickedMediaItems()

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManagment : UserManagement
    @StateObject private var helper = MarketHelper()

    var body: some View {
        NavigationView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)

                VStack{
                    Form{
                        TextField("제목", text : $title)
                            .submitLabel(.continue)
                        
                        HStack {
                            TextField("가격", text : $price)
                                .keyboardType(.numberPad)
                            .submitLabel(.continue)
                            
                            Text("원")
                        }
                        
                        TextEditor(text: $contents)
                        
                        Picker("카테고리 선택", selection : $selectedCategory){
                            ForEach(0..<categoryList.count){i in
                                HStack{
                                    Image(iconList[i])
                                        .resizable()
                                        .frame(width : 20, height : 20)
                                    
                                    Text(categoryList[i])
                                }
                            }
                        }
                        
                        Stepper(value: $quantity, in : 1...9999999999) {
                            Text("수량 : \(quantity) 개")
                        }
                        
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
                    }
                }.background(Color.background.edgesIgnoringSafeArea(.all))
                    .navigationBarTitle(Text("상품 추가하기"))
                    .navigationBarItems(leading: Button(action : {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("닫기")
                    }, trailing: Button(action : {
                        showOverlay = true
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
                        let sellerInfo = "\(userManagment.userInfo?.college), \(userManagment.userInfo?.studentNo), \(userManagment.userInfo?.name)"
                        
                        var urlList : [URL] = []
                        
                        if !mediaItems.items.isEmpty{
                            for items in mediaItems.items{
                                urlList.append(items.url!)
                            }
                        }
                        
                        helper.addProduct(model : MarketDataModel(id: "", seller: userManagment.userInfo?.uid ?? "", price: Int(price), sellerInfo: AES256Util.encrypt(string: sellerInfo), title: AES256Util.encrypt(string: title), contents: AES256Util.encrypt(string: contents), thumbnail: nil, quantity: quantity, status: nil, date: dateFormatter.string(from: Date()), category: categoryList[selectedCategory], imgCount: urlList.count), images : urlList){result in
                            guard let result = result else{return}
                            
                            if result{
                                showOverlay = false
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }){
                        Text("완료")
                    })
                
                    .overlay(ProcessView().isHidden(!showOverlay))
                
                    .sheet(isPresented : $showPhotoPicker){
                        PhotoPicker(isPresented : $showPhotoPicker, mediaItems : mediaItems){didSelectItems in
                            showPhotoPicker = false
                            
                            if didSelectItems && !mediaItems.items.isEmpty{
                                
                            }
                        }
                    }
            }
        }
    }
}
