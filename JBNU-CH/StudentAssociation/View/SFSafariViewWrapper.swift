//
//  SFSafariViewWrapper.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI
import SafariServices

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}
