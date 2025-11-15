//
//  ImagePicker.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import UIKit

struct ImagePickerRepresentable: UIViewControllerRepresentable {
    // 🛑 Variable que define si se usa la cámara o la librería
    var sourceType: UIImagePickerController.SourceType = .camera
    
    // 🛑 Closure para manejar la imagen seleccionada y pasarla de vuelta
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss // Para cerrar el controlador de UIKit
    
    // 1. Crea el controlador de UIKit
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType // Define si es .camera o .photoLibrary
        picker.delegate = context.coordinator // Asigna el delegado
        picker.allowsEditing = true // Opcional: permite recortar
        return picker
    }

    // 2. No se necesita actualizar en este caso
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // 3. Crea el Coordinator para manejar los eventos del delegado (captura/cancelación)
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePickerRepresentable

        init(_ parent: ImagePickerRepresentable) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // 🛑 Obtener la imagen editada o la original
            if let uiImage = info[.editedImage] as? UIImage {
                parent.selectedImage = uiImage
            } else if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
