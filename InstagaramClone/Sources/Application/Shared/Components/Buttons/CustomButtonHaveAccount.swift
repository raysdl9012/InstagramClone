//
//  CustomButtonHaveAccount.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct CustomButtonHaveAccount: View {
    var onClick: () -> Void = { }
    
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text("I have already have an account")
                .font(Font.footnote)
                .foregroundStyle(.blue)
        }
        .padding(.vertical, 10)
        .ignoresSafeArea()
    }
}

#Preview {
    CustomButtonHaveAccount()
}
