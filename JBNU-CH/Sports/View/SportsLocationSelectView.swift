//
//  SportsLocationSelectViewController.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import SwiftUI

struct SportsLocationSelectView: View {
    @State private var description = ""
    @ObservedObject var receiver : SportsLocationReceiver
    @StateObject var dragListener = SportsMapDragListener()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            loadMapView(receiver: receiver, dragListener : dragListener)
            
            VStack {
                Spacer()
                
                VStack{
                    Text("주소 : \(receiver.address)")
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height : 20)
                    
                    TextField("장소 설명", text:$receiver.description)

                    .padding(20)
                    .padding([.horizontal], 20)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundColor(.btnColor).shadow(radius: 5)
                                    .padding([.horizontal],15))
                    
                    Spacer().frame(height : 20)

                    Button(action : {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        HStack{
                            Text("설정 완료")
                                .foregroundColor(.white)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }.padding()
                        .padding([.horizontal], 60)
                        .background(RoundedRectangle(cornerRadius: 15).shadow(radius: 5))
                    }
                }.padding()
                .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(.background).opacity(0.8).shadow(radius: 5))
                .isHidden(dragListener.isDraging)
            }

        }
        .onAppear(perform: {
            receiver.address.removeAll()
            receiver.description.removeAll()
            receiver.location.removeAll()
        })
    }
}

struct loadMapView : UIViewControllerRepresentable{
    typealias UIViewControllerType = SportsLocationSelectViewController
    var receiver : SportsLocationReceiver
    var dragListener : SportsMapDragListener
    
    func makeUIViewController(context: Context) -> SportsLocationSelectViewController {
        let view = SportsLocationSelectViewController(receiver: receiver, dragListener: dragListener)
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: SportsLocationSelectViewController, context: Context) {

    }
}
