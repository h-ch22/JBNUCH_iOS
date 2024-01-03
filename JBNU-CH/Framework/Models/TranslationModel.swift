//
//  TranslationModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/06/13.
//

import Foundation

enum TranslationModel{
    case detectLanguage, translate, supportedLanguages
    
    func getHTTPMethod() -> String{
        if self == .supportedLanguages{
            return "GET"
        } else{
            return "POST"
        }
    }
    
    func getURL() -> String{
        var urlString = ""
        
        switch self{
        case .detectLanguage:
            urlString = "https://translation.googleapis.com/language/translate/v2/detect"

        case .translate:
            urlString = "https://translation.googleapis.com/language/translate/v2"

        case .supportedLanguages:
            urlString = "https://translation.googleapis.com/language/translate/v2/languages"
        }
        
        return urlString
    }
}
