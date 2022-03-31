//
//  SportsListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import SwiftUI

struct SportsListModel: View {
    let data : SportsDataModel
    
    @State private var calendar = Calendar.current
    @State private var date : Date? = nil
    @State private var timeRemaining : String = ""
    @State private var minute : Int = 0
    @State private var seconds : Int = 0
    @State private var remain = ""
    @State private var time = ""
    
    let timer = Timer.publish(every: 1, on : .main, in: .common).autoconnect()
    
    private func calculate(){
        if data.allPeople > data.currentPeople{
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy.MM.dd. kk:mm:ss"
            
            let startDate_tmp = dateFormatter.string(from: Date())
            
            let endDate = dateFormatter.date(from: data.dateTime)
            let startDate = dateFormatter.date(from: startDate_tmp)
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            
            remain = formatter.string(from : startDate!, to : endDate!)!
            
            let remainTime = Int((endDate?.timeIntervalSince(startDate!))!) / 60
        }
    }
    
    var body: some View {
        VStack{
            HStack {
                Text(data.roomName)
                    .fontWeight(.semibold)
                    .foregroundColor(.txtColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Image(systemName: "person.2.fill")
                    .resizable()
                    .frame(width : 20, height : 14)
                    .foregroundColor(.txtColor)
                
                Text(String(data.currentPeople) + "/" + String(data.allPeople))
                    .foregroundColor(.txtColor)
            }
            
            HStack{
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width : 15, height : 15)
                    .foregroundColor(.gray)
                
                VStack {
                    if data.isOnline{
                        Text("비대면 진행")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                    }
                    
                    else{
                        HStack {
                            Text(data.locationDescription)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }.isHidden(data.locationDescription == "")
                        
                        HStack {
                            Text(data.address)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .fontWeight(.light)
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                    }

                }
                
                Spacer()
                
                Image(systemName: "clock.fill")
                    .resizable()
                    .frame(width : 15, height : 15)
                    .foregroundColor(.accent)
                
                Spacer().frame(width : 5)
                
                Text(remain)
                    .foregroundColor(.accent)
                    .font(.caption)
                    .onReceive(timer){time in
                        calculate()
                    }
            }
            
            HStack{
                Text(data.sportsType)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
        }        .padding([.vertical], 20)
            .onAppear(perform: {
                
                time = data.dateTime
            })
    }
}
