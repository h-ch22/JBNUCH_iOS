//
//  PDFViewer.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/29.
//

import PDFKit
import SwiftUI

struct PDFViewer : View{
    @State var url : URL
    @State var page : Int?
    @State var isPageAvailable = false
    
    var body : some View{
        PDFKitRepresentedView(document : PDFDocument(url : url)!, url : $url, page : $page, isPageAvailable: $isPageAvailable).onAppear{
            if self.page != nil{
                isPageAvailable = true
            }
        }
    }
}

struct PDFKitRepresentedView : UIViewRepresentable{
    let pdfView = PDFView()
    let document : PDFDocument
    
    @Binding var url : URL
    @Binding var page : Int?
    @Binding var isPageAvailable : Bool
    
    func goToSpecificPage(){
        if page != nil{
            print(page!)
            if let pageToGo = document.page(at: page!){
                pdfView.go(to: pageToGo)
            }
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        pdfView.autoScales = true
        
        pdfView.document = document
        pdfView.usePageViewController(true, withViewOptions: nil)
        
        if isPageAvailable{
            goToSpecificPage()
        }

        return pdfView
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        if isPageAvailable{
            goToSpecificPage()
        }
        
    }
    
}
