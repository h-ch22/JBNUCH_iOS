//
//  StudentAssociationMapView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2022/03/25.
//

import Foundation
import NMapsMap
import SwiftUI

class StudentAssociationMapView : UIViewController{
    let location = "35.84632132069861, 127.12857944374139"
    private var mapView : NMFMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = NMFMapView(frame : view.frame)
        view.addSubview(mapView)
        
        let coord = NMGLatLng(lat : Double("35.84632132069861")!, lng : Double("127.12857944374139")!)
        let camUpdate = NMFCameraUpdate(scrollTo: coord)
        mapView.moveCamera(camUpdate)
        
        let marker = NMFMarker()
        marker.position = coord
        marker.iconImage = NMFOverlayImage(name : "ic_logo_no_slogan")
        marker.width = 100
        marker.height = 100
        
        marker.captionText = "전북대학교 총학생회"
        marker.captionColor = UIColor(Color.accent)
        
        marker.subCaptionText = "제2학생회관, 3층"
        marker.subCaptionColor = UIColor.black
        
        marker.mapView = mapView
    }
}
