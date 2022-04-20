//
//  PledgeView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct PledgeView: View {
    @StateObject private var helper = PledgeHelper()
    @State private var PrepareCount = 0.0
    @State private var InProgressCount = 0.0
    @State private var CompleteCount = 0.0
    @State private var pledgeCount = 80.0
    @State private var selectedTab = 0

    @State private var selectedIndex = 0
    @State private var indexes = ["전체", "취·창업 및 학사", "문화 및 예술", "복지", "생활관", "시설 및 안전", "앱 (App.)", "인권"]
    @State private var searchText = ""
    
    let college : String

    private var filtertedList : [PledgeDataModel]{
        if searchText.isEmpty{
            return helper.pledges
        }
        
        else{
            return helper.pledges.filter{$0.pledgeName.localizedCaseInsensitiveContains(searchText) as! Bool}
        }
    }
    
    private func calculate(index : Int){
        PrepareCount = 0.0
        InProgressCount = 0.0
        CompleteCount = 0.0
        
        if index == 0{
            for data in helper.pledges{
                switch data.pledgeStatus{
                case .Preparing:
                    PrepareCount += 1.0
                    
                case .InProgress:
                    InProgressCount += 1.0
                    
                case .Complete:
                    CompleteCount += 1.0
                }
            }
            
            pledgeCount = 80
        }
        
        else{
            var categoryCount = 0.0
            
            for data in helper.pledges{
                if data.pledgeCategory == indexes[index]{
                    switch data.pledgeStatus{
                    case .Preparing:
                        PrepareCount += 1.0
                        
                    case .InProgress:
                        InProgressCount += 1.0
                        
                    case .Complete:
                        CompleteCount += 1.0
                    }
                    
                    categoryCount += 1.0
                }
            }
            
            pledgeCount = categoryCount
        }
        
        
    }
    
    var body: some View {
        VStack{
            HStack{
                Text("\(indexes[selectedIndex]) 공약 이행률")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Spacer()
                
                NavigationLink(destination : PDFViewer(url : Bundle.main.url(forResource : "PledgeBook", withExtension : "pdf")!).navigationBarTitle("정책 자료집", displayMode : .inline)){
                    HStack{
                        Image(systemName: "book.circle.fill")
                            .foregroundColor(.accent)
                        
                        Text("정책 자료집 바로가기")
                            .foregroundColor(.accent)
                    }
                }.isHidden(self.college != "CH")
            }
            
            HStack{
                Text("\((CompleteCount / pledgeCount) * 100.0, specifier : "%.2f") %")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                
                Spacer()
                
                VStack{
                    HStack{
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 5).foregroundColor(.red).frame(width : 10, height : 10)
                        
                        Text("준비 중 : \(PrepareCount, specifier : "%.0f")")
                            .font(.caption)
                    }
                    
                    Spacer().frame(height : 5)
                    
                    HStack{
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 5).foregroundColor(.orange).frame(width : 10, height : 10)
                        
                        Text("진행 중 : \(InProgressCount, specifier : "%.0f")")
                            .font(.caption)
                        
                    }
                    
                    Spacer().frame(height : 5)
                    
                    HStack{
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 5).foregroundColor(.green).frame(width : 10, height : 10)
                        
                        Text("완료 : \(CompleteCount, specifier : "%.0f")")
                            .font(.caption)
                        
                    }
                }
            }
            
            ScrollView(.horizontal){
                HStack{
                    ForEach(indexes.indices, id : \.self){item in
                        Button(action: {
                            selectedIndex = item
                            
                            calculate(index : item)
                        }){
                            Text(indexes[item])
                                .padding(10)
                                .foregroundColor(selectedIndex == item ? .white : .accent)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(selectedIndex == item ? .accent : .white))
                        }
                    }
                }
            }
            
            List{
                ForEach(filtertedList, id : \.self){index in
                    if selectedIndex != 0{
                        if index.pledgeCategory == indexes[selectedIndex]{
                            PledgeListModel(data: index)
                            
                        }
                    }
                    
                    else{
                        PledgeListModel(data: index)
                        
                    }
                    
                    
                }
                
            }.listStyle(InsetListStyle())
                .refreshable{
                    helper.getAllPledges(college: self.college){result in
                        guard let result = result else{return}
                        
                        if result{
                            calculate(index : selectedIndex)
                        }
                    }
                }
                .searchable(text : $searchText, prompt : "공약 검색")
            
            
        }.animation(.easeIn)
            .padding([.horizontal], 20)
            .onAppear{
                let apparence = UITabBarAppearance()
                apparence.configureWithOpaqueBackground()
                if #available(iOS 15.0, *) {UITabBar.appearance().scrollEdgeAppearance = apparence}
                
                switch self.college{
                case "CH":
                    self.pledgeCount = 80.0
                    self.indexes = ["전체", "취·창업 및 학사", "문화 및 예술", "복지", "생활관", "시설 및 안전", "앱 (App.)", "인권"]

                case "CON":
                    self.pledgeCount = 30.0
                    self.indexes = ["전체", "취업 및 학습", "문화 및 예술", "복지", "소통", "승계 공약"]
                    
                case "SOC":
                    self.pledgeCount = 30.0
                    self.indexes = ["전체", "취업 및 학습", "문화 및 예술", "복지", "소통", "시설"]

                default:
                    self.pledgeCount = 80.0
                    self.indexes = ["전체", "취·창업 및 학사", "문화 및 예술", "복지", "생활관", "시설 및 안전", "앱 (App.)", "인권"]
                }
                
                helper.getAllPledges(college: self.college){result in
                    guard let result = result else{return}
                    
                    if result{
                        calculate(index : 0)
                    }
                }
            }
            .navigationTitle("실시간 공약 이행률")
            .navigationBarTitleDisplayMode(.inline)
    }
}
