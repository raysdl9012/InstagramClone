//
//  ErrorLoadPostView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ErrorLoadPostView: View {
    var message: String
    var onReload: () -> Void
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(message)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.orange)
            Button("Reintentar") {
                onReload()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    ErrorLoadPostView(message: "Error load post"){
        
    }
}
