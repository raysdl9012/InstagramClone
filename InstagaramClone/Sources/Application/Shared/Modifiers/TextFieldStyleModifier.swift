//
//  CardModifier
//  
//
//  Created by Reinner Steven Daza Leiva on 2025/11/05.
//

import Foundation
import SwiftUI

struct TextFieldStyleModifier: ViewModifier {
    @FocusState public var isFocused: Bool
    func body(content: Content) -> some View {
        content
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isFocused ? Color.blue : Color.gray.opacity(0.4),
                            lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.clear)
                    )
            )
            .focused($isFocused)
            .font(.body)
            .textInputAutocapitalization(.none)
            .disableAutocorrection(true)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .textInputAutocapitalization(.never)
    }
}
