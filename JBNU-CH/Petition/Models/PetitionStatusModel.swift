//
//  PetitionStatusModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/24.
//

import SwiftUI

struct PetitionStatusModel: View {
    let status : PetitionStatusDataModel
    
    var body: some View {
        HStack{
            VStack{
                Text("1")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().foregroundColor(self.status == .InProcess ? .accent : .gray))
                
                Text("청원 진행 중")
                    .font(.body)
                    .foregroundColor(self.status == .InProcess ? .accent : .gray)
            }
            
            Spacer()
            
            VStack{
                Text("2")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().foregroundColor(self.status == .Finish ? .accent : .gray))
                
                Text("청원 종료")
                    .font(.body)
                    .foregroundColor(self.status == .Finish ? .accent : .gray)
            }
            
            Spacer()

            VStack{
                Text("3")
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Circle().foregroundColor(self.status == .Answered ? .accent : .gray))
                
                Text("답변 완료")
                    .font(.body)
                    .foregroundColor(self.status == .Answered ? .accent : .gray)
            }
        }.padding(20)
    }
}

struct PetitionStatusModel_Previews: PreviewProvider {
    static var previews: some View {
        PetitionStatusModel(status : PetitionStatusDataModel.InProcess)
    }
}
