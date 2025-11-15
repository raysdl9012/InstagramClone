//
//  SheetShare.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

// Esta estructura actúa como un puente entre SwiftUI y UIKit.
struct ActivityViewController: UIViewControllerRepresentable {
    
    // 🛑 Los datos que quieres compartir (texto, imagen, URL).
    var activityItems: [Any]
    
    // Opcional: El array de tipos de actividad que quieres excluir.
    var applicationActivities: [UIActivity]? = nil
    
    // 1. Crea y configura el UIActivityViewController
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    // 2. No se necesita actualizar nada, pero el método es requerido
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No se necesita implementación para el uso de compartir simple.
    }
}
