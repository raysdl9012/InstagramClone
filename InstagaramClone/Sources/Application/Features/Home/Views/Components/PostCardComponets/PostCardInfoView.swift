//
//  PostCardInfoView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct PostCardInfoView: View {
    var post: PostEntity
    var body: some View {
        HStack() {
            Text("\(post.likes.count) Me gusta")
                .font(.footnote)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}

#Preview {
    PostCardInfoView(post: PostEntity.mock.first!)
}
