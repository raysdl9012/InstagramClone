//
//  ReelsInteractiveView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ReelsInteractiveView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            VStack(spacing: 8) {
                Button(action: {
                    
                }) {
                    Image(systemName: "heart")
                        .font(Font.system(size: 30))
                        .foregroundColor(.white)
                }
                
                Text("123")
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 8) {
                Button(action: {
                    
                }) {
                    Image(systemName: "message")
                        .font(Font.system(size: 30))
                        .foregroundColor(.white)
                }
                
                Text("10")
                    .foregroundStyle(.white)
            }
            
            VStack(spacing: 8) {
                Button(action: {
                    
                }) {
                    Image(systemName: "paperplane")
                        .font(Font.system(size: 30))
                        .foregroundColor(.white)
                }
                
                Text("63")
                    .foregroundStyle(.white)
            }
        }

    }
}

#Preview {
    ReelsInteractiveView()
        .background(.black)
}
