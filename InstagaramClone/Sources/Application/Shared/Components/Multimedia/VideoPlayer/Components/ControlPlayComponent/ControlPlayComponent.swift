//
//  ControlPlayComponent.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 11/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ControlPlayComponent: View {
    var body: some View {
        Image(systemName: "play.circle.fill")
            .font(.system(size: 40))
            .foregroundColor(.white.opacity(0.8))
            .shadow(radius: 5)
    }
}

#Preview {
    ControlPlayComponent()
}
