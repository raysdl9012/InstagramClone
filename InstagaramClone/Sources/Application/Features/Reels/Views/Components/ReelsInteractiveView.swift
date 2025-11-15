//
//  ReelsInteractiveView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ReelsInteractiveView: View {
    var reel: ReelEntity
    let userLike: Bool
    var reelComments: Int = 0
    var onLike: () -> Void = { }
    var onComment: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            VStack(spacing: 8) {
                Button(action: {
                    onLike()
                }) {
                    if userLike {
                        Image(systemName: "heart.fill")
                            .font(Font.system(size: 30))
                            .foregroundColor(.red)
                    }else {
                        Image(systemName: "heart")
                            .font(Font.system(size: 30))
                            .foregroundColor(.white)
                    }
                }
                
                Text("\(reel.likes.count)")
                    .foregroundStyle(.white)
            }
            .padding(.top, 20)
            .padding(.horizontal, 5)
            
            VStack(spacing: 8) {
                Button(action: {
                    onComment()
                }) {
                    Image(systemName: "message")
                        .font(Font.system(size: 30))
                        .foregroundColor(.white)
                }
                
                Text("\(reelComments)")
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 5)
        }
        .background(.black.opacity(0.3))
        .clipShape(Capsule())
        
        
    }
}

#Preview {
    ReelsInteractiveView(reel: ReelEntity.mock[0], userLike: true)
}
