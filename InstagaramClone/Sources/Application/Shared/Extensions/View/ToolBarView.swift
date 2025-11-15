//
//  ToolBarView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

extension View {
    func leadingToolbarItem(icon: String = "plus", action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: action) {
                Image(systemName: icon)
            }
        }
    }
    func principalToolbarItem(title: String, size:CGFloat = 35) -> some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(title)
                .font(.system(size: size, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.purple, .pink, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                ).padding()
        }
    }
    
    func trailingToolbarItem(icon: String = "heart.fill", action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: action) {
                Image(systemName: icon)
            }
        }
    }
}
