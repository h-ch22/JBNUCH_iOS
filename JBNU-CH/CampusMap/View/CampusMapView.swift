//
//  CampusMapView.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/17.
//

import SwiftUI

struct buildingModel : Hashable{
    var name : String
    var isSelected : Bool
}

struct CampusMapView: View {
    @State private var buildingList : [buildingModel] = [
        buildingModel(name: "간호대", isSelected : false),
        buildingModel(name: "공과대", isSelected : false),
        buildingModel(name: "농생대", isSelected : false),
        buildingModel(name: "사범대", isSelected : false),
        buildingModel(name: "사회대", isSelected : false),
        buildingModel(name: "상과대", isSelected : false),
        buildingModel(name: "생활대", isSelected : false),
        buildingModel(name: "예술대", isSelected : false),
        buildingModel(name: "인문대", isSelected : false),
        buildingModel(name: "자연대", isSelected : false),
        buildingModel(name: "대학병원", isSelected : false),
        buildingModel(name: "식당", isSelected : false),
        buildingModel(name: "카페", isSelected : false),
        buildingModel(name: "편의점", isSelected : false),
        buildingModel(name: "학습", isSelected : false),
        buildingModel(name: "ATM", isSelected : false),
        buildingModel(name: "기타", isSelected : false)
    ]
    
    @State private var selection = Set<buildingModel>()
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack(spacing : 15){
                    ForEach($buildingList, id : \.self){ (index : Binding<buildingModel>) in
                        Toggle(index.name.wrappedValue, isOn : index.isSelected)
                            .toggleStyle(.button)
                            .onChange(of : index.isSelected.wrappedValue){value in
                                if value{
                                    for i in 0..<buildingList.count{
                                        if buildingList[i].name != index.name.wrappedValue{
                                            buildingList[i].isSelected = false
                                            print("\(buildingList[i].name) : \(buildingList[i].isSelected)")
                                        }
                                    }
                                }
                            }
                    }
                }
                
            }
            
            CampusMapViewRepresentable(selectedList : $buildingList)
        }
            .navigationTitle("캠퍼스 맵")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CampusMapView_Previews: PreviewProvider {
    static var previews: some View {
        CampusMapView()
    }
}

struct CampusMapViewRepresentable : UIViewControllerRepresentable{
    @Binding var selectedList : [buildingModel]
    typealias UIViewControllerType = CampusMapViewController
    
    func makeUIViewController(context: Context) -> CampusMapViewController{
        return CampusMapViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.placeMarker(selectedItem: selectedList)
    }
}
