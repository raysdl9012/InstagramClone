//
//  CumtomButtonRegisterView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct CustomButtonRegister: View {
    var title: String
    var isDisable: Bool
    var secondary = false
    var onClick: () -> Void
    var body: some View {
        
        if secondary {
            Button {
                onClick()
            } label: {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isDisable ? .black : .white)
                    
            }
            
            .secondaryButtonStyle(isDisable: isDisable)
        }else {
            Button {
                onClick()
            } label: {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isDisable ? .black : .white)
                    
            }
            .primaryButtonStyle(isDisable: isDisable)
        }
    }
}

#Preview {
    CustomButtonRegister(title: "Register",
                         isDisable: false){}.padding(10)
}
