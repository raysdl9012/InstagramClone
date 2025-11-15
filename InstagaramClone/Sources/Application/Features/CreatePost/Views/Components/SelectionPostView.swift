//
//  SelectionPostView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct SelectionPostView: View {
    
    @Binding var typePost: TypeCreatePost
    
    var body: some View {
        HStack(alignment: .center,  spacing: 40) {
            Button {
                typePost = .post
            } label: {
                Text("Post")
                    .foregroundStyle((typePost == .post ? .yellow :  .white))
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            
            
            Button {
                typePost = .reel
            } label: {
                Text("Reels")
                    .foregroundStyle((typePost == .reel ? .yellow :  .white))
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            
        }
        .padding(10)
        .background(Color.black.opacity(0.6))
        .clipShape(Capsule())
    }
}

#Preview {
    SelectionPostView(typePost: .constant(.reel))
}
