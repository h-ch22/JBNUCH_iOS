//
//  CalendarSettings.swift
//  JBNU-CH
//
//  Created by Changjin Ha on 2022/09/23.
//

import Foundation
import KVKCalendar
import EventKit
import FirebaseStorage

protocol CalendarSeetings{
    var selectDate : Date{get set}
    var events : [Event] {get set}
    var style : Style {get}
    var eventViewer : EventViewer {get set}
}

extension CalendarSeetings{
    var topOffset : CGFloat{
        let barHeight = UIApplication.shared.statusBarHeight
        
        return UIApplication.shared.activeWindow?.rootViewController?.view.safeAreaInsets.top ?? barHeight
    }
    
    var bottomOffset : CGFloat{
        return UIApplication.shared.activeWindow?.rootViewController?.view.safeAreaInsets.bottom ?? 0
    }
    
    var defaultStringDate : String{
        "01.12.2021"
    }
    
    var defaultDate : Date{
        onlyDateFormatter.date(from: defaultStringDate) ?? Date()
    }
    
    var onlyDateFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. MM. dd"
        
        return formatter
    }
    
    func handleChangingEvent(_ event : Event, start : Date?, end : Date?) -> (range : Range<Int>, events : [Event])? {
        var eventTemp = event
        guard let startTemp = start, let endTemp = end else{return nil}
        
        let startTime = timeFormatter(date : startTemp, format : style.timeSystem.format)
        let endTime = timeFormatter(date : endTemp, format : style.timeSystem.format)
        
        eventTemp.start = startTemp
        eventTemp.end = endTemp
        eventTemp.title = TextEvent(timeline : "\(startTime) - \(endTime)\n new time",
                                    month : "\(startTime) - \(endTime)\n new time",
                                    list : "\(startTime) - \(endTime)\n new time")
        
        if let idx = events.firstIndex(where : {$0.compare(eventTemp)}){
            return (idx..<idx + 1, [eventTemp])
        }else{
            return nil
        }
    }
    
    func handleSizeCell(type: CalendarType, stye: Style, view: UIView) -> CGSize? {
        guard type == .month && UIDevice.current.userInterfaceIdiom == .phone else { return nil }
        
        switch style.month.scrollDirection {
        case .vertical:
            return CGSize(width: view.bounds.width / 7, height: 70)
        case .horizontal:
            return nil
        @unknown default:
            return nil
        }
    }
    
    func handleCustomEventView(event: Event, style: Style, frame: CGRect) -> EventViewGeneral? {
        guard event.ID == "2" else { return nil }
        
        return CustomViewEvent(style: style, event: event, frame: frame)
    }
    
    func handleOptionMenu(type: CalendarType) -> (menu: UIMenu, customButton: UIButton?)? {
        guard type == .day else { return nil }
        
        let action = UIAction(title: "Test", attributes: .destructive) { _ in
            print("test tap")
        }
        
        return (UIMenu(title: "Test menu", children: [action]), nil)
    }
    
    func handleNewEvent(_ event: Event, date: Date?) -> Event? {
        var newEvent = event
        
        guard let start = date,
              let end = Calendar.current.date(byAdding: .minute, value: 30, to: start) else { return nil }
        
        let startTime = timeFormatter(date: start, format: style.timeSystem.format)
        let endTime = timeFormatter(date: end, format: style.timeSystem.format)
        newEvent.start = start
        newEvent.end = end
        newEvent.ID = "\(events.count + 1)"
        newEvent.title = TextEvent(timeline: "\(startTime) - \(endTime)\n new time",
                                   month: "\(startTime) - \(endTime)\n new time",
                                   list: "\(startTime) - \(endTime)\n new time")
        return newEvent
    }
    
    func handleCell<T>(parameter: CellParameter,
                       type: CalendarType,
                       view: T,
                       indexPath: IndexPath) -> KVKCalendarCellProtocol? where T: UIScrollView {
        switch type {
        case .year where parameter.date?.kvkMonth == Date().kvkMonth:
            let cell = (view as? UICollectionView)?.kvkDequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
                cell.imageView.image = UIImage(named: "ic_stub")
            }
            return cell
        case .day, .week, .month:
            guard parameter.date?.kvkDay == Date().kvkDay && parameter.type != .empty else { return nil }
            
            let cell = (view as? UICollectionView)?.kvkDequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
                cell.imageView.image = UIImage(named: "ic_stub")
            }
            return cell
        default:
            return nil
        }
    }
    
    func handleEvents(systemEvents: [EKEvent]) -> [Event] {
        // if you want to get a system events, you need to set style.systemCalendars = ["test"]
        let mappedEvents = systemEvents.compactMap { (event) -> Event in
            let startTime = timeFormatter(date: event.startDate, format: style.timeSystem.format)
            let endTime = timeFormatter(date: event.endDate, format: style.timeSystem.format)
            event.title = "\(startTime) - \(endTime)\n\(event.title ?? "")"
            
            return Event(event: event)
        }
        
        return events + mappedEvents
    }
    
    func createCalendarStyle() -> Style {
        var style = Style()
        style.timeline.isHiddenStubEvent = false
        style.startWeekDay = .sunday
        style.systemCalendars = ["Calendar1", "Calendar2", "Calendar3"]
        style.timeline.scrollLineHourMode = .onlyOnInitForDate(defaultDate)
        style.timeline.showLineHourMode = .always
        return style
    }
    
    func timeFormatter(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
    
    func loadEvents(dateFormat : String, completion : @escaping ([Event]) -> Void){
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
                    let events = result?.data.compactMap({ (item) -> Event in
                        let startDate = self.formatter(date: item.start)
                        let endDate = self.formatter(date: item.end)
                        let startTime = self.timeFormatter(date: startDate, format: dateFormat)
                        let endTime = self.timeFormatter(date: endDate, format : dateFormat)
                        
                        var event = Event(ID: item.id)
                        event.start = startDate
                        event.end = endDate
                        event.color = Event.Color(item.color)
                        event.isAllDay = item.allDay
                        event.isContainsFile = !item.files.isEmpty
                        
                        if item.allDay{
                            event.title = TextEvent(timeline : "\(item.title)",
                                                    month : "\(item.title) \(startTime)",
                                                    list : item.title)
                        } else{
                            event.title = TextEvent(timeline: "\(startTime) - \(endTime)\n\(item.title)",
                                                    month : "\(item.title) \(startTime)",
                                                    list : "\(startTime) - \(endTime) \(item.title)")
                        }
                        
                        return event
                    })
                    
                    completion(events!)
                }
            }
        }
    }
}

