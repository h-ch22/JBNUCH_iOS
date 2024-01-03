//
//  AllianceListModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import SwiftUI

struct AllianceListModel: View {
    let data : AllianceDataModel
    let college : CollegeCodeModel?
    let userManagment = UserManagement()
    
    var body: some View {
        HStack{
            AsyncImage(url: data.storeLogo,
                       content : {phase in
                switch phase{
                case .empty:
                    ProgressView()
                    
                case .success(let image) :
                    image.resizable()
                        .aspectRatio(contentMode : .fit)
                        .frame(width : 80, height : 80)
                    
                case .failure :
                    EmptyView()
                    
                @unknown default:
                    EmptyView()
                    
                }

            })
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius : 15).stroke(Color.accent, lineWidth : 2))
                .shadow(radius: 5)
            
            Spacer().frame(width : 10)
            
            VStack{
                Spacer().frame(height : 10)

                HStack {
                    if data.allianceType == "단대"{
                        Text(userManagment.convertCollegeCodeAsShortString(collegeCode: college))
                            .font(.caption)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.orange))
                    }
                    
                    else{
                        Text(data.allianceType)
                            .padding(5)
                            .font(.caption)
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.accent))
                    }
                    
                    Spacer().frame(width : 5)

                    Text(data.storeName ?? "")
                        .font(.title2)
                        .foregroundColor(.txtColor)
                        .fontWeight(.semibold)

                    Spacer().frame(width : 5)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(data.isFavorite! ? .accent : .gray)
                    
                    Spacer()
                }
                
                Spacer().frame(height : 5)
                
                HStack {
                    Text(data.benefits ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                
                
                Group{
                    if data.openTime != "" && data.closeTime != ""{
                        Spacer().frame(height : 10)

                        HStack{
                            Image(systemName: "clock.fill")
                                .resizable()
                                .frame(width : 20, height : 20)
                                .foregroundColor(.accent)
                            
                            Text("\(data.openTime ?? "") ~ \(data.closeTime ?? "")")
                                .font(.caption)
                                .foregroundColor(.accent)
                            
                            Spacer()
                        }
                    }


                    if data.closed != ""{
                        Spacer().frame(height : 10)

                        HStack{
                            Image(systemName: "xmark.octagon.fill")
                                .resizable()
                                .frame(width : 20, height : 20)
                                .foregroundColor(.red)
                            
                            Text("휴무 : \(data.closed ?? "")")
                                .font(.caption)
                                .foregroundColor(.red)
                            
                            Spacer()
                        }
                    }
                    

                    if data.breakTime != ""{
                        Spacer().frame(height : 10)

                        HStack{
                            Image(systemName : "moon.circle.fill")
                                .resizable()
                                .frame(width : 20, height : 20)
                                .foregroundColor(.orange)
                            
                            Text("브레이크 타임 : \(data.breakTime ?? "")")
                                .font(.caption)
                                .foregroundColor(.orange)
                            
                            Spacer()

                        }
                    }
                }
                
                Spacer().frame(height : 10)
                
            }
        }
    }
}
