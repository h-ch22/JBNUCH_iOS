//
//  QRView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import SwiftUI

struct QRView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var model = QRScannerViewModel()
    @State private var showAlert = false
    @ObservedObject private var helper = QRHelper()
    @State private var showCover = false
    @State private var alertModel : QRCodeCallbackModel? = nil
    
    var body: some View {
        NavigationView{
            ZStack{
                QRCameraView()
                    .found(r : self.model.onFoundQRCode)
                    .torchLight(isOn: self.model.flashON)
                    .interval(delay: self.model.scanInterval)
                
                VStack{
                    VStack{
                        Text("쿠폰의 QR코드를 인식시켜주세요!")
                            .fontWeight(.semibold)
                        
                        Text(self.model.lastQRCode)
                            .bold()
                            .lineLimit(5)
                            .padding()
                            .onChange(of : model.lastQRCode){newValue in
                                helper.findQRCode(stringValue : newValue){result in
                                    guard let result = result else{return}
                                    
                                    switch result{
                                    case .ALREADY_EXISTS:
                                        self.alertModel = .ALREADY_EXISTS
                                        showAlert = true
                                        break
                                        
                                    case .UNKNOWN:
                                        self.alertModel = .UNKNOWN
                                        showAlert = true
                                        break
                                        
                                    case .EXPIRED:
                                        self.alertModel = .EXPIRED
                                        showAlert = true
                                        break
                                        
                                    case .ERROR:
                                        self.alertModel = .ERROR
                                        showAlert = true
                                        break
                                        
                                    case .SUCCESS:
                                        self.showCover = true
                                        break
                                    }
                                }
                            }
                        
                    }.padding(20)
                    
                    Spacer()
                    
                    Button(action: {
                        self.model.flashON.toggle()
                    }){
                        Image(systemName : self.model.flashON ? "bolt.fill" : "bolt.slash.fill")
                            .imageScale(.large)
                            .foregroundColor(self.model.flashON ? Color.yellow : Color.blue)
                            .padding()
                    }.background(Color.btnColor)
                        .cornerRadius(10)
                }
            }.navigationBarTitle(Text("쿠폰 QR 코드 스캔"), displayMode: .inline)
                .navigationBarItems(leading: Button("닫기"){
                    self.presentationMode.wrappedValue.dismiss()
                })
        }.alert(isPresented: $showAlert, content: {
            switch alertModel{
            case .UNKNOWN:
                return Alert(title: Text("유효하지 않는 코드"), message: Text("유효하지 않는 쿠폰 번호입니다."), dismissButton: .default(Text("확인")))
                
            case .ALREADY_EXISTS:
                return Alert(title: Text("이미 사용한 코드"), message: Text("이미 사용한 쿠폰 번호입니다."), dismissButton: .default(Text("확인")))
                
            case .SUCCESS:
                return Alert(title: Text("등록 완료"), message: Text("쿠폰을 등록하였습니다."), dismissButton: .default(Text("확인")))
                
            case .EXPIRED:
                return Alert(title: Text("만료된 코드"), message: Text("기한이 만료된 쿠폰 번호입니다."), dismissButton: .default(Text("확인")))
                
            case .ERROR:
                return Alert(title: Text("오류"), message: Text("쿠폰 등록 중 오류가 발생했습니다.\n네트워크 상태를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                
            case .none:
                return Alert(title: Text("알 수 없음"), message: Text("알 수 없는 매개변수입니다."), dismissButton: .default(Text("확인")))
            }
            })
            .fullScreenCover(isPresented: $showCover, content: {
                QRResultView(result: helper.findResult!)
            })
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
