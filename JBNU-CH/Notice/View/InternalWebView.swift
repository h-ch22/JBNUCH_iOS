//
//  InternalWebView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/11.
//

import SwiftUI
import WebKit

struct InternalWebView: UIViewRepresentable {
    let url : URL

    func makeUIView(context : Context) -> WKWebView{
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame : CGRect.zero, configuration: configuration)
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        webView.load(URLRequest(url : url))
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}
