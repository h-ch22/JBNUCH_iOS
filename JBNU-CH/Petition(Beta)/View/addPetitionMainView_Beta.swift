//
//  addPetitionMainView_Beta.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/07/01.
//


import SwiftUI

struct addPetitionMainView_Beta: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Text("전대 청원제도는 학우님들이 정책과 의견을 자유롭게 제시할 수 있는 제도입니다.\n게시된 의견은 청원 수에 따라 중앙운영위원회 및 대학본부와 협의할 예정입니다.")
                        .font(.caption)
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image("ic_abuse")
                            .resizable()
                            .frame(width : 60, height : 60)
                        
                        VStack(alignment : .leading){
                            Text("욕설 및 비속어를 사용하지 마세요.")
                                .fontWeight(.semibold)
                            
                            Text("청원이 관리자에 의해 삭제될 수 있습니다.")
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 40)
                    
                    HStack{
                        Image("ic_duplicate")
                            .resizable()
                            .frame(width : 60, height : 60)
                        
                        VStack(alignment : .leading){
                            Text("중복된 청원은 1개로 합쳐질 수 있어요.")
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 40)
                    
                    HStack{
                        Image("ic_notorious")
                            .resizable()
                            .frame(width : 60, height : 60)
                        
                        VStack(alignment : .leading){
                            Text("특정 집단에 대한 혐오, 폭력적, 선정적인 표현을 사용하지 마세요.")
                                .fontWeight(.semibold)
                            
                            Text("청원이 관리자에 의해 삭제될 수 있습니다.")
                                .font(.caption)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 40)
                    
                    HStack{
                        Image(systemName : "exclamationmark.circle.fill")
                            .resizable()
                            .frame(width : 60, height : 60)
                            .foregroundColor(.orange)
                        
                        VStack(alignment : .leading){
                            Text("그 외 허위사실 유포, 정보통신망에 공개되기 부적절한 내용은 사전 통보 없이 삭제될 수 있습니다.")
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                    }
                    
                    Group {
                        Spacer().frame(height : 60)

                        NavigationLink(destination : addPetitionView_Beta()){
                            HStack {
                                Text("시작하기")
                                
                                Image(systemName: "chevron.right")
                            }
                            .foregroundColor(.white)
                            .padding([.horizontal], 120)
                            .padding([.vertical], 20)
                            .background(RoundedRectangle(cornerRadius: 30))
                        }
                    }
                }.navigationBarTitle("전대 청원제도 시작하기", displayMode: .large)
                    .padding([.horizontal], 20)
                    .navigationBarItems(leading: Button(action : {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("닫기")
                    })
            }
        }
    }
}

struct addPetitionMainView_Beta_Previews: PreviewProvider {
    static var previews: some View {
        addPetitionMainView_Beta()
    }
}

