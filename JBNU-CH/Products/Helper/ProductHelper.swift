//
//  ProductHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import Foundation
import Firebase

class ProductHelper : ObservableObject{
    @Published var isAvailable = true
    @Published var productList : [ProductDataModel] = []
    @Published var productLogList : [ProductLogDataModel] = []
    
    private let db = Firestore.firestore()
    
    func calcTime(){
        let hour = Calendar.current.component(.hour, from : Date())
        let dayOfWeek = Date().dayNumberOfWeek()!
        
        if dayOfWeek >= 2 && dayOfWeek <= 6{
            if hour >= 9 && hour < 18{
                if hour == 13{
                    isAvailable = false
                }
                
                else{
                    isAvailable = true
                }
            }
            
            else{
                isAvailable = false
            }
        }
        
        else{
            isAvailable = false
        }
    }
    
    func getLog(type : String, userInfo : UserInfoModel?, completion : @escaping(_ result : Bool?) -> Void){
        productLogList.removeAll()
        let userManagement = UserManagement()
        
        switch type{
        case "CH":
            db.collection("Products").document("CH").collection("Log").addSnapshotListener{querySnapshot, error in
                guard let documents = querySnapshot?.documents else{return}
                
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                for document in documents{
                    if userInfo?.studentNo == AES256Util.decrypt(encoded: document.get("studentNo") as? String ?? ""){
                        let dateTime = document.get("dateTime") as? String ?? ""
                        let number = document.get("number") as? Int ?? 0
                        let product = document.get("product") as? String ?? ""
                        let isReturned = document.get("isReturned") as? Bool ?? false
                        
                        var iconName = ""
                        
                        switch product{
                        case "고데기":
                            iconName = "ic_curlingiron"
                            
                        case "농구공":
                            iconName = "ic_basketball"

                        case "부심기":
                            iconName = "ic_flag"

                        case "족구공":
                            iconName = "ic_football"

                        case "풋살공":
                            iconName = "ic_football"

                        case "돗자리":
                            iconName = "ic_mat"

                        case "족구네트":
                            iconName = "ic_net"

                        case "축구공":
                            iconName = "ic_soccerball"

                        case "조끼 (파랑)":
                            iconName = "ic_uniform_b"

                        case "조끼 (초록)":
                            iconName = "ic_uniform_g"

                        case "조끼 (핑크)":
                            iconName = "ic_unifrom_p"

                        default:
                            iconName = ""
                        }
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
                        let dayAsDate = formatter.date(from: dateTime)
                        let dayLimit = Calendar.current.date(byAdding: .day, value : 3, to: dayAsDate!)
                        let id = document.documentID
                        
                        if !self.productLogList.contains(where: {$0.id == id}){
                            self.productLogList.append(ProductLogDataModel(id: id, productName: product, icName: iconName, isReturned: isReturned, dateTime: dateTime, number: String(number), dayLimit: formatter.string(from: dayLimit!)))
                        }
                        
                    }
                }
                
                completion(true)
            }
            
        case "College":
            db.collection("Products").document(userManagement.convertCollegeCodeAsString(collegeCode: userInfo?.collegeCode)).collection("Log").addSnapshotListener{querySnapshot, error in
                guard let documents = querySnapshot?.documents else{return}
                
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                for document in documents{
                    if userInfo?.studentNo == AES256Util.decrypt(encoded: document.get("studentNo") as? String ?? ""){
                        let dateTime = document.get("dateTime") as? String ?? ""
                        let number = document.get("number") as? Int ?? 0
                        let product = document.get("product") as? String ?? ""
                        let isReturned = document.get("isReturned") as? Bool ?? false
                        
                        var iconName = self.getIcon(productName: product)
                        
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy. MM. dd. HH:mm:ss"
                        let dayAsDate = formatter.date(from: dateTime)
                        let dayLimit = Calendar.current.date(byAdding: .day, value : 3, to: dayAsDate!)
                        let id = document.documentID
                        
                        if !self.productLogList.contains(where: {$0.id == id}){
                            self.productLogList.append(ProductLogDataModel(id: id, productName: product, icName: iconName, isReturned: isReturned, dateTime: dateTime, number: String(number), dayLimit: formatter.string(from: dayLimit!)))
                        }
                        
                    }
                }
                
                completion(true)
            }
            
        default:
            completion(false)
            return
        }
        

    }
    
