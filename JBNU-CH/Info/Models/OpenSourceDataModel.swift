//
//  OpenSourceDataModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/19.
//

import Foundation

struct OpenSourceDataModel : Hashable{
    let title : String
    let url : String
    let copyrightInfo : String
    let licenseType : String
    
    init(title : String, url : String, copyrightInfo : String, licenseType : String){
        self.title = title
        self.url = url
        self.copyrightInfo = copyrightInfo
        self.licenseType = licenseType
    }
}
