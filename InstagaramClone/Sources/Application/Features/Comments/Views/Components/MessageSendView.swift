//
//  MessageSendView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 14/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct MessageSendView: View {
    
    var media: MultimediaEntity
    @Binding var message: String
    var onSend: () -> Void = { }
    
    var body: some View {
        HStack(alignment: .center, spacing: 10){
            RemoteImageView(media: media)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .foregroundColor(.gray)
            
            CustomTextFieldRegister(type: .text,
                                    placeholder: "Comment",
                                    text: $message)
            
            
            Button {
                onSend()
            } label: {
                Image(systemName: "paperplane")
                    .padding(5)
            }
        }
        .padding(10)
    }
}

#Preview {
    MessageSendView(media: PostEntity.mock[0].media,
                    message: .constant(""))
}
