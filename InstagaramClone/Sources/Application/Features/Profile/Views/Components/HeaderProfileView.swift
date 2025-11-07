//
//  HeaderProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct HeaderProfileView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .foregroundColor(.gray)
            
            Spacer()

            HStack(spacing: 24) {
                VStack {
                    Text("123")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.indigo)
                    Text("Publicaciones")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
                VStack {
                    Text("891")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.indigo)
                    Text("Seguidos")
                        .font(.caption)
                        .foregroundStyle(.purple)
                }
            }
        }
    }
}

#Preview {
    HeaderProfileView()
}
