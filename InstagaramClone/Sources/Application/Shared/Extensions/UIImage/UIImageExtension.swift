//
//  UIImageExtension.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import UIKit

extension UIImage {
    
    func rotated(to orientation: UIImage.Orientation) -> UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: orientation)
    }
    
    func getAspectRatio() -> CGFloat {
        let size = self.size
        let width = size.width
        let height = size.height
        if height == 0 {
            return 1.0
        }
        // Calcular el aspecto ratio (Ancho / Alto)
        let aspectRatio = width / height
        return aspectRatio
    }
    
    func rotated(to radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
            .integral.size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        context.rotate(by: radians)
        draw(in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? self
    }
}
