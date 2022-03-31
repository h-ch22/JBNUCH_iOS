//
//  SignUpTutorialView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/06.
//

import SwiftUI

struct SignUpTutorialView: View {
    @State private var current = 0
    
    var body: some View {
        NavigationView{
            VStack{
                TabView(selection : $current, content : {
                    Text("")
                })
            }
        }
    }
}

struct SignUpTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTutorialView()
    }
}
