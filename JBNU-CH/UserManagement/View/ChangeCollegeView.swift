//
//  ChangeCollegeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/20.
//

import SwiftUI

struct ChangeCollegeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userManagement : UserManagement
    @State private var collegeList = ["간호대학", "공과대학", "글로벌융합대학", "농업생명과학대학", "사범대학", "사회과학대학", "상과대학", "생활과학대학", "수의과대학", "스마트팜학과", "약학대학", "예술대학", "의과대학", "인문대학", "자연과학대학", "치과대학", "환경생명자원대학"]
    @State private var selectedCollege = 0
    @State private var showAlert = false
    @State private var showOverlay = false

    var body: some View {
        NavigationView{
            VStack{
                Text("Please Select a college to change your info.")
                
                Picker(selection : $selectedCollege, label : Text("소속 단과대학 선택")){
                    ForEach(0..<collegeList.count){
                        Text(collegeList[$0])
                    }
                }.pickerStyle(WheelPickerStyle())
            }.navigationBarItems(leading: Button("Close"){
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button(action : {
                showAlert = true
            }){
                Text("Apply")
            })
            .alert(isPresented : $showAlert, content: {
                Alert(title: Text("Apply Changes"), message: Text("Your college will be changed to \(collegeList[selectedCollege])"), primaryButton: .default(Text("Yes")){
                    showOverlay = true
                    
                    userManagement.changeCollege(college : collegeList[selectedCollege]){ result in
                        guard let result = result else{return}
                        
                        if result{
                            userManagement.getUserInfo(){result in
                                guard let result = result else{return}
                                
                                if result == .success{
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                }, secondaryButton: .destructive(Text("No")))
            })
            .overlay(ProgressView().isHidden(!showOverlay))

        }
    }
}

struct ChangeCollegeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCollegeView()
    }
}