    func getIcon(productName : String) -> String{
        switch productName{
        case "고데기" :
            return "ic_curlingiron"
            
        case "여성용품 (대)", "여성용품 (중)", "여성용품":
            return "ic_womentools"
            
        case "보조 배터리":
            return "ic_battery"
            
        case "충전기":
            return "ic_charger"
            
        case "컵":
            return "ic_cup"
            
        case "드라이기":
            return "ic_dryer"
            
        case "머리끈":
            return "ic_hairtie"
            
        case "핫팩", "온수찜질기", "온수 찜질기":
            return "ic_handwarmer"
            
        case "가위":
            return "ic_scissors"
            
        case "슬리퍼":
            return "ic_slippers"
            
        case "스테이플러":
            return "ic_stapler"
            
        case "테이프":
            return "ic_tape"
            
        case "우산":
            return "ic_umbrella"
            
        case "기화펜", "펜", "검정펜":
            return "ic_pen"
            
        case "농구공":
            return "ic_basketball"
            
        case "헬멧":
            return "ic_helmet"
            
        case "배드민턴 라켓":
            return "ic_lacket"
            
        case "돗자리":
            return "ic_mat"
            
        case "축구공":
            return "ic_soccerball"
            
        case "담요":
            return "ic_blanket"
            
        case "보드게임":
            return "ic_boardgame"
            
        case "계산기":
            return "ic_calculator"
            
        case "실험복":
            return "ic_labcoat"
            
        case "타이레놀", "소화제", "해열제", "진통제", "지사제", "감기약", "빨간약", "복통약":
            return "ic_medicine"
            
        case "파스", "붕대", "종이 반창고":
            return "ic_bandage"
            
        case "에어파스":
            return "ic_airparse"
            
        case "밴드":
            return "ic_band"
            
        case "면봉":
            return "ic_cottonswabs"
            
        case "소독약":
            return "ic_disinfectant"
            
        case "거즈", "거즈 (대)", "거즈 (중)", "거즈 (소)":
            return "ic_gauze"
            
        case "A4 (박스 단위)":
            return "ic_a4"
            
        case "풀":
            return "ic_glue"
            
        case "압핀":
            return "ic_pin"
            
        case "자":
            return "ic_ruler"
            
        case "마스크":
            return "ic_mask"
            
        case "빨대":
            return "ic_straw"
            
        case "텀블러":
            return "ic_tumbler"
            
        case "연고":
            return "ic_ointment"
            
        case "알콜솜":
            return "ic_alcoholswab"
            
        case "인공눈물":
            return "ic_artificialtear"
            
        case "솜":
            return "ic_cotton"
            
        case "가글":
            return "ic_gargle"
            
        case "과산화수소":
            return "ic_peroxide"
            
        case "핀셋":
            return "ic_tweezer"
            
        case "붕대용 테이프":
            return "ic_tape4bandage"
            
        case "샤프":
            return "ic_mechanicalpencil"
            
        case "샤프심":
            return "ic_pencillead"
            
        case "보드마커":
            return "ic_boardmarker"
            
        case "케이블타이":
            return "ic_cabletie"
            
        case "수정테이프":
            return "ic_correctiontape"
            
        case "지우개":
            return "ic_eraser"
            
        case "칼":
            return "ic_knife"
            
        case "펀치":
            return "ic_punch"
            
        case "빨간펜":
            return "ic_pen_r"
            
        case "스카치테이프":
            return "ic_scotchtape"
            
        case "렌즈 세척액":
            return "ic_eyedrop"
            
        case "줄자":
            return "ic_tapemeasure"
            
        case "섬유 탈취제":
            return "ic_spray"
            
        case "공구 상자":
            return "ic_toolbox"
            
        case "바람 주입기":
            return "ic_pump"
            
        default:
            return ""
        }
    }
    
