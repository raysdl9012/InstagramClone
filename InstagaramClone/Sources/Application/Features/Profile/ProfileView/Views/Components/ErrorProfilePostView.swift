//
//  ErrorProfilePost.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 12/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ErrorProfilePostView: View {
    var errrorMesasge:String
    var onRefesh: () -> Void = { }
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
            Text(errrorMesasge)
                .multilineTextAlignment(.center)
            Button("Reintentar") {
                onRefesh()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.top, 50)
    }
}

#Preview {
    ErrorProfilePostView(errrorMesasge: "Error load post")
}
