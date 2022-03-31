//
//  GreetingView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/11.
//

import SwiftUI

struct GreetingView: View {
    @ObservedObject var loader = GreetingLoader()
    
    var body: some View {
        ScrollView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image("background_greet")
                        .resizable()
                        .frame(width: 300, height : 200)
                    
                    Text(loader.greetText)
                }.navigationBarTitle("인사말", displayMode: .inline)
            }
        }.background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

struct GreetingView_Previews: PreviewProvider {
    static var previews: some View {
        GreetingView()
    }
}
