//
//  PickedMdeiaItems.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import Foundation

class PickedMediaItems : ObservableObject{
    @Published var items = [PhotoPickerModel]()
    
    func append(item : PhotoPickerModel){
        items.append(item)
    }
    
    
}