    func convertProductCodeAsKorean(code : String) -> String{
        switch code{
            case "CurlingIron":
                return "고데기"
            
        case "WomenSet", "WomenTools" :
            return "여성용품"
            
        case "Battery", "battery":
            return "보조 배터리"
            
        case "Charger", "charger":
            return "충전기"
            
        case "cup", "Cup":
            return "컵"
            
        case "bandage":
            return "붕대"
            
        case "dryer", "Dryer":
            return "드라이기"
            
        case "hairTie", "HairTie":
            return "머리끈"
            
        case "hotPack":
            return "핫팩"
            
        case "scissor", "Scissor", "scissors":
            return "가위"
            
        case "slippers", "Slippers":
            return "슬리퍼"
            
        case "Stapler", "stapler":
            return "스테이플러"
            
        case "tape", "Tape":
            return "테이프"
            
        case "Umbrella", "umbrella":
            return "우산"
            
        case "vaporizationPen":
            return "기화펜"
            
        case "BasketBall", "basketBall":
            return "농구공"
            
        case "helmet", "Helmet":
            return "헬멧"
            
        case "Lacket":
            return "배드민턴 라켓"
            
        case "Mat", "mat":
            return "돗자리"
            
        case "soccerBall", "SoccerBall":
            return "축구공"
            
        case "blanket", "Blanket":
            return "담요"
            
        case "boardGame":
            return "보드게임"
            
        case "calculator":
            return "계산기"
            
        case "labCoat":
            return "실험복"
            
        case "Tylenol":
            return "타이레놀"
            
        case "adhesivePlaster":
            return "종이 반창고"
            
        case "airPars", "airParse":
            return "에어파스"
            
        case "band":
            return "밴드"
            
        case "cottonSwab":
            return "면봉"
            
        case "digestiveMedicine":
            return "소화제"
            
        case "disinfectant":
            return "소독약"
            
        case "feverRemedy":
            return "해열제"
            
        case "gauze_large":
            return "거즈 (대)"
            
        case "gauze_medium":
            return "거즈 (중)"
            
        case "gauze_small":
            return "거즈 (소)"
            
        case "painKiller":
            return "진통제"
            
        case "womenSet_L":
            return "여성용품 (대)"
            
        case "womenSet_M":
            return "여성용품 (중)"
            
        case "A4":
            return "A4 (박스 단위)"
            
        case "Glue":
            return "풀"
            
        case "Pen":
            return "펜"
            
        case "Pin":
            return "압핀"
            
        case "Ruler", "ruler":
            return "자"
            
        case "Heater":
            return "온수찜질기"
            
        case "Mask", "mask":
            return "마스크"
            
        case "Straw":
            return "빨대"
            
        case "Tumbler":
            return "텀블러"
            
        case "Ointment":
            return "연고"
            
        case "alcoholCotton":
            return "알콜솜"
            
        case "antidiarrheal":
            return "지사제"
            
        case "artificialTears":
            return "인공눈물"
            
        case "coldMedicine":
            return "감기약"
            
        case "cotton", "Cotton":
            return "솜"
            
        case "gargle":
            return "가글"
            
        case "gauze":
            return "거즈"
            
        case "hydrogenPeroxide":
            return "과산화수소"
            
        case "mercuroChrome":
            return "빨간약"
            
        case "pars":
            return "파스"
            
        case "pincette" :
            return "핀셋"
            
        case "stomachMedicine":
            return "복통약"
            
        case "tapeForBandage":
            return "붕대용 테이프"
            
        case "Sharp":
            return "샤프"
            
        case "SharpCore":
            return "샤프심"
            
        case "blackPen":
            return "검정펜"
            
        case "boardMarker":
            return "보드마커"
            
        case "cableTie":
            return "케이블타이"
            
        case "correctionTape":
            return "수정테이프"
            
        case "erasor":
            return "지우개"
            
        case "knife":
            return "칼"
            
        case "punch":
            return "펀치"
            
        case "redPen":
            return "빨간펜"
            
        case "scotchTape":
            return "스카치테이프"
            
        case "renu":
            return "렌즈 세척액"
            
        case "tapeMeasure":
            return "줄자"
            
        case "textileDeodorant":
            return "섬유 탈취제"
            
        case "toolSet":
            return "공구 상자"
            
        case "windInjector":
            return "바람 주입기"
            
        default:
            return code
        }
    }
    