final class CustomViewEvent: EventViewGeneral {
    override init(style: Style, event: Event, frame: CGRect) {
        super.init(style: style, event: event, frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "ic_stub"))
        imageView.frame = CGRect(origin: CGPoint(x: 3, y: 1), size: CGSize(width: frame.width - 6, height: frame.height - 2))
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        backgroundColor = event.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ItemData: Decodable {
    let data: [Item]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: CodingKeys.data)
    }
}

struct Item: Decodable {
    let id: String, title: String, start: String, end: String
    let color: UIColor, colorText: UIColor
    let files: [String]
    let allDay: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, title, start, end, color, files
        case colorText = "text_color"
        case allDay = "all_day"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        start = try container.decode(String.self, forKey: CodingKeys.start)
        end = try container.decode(String.self, forKey: CodingKeys.end)
        allDay = try container.decode(Int.self, forKey: CodingKeys.allDay) != 0
        files = try container.decode([String].self, forKey: CodingKeys.files)
        let strColor = try container.decode(String.self, forKey: CodingKeys.color)
        color = UIColor.hexStringToColor(hex: strColor)
        let strColorText = try container.decode(String.self, forKey: CodingKeys.colorText)
        colorText = UIColor.hexStringToColor(hex: strColorText)
    }
}

extension UIColor {
    
    static func hexStringToColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return .systemGray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
    
}

extension UIApplication {
    
    var activeWindow: UIWindow? {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    }
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return activeWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 24
        } else {
            return statusBarFrame.height
        }
    }
    
}
