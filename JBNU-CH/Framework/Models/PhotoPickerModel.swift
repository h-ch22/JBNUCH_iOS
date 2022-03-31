//
//  PhotoPickerModel.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import Foundation
import SwiftUI
import Photos

struct PhotoPickerModel : Identifiable, Hashable{
    enum MediaType{
        case photo, video, livePhoto
    }
    
    var id : String
    var mediaType : MediaType = .photo
    var url : URL?
    var photo : UIImage?
    
    init(with url : URL){
        id = UUID().uuidString
        mediaType = .photo
        self.url = url
        
        if let data = try? Data(contentsOf : url){
            photo = UIImage(data : data)
        }
    }
}
