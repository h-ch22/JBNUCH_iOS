//
//  StoreMapView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import Foundation
import NMapsMap
import SwiftUI

class ViewInsideMap : UIViewController{
    let location : String?
    let markerTitle : String?
    let subTitle : String?
    private var mapView : NMFMapView!
    
    init(location : String?, markerTitle : String?, subTitle : String?){
        self.location = location
        self.markerTitle = markerTitle
        self.subTitle = subTitle
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        
        mapView = NMFMapView(frame : view.frame)
        view.addSubview(mapView)
        
        placeMarker()
        
    }
    
    func placeMarker(){
        if self.location != "" && self.location != nil{
            let coordAsString = self.location!.components(separatedBy: ", ")
            let coord = NMGLatLng(lat : Double(coordAsString[0])!, lng : Double(coordAsString[1])!)
            let cameraUpdate = NMFCameraUpdate(scrollTo : coord)
            mapView.moveCamera(cameraUpdate)
            
            let marker = NMFMarker()
            marker.position = coord
            marker.iconImage = NMF_MARKER_IMAGE_BLACK
            marker.iconTintColor = UIColor(Color.accent)
            
            marker.captionText = self.markerTitle ?? ""
            marker.captionColor = UIColor(Color.accent)
            
            marker.subCaptionText = self.subTitle ?? ""
            marker.subCaptionColor = UIColor.black
            
            marker.mapView = mapView
        }

    }
    
}
