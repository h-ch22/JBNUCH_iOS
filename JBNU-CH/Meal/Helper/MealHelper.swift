//
//  MealHelper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/02/23.
//

/*import Foundation
import SwiftSoup

class MealHelper : ObservableObject{
    private let days = ["일", "월", "화", "수", "목", "금", "토"]
    private let coop_URL = "http://sobi.chonbuk.ac.kr/menu/week_menu.php"
    private let chambit_URL = "https://likehome.jbnu.ac.kr/home/main/inner.php?sMenu=B7200"
    private let Dorm_URL = "https://likehome.jbnu.ac.kr/home/main/inner.php?sMenu=B7100"
    private let iksan_URL = "https://likehome.jbnu.ac.kr/home/main/inner.php?sMenu=B7300"
    
    @Published var jinsoo_lunch = ""
    @Published var jinsoo_dinner = ""
    @Published var medical_lunch = ""
    @Published var medical_dinner = ""
    @Published var jeongdam = ""
    @Published var hoosaeng = ""
    @Published var Dorm_breakfast = ""
    @Published var Dorm_lunch = ""
    @Published var Dorm_dinner = ""
    @Published var newDorm_breakfast = ""
    @Published var newDorm_lunch = ""
    @Published var newDorm_dinner = ""
    @Published var iksan_breakfast = ""
    @Published var iksan_lunch = ""
    @Published var iksan_dinner = ""
    
    func parseHTML(day : String, completion : @escaping(_ result : Bool?) -> Void){
        guard let url = URL(string : coop_URL) else {return}
        
        jinsoo_lunch = ""
        jinsoo_dinner = ""
        medical_lunch = ""
        medical_dinner = ""
        
        do{
            let html = try String(contentsOf : url, encoding : .utf8)
            let doc : Document = try SwiftSoup.parse(html)
            var pathes_jinsoo_lunch : Elements = try doc.select("div.contentsArea.WeekMenu").select("div:nth-child(253)").select("div.ttArea").select("span:nth-child(3)").select("span").select("table").select("tbody").select("tr:nth-child(1)")
            var pathes_jinsoo_dinner : Elements = try doc.select("div.contentsArea.WeekMenu").select("div:nth-child(253)").select("div.ttArea").select("span:nth-child(3)").select("span").select("table").select("tbody").select("tr:nth-child(2)")
            var pathes_medical_lunch : Elements = try doc.select("div.contentsArea.WeekMenu").select("div:nth-child(254)").select("div.menu_scrollArea").select("div").select("table").select("tbody").select("tr:nth-child(1)")
            var pathes_medical_dinner : Elements = try doc.select("div.contentsArea.WeekMenu").select("div:nth-child(254)").select("div.menu_scrollArea").select("div").select("table").select("tbody").select("tr:nth-child(2)")

            switch day{
            case "월" :
                pathes_jinsoo_lunch = try pathes_jinsoo_lunch.select("td:nth-child(3)")
                pathes_jinsoo_dinner = try pathes_jinsoo_dinner.select("td:nth-child(3)")
                pathes_medical_lunch = try pathes_medical_lunch.select("tr:nth-child(3)")
                pathes_medical_dinner = try pathes_medical_dinner.select("tr:nth-child(3)")

            case "화":
                pathes_jinsoo_lunch = try pathes_jinsoo_lunch.select("td:nth-child(4)")
                pathes_jinsoo_dinner = try pathes_jinsoo_dinner.select("td:nth-child(4)")
                pathes_medical_lunch = try pathes_medical_lunch.select("tr:nth-child(4)")
                pathes_medical_dinner = try pathes_medical_dinner.select("tr:nth-child(4)")

            case "수":
                pathes_jinsoo_lunch = try pathes_jinsoo_lunch.select("td:nth-child(5)")
                pathes_jinsoo_dinner = try pathes_jinsoo_dinner.select("td:nth-child(5)")
                pathes_medical_lunch = try pathes_medical_lunch.select("tr:nth-child(5)")
                pathes_medical_dinner = try pathes_medical_dinner.select("tr:nth-child(5)")

            case "목":
                pathes_jinsoo_lunch = try pathes_jinsoo_lunch.select("td:nth-child(6)")
                pathes_jinsoo_dinner = try pathes_jinsoo_dinner.select("td:nth-child(6)")
                pathes_medical_lunch = try pathes_medical_lunch.select("tr:nth-child(6)")
                pathes_medical_dinner = try pathes_medical_dinner.select("tr:nth-child(6)")

            case "금":
                pathes_jinsoo_lunch = try pathes_jinsoo_lunch.select("td:nth-child(7)").select("td")
                pathes_jinsoo_dinner = try pathes_jinsoo_dinner.select("td:nth-child(7)")
                pathes_medical_lunch = try pathes_medical_lunch.select("tr:nth-child(7)")
                pathes_medical_dinner = try pathes_medical_dinner.select("tr:nth-child(7)")

            default:
                pathes_jinsoo_lunch = try pathes_jinsoo_lunch.select("td:nth-child(3)")

            }

            for element in pathes_jinsoo_lunch.array(){
                if try element.text() != ""{
                    jinsoo_lunch.append("\(try element.text())\n")
                }
            }
            
            for element in pathes_jinsoo_dinner.array(){
                if try element.text() != ""{
                    jinsoo_dinner.append("\(try element.text())\n")
                }
            }
            
            for element in pathes_medical_lunch.array(){
                if try element.text() != ""{
                    medical_lunch.append("\(try element.text())\n")
                }
            }
            
            for element in pathes_medical_dinner.array(){
                if try element.text() != ""{
                    medical_dinner.append("\(try element.text())\n")
                }
            }
            

            completion(true)
        } catch let error{
            print("Error while parsing HTML : \(error)")
            completion(false)
        }
    }
    
    func parseDorm(type : String, day : String, completion : @escaping(_ result : Bool?) -> Void){
        var url = URL(string : "")
        
        switch type{
            case "chambit" : url = URL(string: chambit_URL)
            case "iksan" : url = URL(string : iksan_URL)
            case "oldDorm" : url = URL(string : Dorm_URL)
        default: url = URL(string : Dorm_URL)
        }
        
        do{
            let html = try String(contentsOf : url!, encoding : .utf8)
            let doc : Document = try SwiftSoup.parse(html)
            
            var pathes_Dorm_breakfast : Elements = try doc.select("calendar").select("table").select("tbody").select("tr:nth-child(1)")
            var pathes_Dorm_lunch : Elements = try doc.select("calendar").select("table").select("tbody").select("tr:nth-child(2)")
            var pathes_Dorm_dinner : Elements = try doc.select("calendar").select("table").select("tbody").select("tr:nth-child(3)")

            switch day{
            case "일" :
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(2)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(2)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(2)").select("a")
                
            case "월" :
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(3)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(3)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(3)").select("a")

            case "화":
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(4)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(4)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(4)").select("a")

            case "수":
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(5)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(5)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(5)").select("a")

            case "목":
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(6)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(6)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(6)").select("a")

            case "금":
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(7)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(7)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(7)").select("a")
                
            case "토":
                pathes_Dorm_breakfast = try pathes_Dorm_breakfast.select("td:nth-child(8)").select("a")
                pathes_Dorm_lunch = try pathes_Dorm_lunch.select("td:nth-child(8)").select("a")
                pathes_Dorm_dinner = try pathes_Dorm_dinner.select("td:nth-child(8)").select("a")

            default:
                break
            }
            
            for element in pathes_Dorm_breakfast.array(){
                if try element.text() != ""{
                    print(try element.text())

                    switch type{
                    case "chambit" :
                        newDorm_breakfast.append("\(try element.text())\n")
                        
                    case "iksan" :
                        iksan_breakfast.append("\(try element.text())\n")
                        
                    case "oldDorm" :
                        Dorm_breakfast.append("\(try element.text())\n")
                        
                    default:
                        newDorm_breakfast.append("\(try element.text())\n")
                    }
                }
            }
            
            for element in pathes_Dorm_lunch.array(){
                if try element.text() != ""{
                    print(try element.text())

                    switch type{
                    case "chambit" :
                        newDorm_lunch.append("\(try element.text())\n")
                        
                    case "iksan" :
                        iksan_lunch.append("\(try element.text())\n")
                        
                    case "oldDorm" :
                        Dorm_lunch.append("\(try element.text())\n")
                        
                    default:
                        Dorm_lunch.append("\(try element.text())\n")
                    }
                }
            }
            
            for element in pathes_Dorm_dinner.array(){
                if try element.text() != ""{
                    print(try element.text())

                    switch type{
                    case "chambit" :
                        newDorm_dinner.append("\(try element.text())\n")
                        
                    case "iksan" :
                        iksan_dinner.append("\(try element.text())\n")
                        
                    case "oldDorm" :
                        Dorm_dinner.append("\(try element.text())\n")
                        
                    default:
                        Dorm_dinner.append("\(try element.text())\n")
                    }
                }
            }
            
            completion(true)
        } catch let error{
            print("Error while parsing HTML : \(error)")
            completion(false)
        }
        


    }
}*/
