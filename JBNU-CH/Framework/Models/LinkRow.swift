//
//  LinkRow.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/01/06.
//

import SwiftUI
import UIKit
import LinkPresentation

struct LinkRow: UIViewRepresentable {
    typealias UIViewType = LPLinkView
    var previewURL : String
    
    @Binding var redraw : Bool
    
    func makeUIView(context: Context) -> LPLinkView {
        if let url = URL(string : previewURL){
            let view = LPLinkView(url : url)
            let provider = LPMetadataProvider()
            
            provider.startFetchingMetadata(for: url){(metadata, error) in
                if let metadata = metadata{
                    DispatchQueue.main.async{
                        view.metadata = metadata
                        
                        view.sizeToFit()
                        self.redraw.toggle()
                    }
                }
                
                else if error != nil{
                    return
                }
            }
            
            return view
        }

        else{
            return LPLinkView(url : URL(string : "about:blank")!)
        }
    }
    
    func updateUIView(_ uiView: LPLinkView, context: Context) {
        if let url = URL(string : previewURL){
            let provider = LPMetadataProvider()
            
            provider.startFetchingMetadata(for: url){(metadata, error) in
                if let metadata = metadata{
                    DispatchQueue.main.async{
                        uiView.metadata = metadata

                        uiView.sizeToFit()
                    }
                }
            }
        }

    }
}
