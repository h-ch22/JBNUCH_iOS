//
//  GreetingLoader.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import Foundation

class GreetingLoader : ObservableObject{
    @Published var greetText : String = ""
    
    init(){
        self.load()
    }
    
    func load(){
        if let filePath = Bundle.main.path(forResource: "greet", ofType: "txt"){
            do{
                let contents = try String(contentsOfFile: filePath)
                
                DispatchQueue.main.async{
                    self.greetText = contents
                }
            } catch let error as Error{
                print(error)
            }
        }
        
        else{
            print("File not load")
        }
    }
}
