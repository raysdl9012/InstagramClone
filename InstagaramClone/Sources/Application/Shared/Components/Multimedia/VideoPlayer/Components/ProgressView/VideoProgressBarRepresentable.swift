//
//  CustomThumbSlider.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 10/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import UIKit

struct VideoProgressBarRepresentable: UIViewRepresentable {
    // 1. Binding para el valor actual (ej: currentTime)
    @Binding var value: Double
    
    // 2. Rango del Slider (ej: 0 y totalDuration)
    let minValue: Double
    let maxValue: Double
    // 3. Personalización del Thumb (tamaño)
    var thumbSize: CGSize
    var tinColor: UIColor = .purple
    
    // 4. Action para el arrastre (ej: actionDragginMove)
    var onEditingChanged: ((Bool) -> Void)? = nil
    
    // --- makeUIView (Crea el control de UIKit) ---
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.tintColor = tinColor
        slider.minimumValue = Float(minValue)
        slider.maximumValue = Float(maxValue)
        
        // Configurar los Targets (acciones)
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged),
            for: .valueChanged
        )
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingDidBegin),
            for: .touchDown // Inicio del arrastre
        )
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingDidEnd),
            for: [.touchUpInside, .touchUpOutside]
        )
        
        // 🛑 CRÍTICO: Aplicar la imagen personalizada para el Thumb
        slider.setThumbImage(thumbImage(), for: .normal)
        slider.setThumbImage(thumbImage(), for: .highlighted)
        
        return slider
    }
    
    // --- updateUIView (Actualiza el control de UIKit desde SwiftUI) ---
    func updateUIView(_ uiView: UISlider, context: Context) {
        // Actualiza el valor de la barra
        uiView.value = Float(value)
        // Asegura que el rango se actualice si la duración cambia dinámicamente
        uiView.maximumValue = Float(maxValue)
    }
    
    // --- makeCoordinator ---
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // --- Generador de la Imagen del Thumb ---
    private func thumbImage() -> UIImage? {
        // Genera una imagen simple (un círculo blanco) del tamaño especificado
        let size = thumbSize
        // Thumb por defecto
        guard size.width > 0 && size.height > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.white.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // --- Coordinator (Maneja los eventos de UIKit) ---
    class Coordinator: NSObject {
        var parent: VideoProgressBarRepresentable
        
        init(parent: VideoProgressBarRepresentable) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            // Actualiza el Binding $value mientras se arrastra
            parent.value = Double(sender.value)
        }
        
        @objc func editingDidBegin(_ sender: UISlider) {
            // Llama a onEditingChanged(true) al inicio del arrastre
            parent.onEditingChanged?(true)
        }
        
        @objc func editingDidEnd(_ sender: UISlider) {
            // Llama a onEditingChanged(false) al soltar el thumb
            parent.onEditingChanged?(false)
        }
    }
}
