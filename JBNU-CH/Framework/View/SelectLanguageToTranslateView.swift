//
//  SelectLanguageToTranslateView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/06/13.
//

import SwiftUI

struct SelectLanguageToTranslateView: View {
    @State private var showAlert = true
    @State private var showList = false
    @State var data : NoticeDataModel
    @StateObject var helper : NoticeHelper
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    LazyVStack{
                        if showList{
                            ForEach(TranslationManager.shared.supportedLanguages, id : \.self){row in
                                Button(action : {
                                    TranslationManager.shared.targetLanguageCode = row.code
                                    TranslationManager.shared.textToTranslate = data.contents ?? ""
                                    
                                    TranslationManager.shared.translate(completion : {(translation) in
                                        if let translation = translation{
                                            helper.translatedText = TranslationManager.shared.translatedContents ?? ""
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else{
                                            print("error")
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                    })
                                }){
                                    SupportedLanguageModel(language: row.name, code: row.code)
                                }
                            }
                        }
                        
                    }
                }.padding(10).background(Color.background.edgesIgnoringSafeArea(.all))
                

            }
            .onAppear{
                TranslationManager.shared.fetchSupportedLanguages(completion: {(success) in
                    if success{
                        showList = true
                    }
                })
            }
            .navigationBarTitle(Text("언어 선택"))
        }
    }
}
