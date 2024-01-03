//
//  CountrySelectionView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/06/11.
//

import SwiftUI

struct CountrySelectionView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var greet = ["안녕하세요", "Hi", "你好", "おはようございます", "hân hạnh"]
    @State private var details = ["계속 진행하려면 국가를 선택해주세요.", "Please select a country to proceed.", "如果想继续，请选择国家。", "継続して進めるためには国家を選択してください。", "Nếu muốn tiếp tục tiến hành thì hãy chọn quốc gia."]
    
    @State private var countryList = ["대한민국 (Republic of Korea)", "United States", "中国 (China)", "日本 (Japan)", "Việt Nam (Vietnam)"]
    
    @State private var currentText_greet = ""
    @State private var currentText_details = ""
    @State private var index = 0
    @State private var selectedCountry = 0
    @State private var visible = false
    @State private var showOverlay = false
    @StateObject var helper : UserManagement
    
    let timer = Timer.publish(every : 3, on: .current, in : .common).autoconnect()
    
    var body: some View {
        NavigationView{
            VStack{
                Image(systemName : "globe")
                    .resizable()
                    .frame(width : 100, height : 100)
                    .foregroundColor(.accent)
                
                Spacer().frame(height : 10)
                
                Text(greet[index])
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                    .animation(.linear(duration : 0.5))
                    .onReceive(timer){ _ in
                        if index <= 3{
                            index += 1
                        }
                        
                        else{
                            index = 0
                        }
                    }
                
                Spacer().frame(height : 5)

                Text(details[index])
                    .font(.caption)
                    .foregroundColor(.txtColor)
                    .animation(.linear(duration : 0.2))
                    .onReceive(timer){ _ in
                        if index <= 3{
                            index += 1
                        }
                        
                        else{
                            index = 0
                        }
                    }
                
                Spacer().frame(height : 20)

                Picker(selection: $selectedCountry, label: Text("국가 선택")) {
                    ForEach(countryList.indices, id : \.self){
                        Text(countryList[$0]).tag($0)
                    }
                }
                
                Spacer().frame(height : 20)

                Button(action : {
                    showOverlay = true
                    helper.updateCountry(country : countryList[selectedCountry]){result in
                        guard let result = result else{return}
                        
                        showOverlay = false
                        
                        if result{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }){
                    switch(selectedCountry){
                    case 0:
                        Text("확인")
                        
                    case 1:
                        Text("OK")
                        
                    case 2:
                        Text("完毕")
                        
                    case 3:
                        Text("完了")
                        
                    case 4:
                        Text("sự hoàn thành")
                        
                    default:
                        Text("확인")
                    }
                }.isHidden(showOverlay)
            }.overlay(ProgressView().isHidden(!showOverlay))
        }
    }
}
