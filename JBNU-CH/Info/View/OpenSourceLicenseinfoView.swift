//
//  OpenSourceLicenseinfoView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/04/19.
//

import SwiftUI

struct OpenSourceLicenseinfoView: View {
    let dataList : [OpenSourceDataModel] = [
        OpenSourceDataModel(title: "Apple Swift", url: "https://github.com/apple/swift", copyrightInfo: "Copyright 2014-2022 Apple Inc. and the Swift project authors", licenseType: "Apache-2.0 License"),
        OpenSourceDataModel(title: "Apple Frameworks", url: "https://developer.apple.com/documentation", copyrightInfo: "Copyright 2022 Apple Inc.", licenseType: "Apple MIT License"),
        OpenSourceDataModel(title: "Google Firebase for iOS", url: "https://firebase.google.com/docs/ios/setup", copyrightInfo: "Copyright 2022 Google, Inc", licenseType: "Apache-2.0 License"),
        OpenSourceDataModel(title: "CryptoSwift", url: "https://github.com/krzyzanowskim/CryptoSwift", copyrightInfo: "Copyright 2014-2021 Marcin Krzyżanowski ", licenseType: "zlip License"),
        OpenSourceDataModel(title: "SDWebImageSwiftUI", url: "https://github.com/SDWebImage/SDWebImageSwiftUI", copyrightInfo: "Copyright 2019 lizhuoli1126@126.com", licenseType: "MIT License"),
        OpenSourceDataModel(title: "Naver Map iOS SDK", url: "https://navermaps.github.io/ios-map-sdk/reference/Classes/NMFMapView.html#/c%3Aobjc%28cs%29NMFMapView%28im%29showOpenSourceLicense", copyrightInfo: "Copyright 2018-2021 NAVER Corp.", licenseType: ""),
        OpenSourceDataModel(title: "Alamofire", url: "https://github.com/Alamofire/Alamofire", copyrightInfo: "Copyright 2014-2022 Alamofire Software Foundation", licenseType: "MIT License"),
        OpenSourceDataModel(title: "SwiftyJSON", url: "https://github.com/SwiftyJSON/SwiftyJSON", copyrightInfo: "Copyright 2017 Ruoyu Fu", licenseType: "MIT License"),
        OpenSourceDataModel(title: "SwiftSoup", url: "https://github.com/scinfu/SwiftSoup", copyrightInfo: "Copyright 2016 Nabil Chatbi", licenseType: "MIT License"),
        OpenSourceDataModel(title: "SwiftUIPager", url: "https://github.com/fermoya/SwiftUIPager", copyrightInfo: "Copyright 2019 fermoya", licenseType: "MIT License")
    ]
    
    var body: some View {
        List{
            ForEach(dataList, id : \.self){index in
                OpenSourceListModel(data : index)
            }
        }.navigationBarTitle("오픈소스 라이센스 정보", displayMode: .inline)
    }
}

struct OpenSourceLicenseinfoView_Previews: PreviewProvider {
    static var previews: some View {
        OpenSourceLicenseinfoView()
    }
}
