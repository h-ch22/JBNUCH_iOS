//
//  AES256Util.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/24.
//

import Foundation
import CryptoSwift

class AES256Util{
    private static let SECRET_KEY = "JBNU_CH_54_SUN_23858291929394283"
    private static let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    private static func getAESObject() -> AES{
        let keyDecodes : Array<UInt8> = Array(SECRET_KEY.utf8)
        let IV = "JBNUCH_PR_SUN_54"
        let ivDecodes : Array<UInt8> = Array(IV.utf8)
        let aesObject = try! AES(key: keyDecodes, blockMode: CBC(iv: ivDecodes), padding: .pkcs5)
        
        return aesObject
    }
    
    static func encrypt(string : String) -> String{
        guard !string.isEmpty else{return ""}
        return try! getAESObject().encrypt(string.bytes).toBase64()
    }
    
    static func decrypt(encoded : String) -> String{
        let datas = Data(base64Encoded: encoded)
        
        guard datas != nil else {
            print("data variable is null (original data : \(encoded))")
            
            return ""
        }
                
        if encoded == ""{
            print("encoded variable is empty string")
            
            return ""
        }
 
        let bytes = datas!.bytes
        let decode = try! getAESObject().decrypt(bytes)
 
        return String(bytes: decode, encoding: .utf8) ?? ""
    }
}
