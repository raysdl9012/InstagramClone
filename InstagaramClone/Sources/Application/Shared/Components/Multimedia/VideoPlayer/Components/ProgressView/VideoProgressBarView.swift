//
//  VideoProgressBarView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI
import AVKit

struct VideoProgressBarView: View {
    
    @Binding var isDragging: Bool
    @Binding var currentTime: Double
    
    let totalDuration: Double
    public var onEditingChanged: ((Bool) -> Void)?
    
    private let size: CGSize = CGSize(width: 10, height: 10)
        
    var body: some View {
        VideoProgressBarRepresentable(
            value: $currentTime,
            minValue: 0,
            maxValue: totalDuration,
            thumbSize: size,
            onEditingChanged: { dragging in
                onEditingChanged?(dragging)
            }
        )
    }
}

#Preview {
    VideoProgressBarView(isDragging: .constant(true),
                         currentTime: .constant(5.0),
                         totalDuration: 10.0)
    .background(Color.black.opacity(0.5))
}