    func getProductList(userManagement : UserManagement, type : String, completion : @escaping(_ result : Bool?) -> Void){
        productList.removeAll()
        
        switch type{
        case "CH":
            db.collection("Products").document("CH").getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                if document != nil{
                    let data = document?.data() as [String : Any]
                    
                    for index in data{
                        let dataMap = index.value as! [String : Any]
                        let productName = index.key
                        
                        let all = dataMap["all"] as? Int ?? 0
                        let late = dataMap["late"] as? Int ?? 0
                        
                        var productName_KR = ""
                        var iconName = ""
                        
                        switch productName{
                        case "CurlingIron":
                            productName_KR = "고데기"
                            iconName = "ic_curlingiron"
                            
                        case "basketBall":
                            productName_KR = "농구공"
                            iconName = "ic_basketball"

                        case "flag":
                            productName_KR = "부심기"
                            iconName = "ic_flag"

                        case "footBall":
                            productName_KR = "족구공"
                            iconName = "ic_football"

                        case "futsalBall":
                            productName_KR = "풋살공"
                            iconName = "ic_football"

                        case "mat":
                            productName_KR = "돗자리"
                            iconName = "ic_mat"

                        case "net":
                            productName_KR = "족구네트"
                            iconName = "ic_net"

                        case "soccerBall":
                            productName_KR = "축구공"
                            iconName = "ic_soccerball"

                        case "uniform_blue":
                            productName_KR = "조끼 (파랑)"
                            iconName = "ic_uniform_b"

                        case "uniform_green":
                            productName_KR = "조끼 (초록)"
                            iconName = "ic_uniform_g"

                        case "uniform_pink":
                            productName_KR = "조끼 (핑크)"
                            iconName = "ic_unifrom_p"

                        default:
                            productName_KR = "알 수 없음"
                        }
                        
                        self.productList.append(ProductDataModel(productName: productName, productName_KR: productName_KR, icName: iconName, all: String(all), late: String(late)))
                        
                        
                    }
                    
                    print(self.productList)
                }
            }
            
        case "College":
            db.collection("Products").document(userManagement.convertCollegeCodeAsString(collegeCode: userManagement.userInfo?.collegeCode)).getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    
                    completion(false)
                    
                    return
                }
                
                if document != nil{
                    switch userManagement.userInfo?.collegeCode{
                    case .CHE, .CON, .COH:
                        let data = document?.data() as [String : Any]
                        
                        for index in data{
                            let dataMap = index.value as! [String : Any]
                            let productName = index.key
                            
                            let all = dataMap["all"] as? Int ?? 0
                            let late = dataMap["late"] as? Int ?? 0
                            
                            self.productList.append(ProductDataModel(productName: productName, productName_KR: self.convertProductCodeAsKorean(code: productName), icName: self.getIcon(productName: self.convertProductCodeAsKorean(code: productName)), all: String(all), late: String(late)))
                            
                            
                        }
                        
                    case .COM, .SOC:
                        let data = document?.data() as [String : Any]
                        
                        for index in data.keys{
                            let listData = document?.data()![index]! as! [String : Any]
                            
                            for product in listData.keys{
                                let productData = listData[product] as! [String : Any]
                                
                                let productName = product
                                
                                let all = productData["all"] as? Int ?? 0
                                let late = productData["late"] as? Int ?? 0
                                
                                self.productList.append(ProductDataModel(productName: productName, productName_KR: self.convertProductCodeAsKorean(code: productName), icName: self.getIcon(productName: self.convertProductCodeAsKorean(code: productName)), all: String(all), late: String(late)))
                            }
                        }
                        
                    default:
                        completion(false)
                        
                        return
                    }
                    
                    

                    
                    print(self.productList)
                }
            }
            
        default:
            completion(false)
        }
    }
}
