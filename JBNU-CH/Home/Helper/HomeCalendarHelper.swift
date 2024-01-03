//
//  HomeCalendarHelper.swift
//  JBNU-CH
//
//  Created by Changjin Ha on 2022/09/23.
//

import Foundation
import KVKCalendar
import EventKit
import FirebaseStorage

class HomeCalendarHelper : ObservableObject{
    @Published var data : [HomeCalendarDataModel] = []
    
    func getData(completion : @escaping(_ result : Bool?) -> Void){
        let decoder = JSONDecoder()
        
        let storage = Storage.storage()
        let jsonRef = storage.reference(withPath: "calendar/events.json")
        let destinationPath : URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationURL = destinationPath.appendingPathComponent("events.json")
        
        let downloadTask = jsonRef.write(toFile: destinationURL){url, error in
            if let error = error{
                print("error while downloading file : ", error)
                
                return
            }
            
            else{
                print("file download successful : ", url)
                
                let url_original = url?.absoluteString
                var url_arr = url_original?.components(separatedBy: "Optional(")
                var url_fin = url_arr![0].components(separatedBy: ")")
                
                if let dir : URL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false){
                    let path : String = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("events.json").path
                    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path as! String), options: .mappedIfSafe) else{return}
                    let result = try? decoder.decode(ItemData.self, from: data)
                    
                    print("pass")
                    let events = result?.data.compactMap({ (item) -> Void in
                        let startDate = item.start.components(separatedBy: "T")
                        let endDate = item.end.components(separatedBy: "T")
                        let title = item.title
                        
                        let allDay = item.allDay
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yy. MM. dd"
                        
                        let startDateAsDate = dateFormatter.date(from: startDate[0])
                        let endDateAsDate = dateFormatter.date(from : endDate[0])
                        
                        let current = dateFormatter.string(from: Date())
                        let currentAsDate = dateFormatter.date(from: current)
                        
                        if currentAsDate! < endDateAsDate!{
                            self.data.append(HomeCalendarDataModel(title: title, startDate: startDate[0], endDate: endDate[0], isAllDay : allDay))
                        }
                        
                    })
                    completion(true)
                }
            }
        }
    }
}
