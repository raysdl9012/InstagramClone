//
//  CustomTextEditView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 13/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct CustomTextEditView: View {
    @Binding var text: String
    @FocusState private var isTextEditorFocused: Bool
    var body: some View {
        TextEditor(text: $text)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isTextEditorFocused ? Color.blue : Color.gray.opacity(0.4),
                            lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.clear)
                    )
            )
            .scrollContentBackground(.hidden)
            .frame(height: 100)
            .font(.body)
            .textInputAutocapitalization(.none)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .focused($isTextEditorFocused)
    }
}

#Preview {
    CustomTextEditView(text: .constant("TextEditor"))
}
