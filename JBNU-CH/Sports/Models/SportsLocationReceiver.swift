//
//  SportsLocationReceiver.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import Foundation

class SportsLocationReceiver : ObservableObject{
    @Published var location = ""
    @Published var description = ""
    @Published var address = ""
}
