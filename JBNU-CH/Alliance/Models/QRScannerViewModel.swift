//
//  QRScannerViewModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/22.
//

import Foundation

class QRScannerViewModel : ObservableObject{
    let scanInterval : Double = 1.0
    @Published var flashON = false
    @Published var lastQRCode = ""
    
    func onFoundQRCode(_ code : String){
        self.lastQRCode = code
    }
}
