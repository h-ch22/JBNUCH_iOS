//
//  PhotoPicker.swift
//  JBNU-CH
//
//  Created by 하창진 on 2021/12/28.
//

import Foundation
import PhotosUI
import SwiftUI

struct PhotoPicker : UIViewControllerRepresentable{
    @Binding var isPresented : Bool
    @ObservedObject var mediaItems : PickedMediaItems
    
    typealias UIViewControllerType = PHPickerViewController
    var didFinishPicking : (_ didSelectItems : Bool) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with : self)
    }
    
    class Coordinator : PHPickerViewControllerDelegate{
        var photoPicker : PhotoPicker

        init(with photoPicker : PhotoPicker){
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else{
                return
            }
            
            for result in results{
                let itemProvider = result.itemProvider
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first , let utType = UTType(typeIdentifier) else{return}
                
                self.getPhoto(from : itemProvider, typeIdentifier: typeIdentifier, currentIndex : results.firstIndex(of: result) ?? 0, imageIndex : results.count)
            }
        }
        
        private func getPhoto(from itemProvider : NSItemProvider, typeIdentifier : String, currentIndex : Int, imageIndex : Int){
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier){url, error in
                if let error = error{
                    print(error)
                    self.photoPicker.isPresented = false

                    return
                }
                
                guard let url = url else{return}
                
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentDirectory?.appendingPathComponent(url.lastPathComponent) else{return}

                do{
                    if FileManager.default.fileExists(atPath: targetURL.path){
                        try FileManager.default.removeItem(at: targetURL)
                    }

                    try FileManager.default.copyItem(at: url, to: targetURL)

                    DispatchQueue.main.async{
                        self.photoPicker.mediaItems.append(item:PhotoPickerModel(with: targetURL))
                        
                        if self.photoPicker.mediaItems.items.count == imageIndex{
                            self.photoPicker.didFinishPicking(true)
                            self.photoPicker.isPresented = false
                        }
                    }
                                        
                }  catch{print(error)}
                
            }
        }
    }
}
