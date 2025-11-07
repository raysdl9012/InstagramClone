//
//  SkeletonRegister.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct SkeletonRegister<Content: View, Footer: View>: View {
    let content: Content
    let footer: Footer
    var title: String
    var Description: String
    var onBack: () -> Void
    
    init(title: String,
         description: String,
         @ViewBuilder
         content: () -> Content,
         footer: () -> Footer = { EmptyView() },
         onBack: @escaping () -> Void = {}) {
        self.title = title
        self.Description = description
        self.content = content()
        self.footer = footer()
        self.onBack = onBack
    }
    
    var body: some View {
        VStack {
            CustomBackButton() {
                onBack()
            }
            ScrollView {
                VStack( alignment: .leading, spacing: 15) {
                    Text(title)
                        .font(Font.title)
                        .fontWeight(.semibold)
                        .contentShape(Rectangle())
                    Text(Description)
                        .font(Font.callout)
                    content
                }
            }
            Spacer()
            footer
        }
        .padding(.horizontal, 15)
    }
}

struct SkeletonRegister_Preview: View {
    var body: some View {
        SkeletonRegister(title: "Title for register",
                         description:"this is a description for register") {
            Text("Hola mundo")
        } footer: {
            Button {
                
            } label: {
                Text("I have already have an account")
                    .font(Font.footnote)
                    .foregroundStyle(.blue)
            }
            .padding(.vertical, 10)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SkeletonRegister_Preview()
}
