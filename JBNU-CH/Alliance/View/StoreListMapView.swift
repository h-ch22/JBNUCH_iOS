//
//  StoreListMapView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/10.
//

import Foundation
import NMapsMap
import SwiftUI
import CoreLocation

class StoreListMapView : UIViewController, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var naverMapView : NMFNaverMapView!
    let userManagement : UserManagement
    let models : [AllianceDataModel]
    let helper : AllianceHelper
    
    init(models : [AllianceDataModel], userManagement : UserManagement, helper : AllianceHelper){
        self.models = models
        self.userManagement = userManagement
        self.helper = helper
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        naverMapView = NMFNaverMapView(frame : view.frame)
        
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showLocationButton = true
        naverMapView.mapView.isIndoorMapEnabled = true
        naverMapView.mapView.positionMode = .compass
        naverMapView.mapView.logoAlign = .rightTop
        
        var markers = [NMFMarker]()
        
        view.addSubview(naverMapView)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                                                   lng: locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            
            naverMapView.mapView.moveCamera(cameraUpdate)
            
        }
        
        for index in 0..<models.count{
            let position = models[index].location ?? ""
            
            let position_split = position.components(separatedBy: ", ")
            
            let marker = NMFMarker(position: NMGLatLng(lat: Double(position_split[0])!, lng: Double(position_split[1])!))
            
            if models[index].allianceType == "단대"{
                marker.captionText = models[index].storeName ?? ""
                marker.captionColor = UIColor(Color.orange)
                
                marker.subCaptionText = models[index].benefits ?? ""
                marker.subCaptionColor = .black
                
                marker.iconImage = NMF_MARKER_IMAGE_BLACK
                marker.iconTintColor = UIColor(Color.orange)
            }
            
            else{
                marker.captionText = models[index].storeName ?? ""
                marker.captionColor = UIColor(Color.accent)
                
                marker.subCaptionText = models[index].benefits ?? ""
                marker.subCaptionColor = .black
                
                marker.iconImage = NMF_MARKER_IMAGE_BLACK
                marker.iconTintColor = UIColor(Color.accent)
            }
            
            marker.touchHandler = {(overlay : NMFOverlay) -> Bool in
                let hostingView = UIHostingController(rootView : AllianceDetailView(data: self.models[index], college : self.userManagement.userInfo?.collegeCode, helper : self.helper))
                self.present(hostingView, animated: true, completion: nil)
                
                return true
            }
            
            markers.append(marker)
        }
        
        DispatchQueue.main.async{
            for marker in markers{
                marker.mapView = self.naverMapView.mapView
            }
        }
    }
}
