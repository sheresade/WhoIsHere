//
//  Coordinator.swift
//  WhoisHere
//
//  Created by carolyne on 10/02/2020.
//  Copyright © 2020 carolyne. All rights reserved.
//

import Foundation
import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var imageInPicker: UIImage?
    
    init(isShown: Binding<Bool>, image: Binding<Image?>, uiImage :Binding<UIImage?>) {
        _isCoordinatorShown = isShown
        _imageInCoordinator = image
        _imageInPicker = uiImage

    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:
                                [UIImagePickerController.InfoKey : Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageInPicker = unwrapImage
        imageInCoordinator = Image(uiImage: unwrapImage)
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}
