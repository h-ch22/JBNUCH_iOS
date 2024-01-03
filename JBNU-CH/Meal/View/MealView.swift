//
//  MealView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

/*import SwiftUI

struct MealView: View {
    @State private var selectedTab = 0
    @State private var selectedRestaurant = 0
    @State private var weekDay = 1
    @State private var days = ["일", "월", "화", "수", "목", "금", "토"]
    @StateObject private var helper = MealHelper()
    
    var body: some View {
        ScrollView{
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Button(action : {
                            if weekDay == 1{
                                weekDay = 7
                            }
                            
                            else{
                                weekDay -= 1
                            }
                            
                            helper.parseHTML(day : days[weekDay - 1]){ result in
                                guard let result = result else{return}
                                
                                if result{
                                    
                                }
                            }
                            
                            helper.parseDorm(type : "oldDorm", day : days[weekDay - 1]){result in
                                guard let result = result else{return}
                            }
                            
                            helper.parseDorm(type : "iksan", day : days[weekDay - 1]){result in
                                guard let result = result else{return}
                            }
                            
                            helper.parseDorm(type : "chambit", day : days[weekDay - 1]){result in
                                guard let result = result else{return}
                            }
                        }){
                            Image(systemName : "chevron.left.circle.fill")
                                .foregroundColor(.accent)
                        }
                        
                        Spacer()
                        
                        Text(days[weekDay-1])
                        
                        Spacer()
                        
                        Button(action : {
                            if weekDay == 7{
                                weekDay = 1
                            }
                            
                            else{
                                weekDay += 1
                            }
                            
                            helper.parseHTML(day : days[weekDay - 1]){ result in
                                guard let result = result else{return}
                            }
                            
                            helper.parseDorm(type : "oldDorm", day : days[weekDay - 1]){result in
                                guard let result = result else{return}
                            }
                            
                            helper.parseDorm(type : "iksan", day : days[weekDay - 1]){result in
                                guard let result = result else{return}
                            }
                            
                            helper.parseDorm(type : "chambit", day : days[weekDay - 1]){result in
                                guard let result = result else{return}
                            }
                        }){
                            Image(systemName : "chevron.right.circle.fill")
                                .foregroundColor(.accent)
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    VStack{
                        HStack{
                            
                            Text("진수당")
                                .fontWeight(.semibold)
                                .foregroundColor(.txtColor)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 10)
                        
                        
                        if weekDay == 1 || weekDay == 7{
                            Text("운영 없음")
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                        
                        else{
                            Text(helper.jinsoo_lunch)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                        
                        Spacer().frame(height : 10)
                        
                        if weekDay == 1 || weekDay == 7{
                            Text("운영 없음")
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                        
                        else{
                            Text(helper.jinsoo_dinner)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                    }.padding(20)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                    
                    Spacer().frame(height : 20)
                    
                    VStack{
                        HStack{
                            Text("의대 식당")
                                .fontWeight(.semibold)
                                .foregroundColor(.txtColor)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height : 10)
                        
                        
                        if weekDay == 1 || weekDay == 7{
                            Text("운영 없음")
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                        
                        else{
                            Text(helper.medical_lunch)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                        
                        Spacer().frame(height : 10)
                        
                        if weekDay == 1 || weekDay == 7{
                            Text("운영 없음")
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                        
                        else{
                            Text(helper.medical_dinner)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }
                    }.padding(20)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                    
                    Spacer().frame(height : 20)
                    
                    Group{
                        VStack{
                            HStack{
                                Text("기존관")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.Dorm_breakfast)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.Dorm_lunch)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.Dorm_dinner)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }.padding(20)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                        
                        Spacer().frame(height : 20)

                        VStack{
                            HStack{
                                Text("참빛관")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.newDorm_breakfast)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.newDorm_lunch)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.newDorm_dinner)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }.padding(20)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                        
                        Spacer().frame(height : 20)

                        VStack{
                            HStack{
                                Text("특성화캠퍼스 생활관")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.txtColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.iksan_breakfast)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.iksan_lunch)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                            
                            Spacer().frame(height : 10)
                            
                            Text(helper.iksan_dinner)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.accent).opacity(0.5))
                        }.padding(20)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btnColor).shadow(radius: 5))
                    }
                    

                }.padding(20)
                .navigationBarTitle("이 주의 학식", displayMode : .inline)
                .onAppear{
                    let calendar = Calendar(identifier : .gregorian)
                    let comps = calendar.dateComponents([.weekday], from : Date())
                    weekDay = comps.weekday!
                    
                    helper.parseHTML(day : days[weekDay - 1]){result in
                        guard let result = result else{return}
                        
                        if result{
                            
                        }
                    }
                    
                    helper.parseDorm(type : "oldDorm", day : days[weekDay - 1]){result in
                        guard let result = result else{return}
                    }
                    
                    helper.parseDorm(type : "iksan", day : days[weekDay - 1]){result in
                        guard let result = result else{return}
                    }
                    
                    helper.parseDorm(type : "chambit", day : days[weekDay - 1]){result in
                        guard let result = result else{return}
                    }
                }
            }
        }.background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct MealView_Previews: PreviewProvider {
    static var previews: some View {
        MealView()
    }
}*/
