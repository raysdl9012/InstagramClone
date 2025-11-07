//
//  ImagesPublicationView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ImagesPublicationView: View {
    
    private let gridLayout: [GridItem] = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: gridLayout, spacing: 8) {
            ForEach(1...20, id: \.self) { index in
                Rectangle()
                    .fill(Color.orange)
                    .aspectRatio(1, contentMode: .fit) // Para que sean cuadrados
            }
        }
    }
}

#Preview {
    ScrollView {
        ImagesPublicationView()
    }.padding()
    
}
