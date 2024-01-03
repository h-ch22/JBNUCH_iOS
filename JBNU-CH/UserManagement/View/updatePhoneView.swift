//
//  updatePhoneView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/30.
//

import SwiftUI

struct updatePhoneView: View {
    @State private var phone = ""
    @StateObject var helper : UserManagement
    @State private var showOverlay = false
    @State private var showAlert = false
    @State private var alertModel : updatePhoneAlertModel?
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image(systemName : "phone.fill")
                    
                    TextField("새 연락처", text : $phone)
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                }
                .padding(20)
                .padding([.horizontal], 20)
                .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                .padding([.horizontal],15))
                
                Button(action : {
                    showOverlay = true
                    
                    helper.changePhone(phone : phone){ result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                        
                        if result{
                            alertModel = .success
                            showAlert  = true
                        }
                        
                        else{
                            alertModel = .fail
                            showAlert = true
                        }
                    }
                }){
                    HStack {
                        Text("연락처 업데이트")
                        
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(.white)
                    .padding([.horizontal], 80)
                    .padding([.vertical], 20)
                    .background(RoundedRectangle(cornerRadius: 30).shadow(radius : 5))
                    
                }.isHidden(self.phone == "")
                
            }.padding(20)
                .navigationBarTitle("연락처 업데이트")
                .navigationBarItems(trailing: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                })
            
                .overlay(ProgressView().isHidden(!showOverlay))
            
                .alert(isPresented : $showAlert){
                    switch alertModel{
                    case .success:
                        return Alert(title: Text("업데이트 완료"), message: Text("연락처가 업데이트되었습니다."), dismissButton: .default(Text("확인")){
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        
                    case .fail:
                        return Alert(title: Text("오류"), message: Text("작업을 처리하는 중 오류가 발생했습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        
                    case .none:
                        return Alert(title: Text(""), message: Text(""), dismissButton: .default(Text("확인")))

                    }
                }
        }
    }
}
