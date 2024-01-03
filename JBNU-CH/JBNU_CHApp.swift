//
//  JBNU_CHApp.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/11/23.
//

import SwiftUI
import Firebase

@main
struct JBNU_CHApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init(){
        FirebaseApp.configure()
        UIView.appearance().tintColor = UIColor(Color.accent)
    }
    
    var body: some Scene {
        WindowGroup {
            SignInView()
        }
    }
}

extension String{
    func createRandomStr(length : Int) -> String{
        let str = (0..<length).map{ _ in self.randomElement()!}
        
        return String(str)
    }
}

extension Color{
    static let accent = Color("accent")
    static let background = Color("background")
    static let txtColor = Color("txtColor")
    static let btnColor = Color("btnColor")
}

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
}


extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

extension View {
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

extension String {
    init<S: Sequence>(unicodeScalars ucs: S)
        where S.Iterator.Element == UnicodeScalar
    {
        var s = ""
        s.unicodeScalars.append(contentsOf: ucs)
        self = s
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

extension Date{
    func dayNumberOfWeek() -> Int? {
            return Calendar.current.dateComponents([.weekday], from: self).weekday
        }
}
