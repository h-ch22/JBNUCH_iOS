//
//  StudentAssociationLinker.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import SwiftUI

struct StudentAssociationLinker: UIViewControllerRepresentable {
    typealias UIViewControllerType = StudentAssociationMapView
    
    func makeUIViewController(context: Context) -> StudentAssociationMapView {
        return StudentAssociationMapView()
    }
    
    func updateUIViewController(_ uiViewController: StudentAssociationMapView, context: Context) {
        
    }
}
