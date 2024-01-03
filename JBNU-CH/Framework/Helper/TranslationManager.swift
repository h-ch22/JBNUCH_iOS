//
//  TranslationManager.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/06/13.
//

import Foundation

class TranslationManager : NSObject, ObservableObject{
    static let shared = TranslationManager()
    private let API_KEY = "AIzaSyAjNhcSTpsxZMkKBahfNpzdt8lEYKhuZsw"
    
    var sourceLanguageCode : String?
    var supportedLanguages = [TranslationLanguage]()
    
    var textToTranslate : String?
    var targetLanguageCode : String?
    
    @Published var translatedContents : String?

    override init(){
        super.init()
    }
    
    func translate(completion : @escaping(_ translations : String?) -> Void){
        print("translate process started.")
        
        guard let textToTranslate = textToTranslate, let targetLanguage = targetLanguageCode else{
            completion(nil)
            
            return
        }
        
        var urlParams = [String : String]()
        urlParams["key"] = API_KEY
        urlParams["q"] = textToTranslate
        urlParams["target"] = targetLanguage
        urlParams["format"] = "text"
        
        if let sourceLanguage = sourceLanguageCode {
            urlParams["source"] = sourceLanguage
        }
        
        makeRequest(usingTranslationAPI: .translate, urlParams: urlParams){(results) in
            guard let results = results else{
                completion(nil)
                return
            }
            
            if results == nil || results.isEmpty{
                print("results : nil")
            }
            
            else{
                print(results as? [String : Any])
            }
            
            if let data = results["data"] as? [String : Any], let translations = data["translations"] as? [[String : Any]]{
                var allTranslations = [String]()
                
                for translation in translations{
                    if let translatedText = translation["translatedText"] as? String {
                        allTranslations.append(translatedText)
                    }
                }
                
                if allTranslations.count > 0{
                    self.translatedContents = allTranslations[0]
                    
                    print(self.translatedContents)
                    
                    completion(allTranslations[0])
                }
                
                else{
                    completion(nil)
                }
            }
            
            else{
                completion(nil)
            }
        }
    }
    
    func fetchSupportedLanguages(completion : @escaping(_ success : Bool) -> Void){
        var urlParams = [String : String]()
        urlParams["key"] = API_KEY
        urlParams["target"] = Locale.current.languageCode ?? "en"
        
        makeRequest(usingTranslationAPI: .supportedLanguages, urlParams: urlParams){(results) in
            guard let results = results else{
                completion(false)
                
                return
            }
            
            if let data = results["data"] as? [String: Any], let languages = data["languages"] as? [[String: Any]] {
         
                for lang in languages {
                    var languageCode: String?
                    var languageName: String?
         
                    if let code = lang["language"] as? String {
                        languageCode = code
                    }
                    if let name = lang["name"] as? String {
                        languageName = name
                    }
         
                    self.supportedLanguages.append(TranslationLanguage(code: languageCode, name: languageName))
                }
         
                completion(true)
         
            } else {
                completion(false)
            }
        }
    }
    
    func detectLanguage(forText text : String, completion : @escaping(_ language: String?) -> Void){
        let urlParams = ["key": API_KEY, "q": text]

            makeRequest(usingTranslationAPI: .detectLanguage, urlParams: urlParams) { (results) in
                guard let results = results else { completion(nil); return }

                if let data = results["data"] as? [String: Any], let detections = data["detections"] as? [[[String: Any]]] {
                    var detectedLanguages = [String]()

                    for detection in detections {
                        for currentDetection in detection {
                            if let language = currentDetection["language"] as? String {
                                detectedLanguages.append(language)
                            }
                        }
                    }

                    if detectedLanguages.count > 0 {
                        self.sourceLanguageCode = detectedLanguages[0]
                        completion(detectedLanguages[0])
                    } else {
                        completion(nil)
                    }

                } else {
                    completion(nil)
                }
            }
    }
    
    private func makeRequest(usingTranslationAPI api: TranslationModel, urlParams: [String: String], completion: @escaping (_ results: [String: Any]?) -> Void) {
        print("make Request method started.")
        if var components = URLComponents(string : api.getURL()){
            components.queryItems = [URLQueryItem]()
            
            for(key, value) in urlParams{
                components.queryItems?.append(URLQueryItem(name: key, value: value))
            }
            
            if let url = components.url{
                var request = URLRequest(url : url)
                request.httpMethod = api.getHTTPMethod()
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with : request){(results, response, error) in
                    if let error = error{
                        print("error in makeRequest : \(error)")
                        completion(nil)
                    }
                    
                    else{
                        if let response = response as? HTTPURLResponse, let results = results{
                            if response.statusCode == 200 || response.statusCode == 201{
                                do{
                                    if let resultsDict = try JSONSerialization.jsonObject(with : results, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String : Any]{
                                        print(resultsDict)
                                        completion(resultsDict)
                                    }
                                } catch{
                                    print(error.localizedDescription)
                                }
                            } else{
                                print("results is empty")
                                completion(nil)
                            }
                        }
                    }
                }
                
                task.resume()
            }
        }
    }
    
}
