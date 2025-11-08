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
    let player: AVPlayer?
    let totalDuration: Double
    
    private func actionDragginMove(dragging: Bool) {
        isDragging = dragging
        if !dragging, let player = player {
            let newTime = CMTime(seconds: currentTime, preferredTimescale: 500)
            player.seek(to: newTime)
            player.play()
        }
        if dragging {
            player?.pause()
        }
    }
    
    var body: some View {
        Slider(value: $currentTime, in: 0...totalDuration, onEditingChanged: { dragging in
            actionDragginMove(dragging: dragging)
        })
        .tint(.purple)
        .padding(.horizontal, 10)
        .padding(.bottom, 5)
    }
}

#Preview {
    VideoProgressBarView(isDragging: .constant(false),
                         currentTime: .constant(0.0),
                         player: nil, totalDuration: 10.0)
    .background(Color.black.opacity(0.1))
}
