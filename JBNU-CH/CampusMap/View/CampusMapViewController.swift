//
//  CampusMapViewController.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import Foundation
import UIKit
import NMapsMap
import CoreLocation
import SwiftUI

class CampusMapViewController : UIViewController, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var naverMapView : NMFNaverMapView!
    private let latLng_NUR : [String : String] = ["간호대학" : "35.84747805239486, 127.14495440189158"]
    private let latLng_ENG = [
        "공과대학 1호관" : "35.84657677459349, 127.13256206828062",
        "공과대학 2호관" : "35.84657677459349, 127.13256206828062",
        "공과대학 3호관" : "35.846994531382094, 127.13351082924164",
        "공과대학 4호관" : "35.847485076311926, 127.13273776477824",
        "공과대학 5호관" : "35.8475110124338, 127.1314181892545",
        "공과대학 6호관" : "35.84714445581063, 127.13457797148128",
        "공과대학 7호관" : "35.846019748437946, 127.13448547014687",
        "공과대학 8호관" : "35.84829241655058, 127.1334073508402",
        "공과대학 9호관" : "35.84764604431293, 127.1337295107396"
    ]

    private let latLng_AGR = [
        "농생대 1호관" : "35.849260834241385, 127.13348623036329",
        "농생대 2호관" : "35.849064621027324, 127.13192057960666",
        "농생대 3호관" : "35.84858674487811, 127.13477467113559"
    ]

    private let latLng_COE = [
        "사범대 본관" : "35.84266103510864, 127.13197441748541",
        "사범대 과학관" : "35.845789347438554, 127.12969146692753",
        "사범대 예체능관" : "35.84783864733538, 127.12976793345085"
    ]

    private let latLng_SOC = [
        "사회과학대학" : "35.84405847484623, 127.1336284800873",
        "인문사회관" : "35.84316841249447, 127.13382347587414"
    ]

    private let latLng_COM = [
        "상과대학 1호관" : "35.84473487695274, 127.13378425204458",
        "상과대학 2호관" : "35.84470384981582, 127.13544289716468",
        "상과대학 3호관" : "35.84455905634085, 127.13621161534046"
    ]

    private let latLng_CHE = [
        "생활과학대학" : "35.84250145641751, 127.13276590941227"
    ]

    private let latLng_ART = [
        "예술대학 3호관" : "35.846215915727214, 127.12680304079065",
        "예술대학 1호관" : "35.85062837290454, 127.12743507772056",
        "예술대학 2호관" : "35.85083114042394, 127.12793540124528"
    ]

    private let latLng_COH = [
        "인문대학 1호관" : "35.84318627789101, 127.13310501284555",
        "인문사회관" : "35.84316841249447, 127.13382347587414",
        "인문대학 2호관" : "35.844177737418455, 127.13280572765895"
    ]

    private let latLng_CON = [
        "자연대 본관" : "35.847494175903776, 127.13037150490443",
        "자연대 1호관" : "35.84531298732976, 127.12744876966514",
        "자연대 2호관" : "35.845053466508126, 127.1290417509836",
        "자연대 3호관" : "35.847088466785046, 127.13039266169687",
        "자연대 4호관" : "35.84662956772452, 127.13084166389157",
        "자연대 5호관" : "35.846137500109684, 127.13074164974456"
    ]

    private let latLng_Restaurant = [
        "진수당" : "35.84518712791879, 127.13132344965273",
        "후생관" : "35.84770178115334, 127.13434089675506"
    ]

    private let latLng_Cafe = [
        "카페 느티나무" : "35.84682268877414, 127.12852189846933",
        "학생회관 카페" : "35.84593020375495, 127.12849847226484",
        "중앙도서관 카페" : "35.84808205605726, 127.13238990443128",
        "아로미마실" : "35.84461262667609, 127.13042502042425",
        "카페베네" : "35.844431634582925, 127.13023044860384",
        "진수당 카페" : "35.845409534858106, 127.13114984907604"
    ]

    private let latLng_ConvenienceStore = [
        "공과대학 CU" : "35.846759089280475, 127.1326480051315",
        "진수당 CU" : "35.845442511067226, 127.13095741465048",
        "뉴실크로드 이마트24 (24시간)" : "35.84467344204404, 127.13036785533161",
        "제1학생회관 CU" : "35.84594256016972, 127.12850156831094",
        "중앙도서관 CU" : "35.848071741830296, 127.13234610447473"
    ]

    private let latLng_Study = [
        "중앙도서관" : "35.84824578953613, 127.13201987786945",
        "학습도서관" : "35.847219347351334, 127.13572312202609",
        "교보문고" : "35.8457695765424, 127.12802747902366"
    ]

    private let latLng_hospital = [
        "응급실" : "35.846319386667524, 127.13963865412482",
        "치과병원" : "35.84698017531671, 127.1393399172006",
        "전북대 병원 본관" : "35.846407109424895, 127.14132101586677",
        "전북대 병원 임상연구센터" : "35.84876090252506, 127.1396043546476"
    ]

    private let latLng_ATM = [
        "국민은행" : "35.84438482086647, 127.12740238693017",
        "전북은행" : "35.84632132069861, 127.12857944374139",
        "우체국 / NH농협" : "35.84632132069861, 127.12857944374139"
    ]

    private let latLng_Others : [String: String] = [
        "삼성문화회관" : "35.8433073405292, 127.13013266851857",
        "박물관" : "35.84549977577212, 127.1261598623699",
        "제1학생회관" : "35.84579058957624, 127.12824012388016",
        "제2학생회관/우체국" : "35.84632132069861, 127.12857944374139",
        "동아리전용관" : "35.84861696595411, 127.1285674650923",
        "대운동장" : "35.84770043024747, 127.12799638708627",
        "소운동장" : "35.84668934387066, 127.12781955842618",
        "보조구장" : "35.84914029185945, 127.12667062916226"
    ]
    
    var markers = [NMFMarker]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height / 1.25)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        naverMapView = NMFNaverMapView(frame : view.frame)
        
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showIndoorLevelPicker = true
        naverMapView.mapView.isIndoorMapEnabled = true
        naverMapView.mapView.positionMode = .compass
        naverMapView.mapView.logoAlign = .rightTop
        
        view.addSubview(naverMapView)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                                                   lng: locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            
            naverMapView.mapView.moveCamera(cameraUpdate)
            
        }
    }
    
    func placeMarker(selectedItem : [buildingModel]){
        for marker in self.markers{
            marker.mapView = nil
        }
        
        self.markers.removeAll()
        
        for index in selectedItem{
            if index.isSelected{
                switch index.name{
                case "간호대":
                    manageMarker(name: latLng_NUR)
                case "공과대":
                    manageMarker(name: latLng_ENG)

                case "농생대":
                    manageMarker(name: latLng_AGR)
                case "사범대":
                    manageMarker(name: latLng_COE)
                case "사회대":
                    manageMarker(name: latLng_SOC)
                case "상과대":
                    manageMarker(name: latLng_COM)
                case "생활대":
                    manageMarker(name: latLng_CHE)
                case "예술대":
                    manageMarker(name: latLng_ART)
                case "인문대":
                    manageMarker(name: latLng_COH)
                case "자연대":
                    manageMarker(name: latLng_CON)
                case "대학병원":
                    manageMarker(name: latLng_hospital)
                case "식당":
                    manageMarker(name: latLng_Restaurant)
                case "카페":
                    manageMarker(name: latLng_Cafe)
                case "편의점":
                    manageMarker(name: latLng_ConvenienceStore)
                case "학습":
                    manageMarker(name: latLng_Study)
                case "ATM" :
                    manageMarker(name: latLng_ATM)
                case "기타":
                    manageMarker(name: latLng_Others)
                default:
                    break
                }
            }
        }
    }
    
    func manageMarker(name : [String : String]){

        for value in name{
            let position = value.value.components(separatedBy: ", ")
            let marker = NMFMarker(position: NMGLatLng(lat : Double(position[0])!, lng : Double(position[1])!))
            
            marker.captionText = value.key
            marker.captionColor = UIColor(Color.accent)
            
            marker.iconImage = NMF_MARKER_IMAGE_BLACK
            marker.iconTintColor = UIColor(Color.accent)
            
            markers.append(marker)
        }
        
        DispatchQueue.main.async{
            for marker in self.markers{
                marker.mapView = self.naverMapView.mapView
            }
        }
    }
}
