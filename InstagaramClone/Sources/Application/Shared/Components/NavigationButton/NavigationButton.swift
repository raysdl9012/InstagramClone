//
//  NavigationButton.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 5/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
    var text: String
    var isDisable: Bool
    var secondary = false
    let destination: Destination
    
    init(text: String,
         isDisable: Bool,
         secondary: Bool = false,
         @ViewBuilder destination: () -> Destination) {
        self.text = text
        self.destination = destination()
        self.secondary = secondary
        self.isDisable = isDisable
    }
    
    var body: some View {
        if secondary {
            NavigationLink(destination: destination) {
                Text(text)
                    .font(.headline)
                    .foregroundColor(isDisable ? .black : .white)
                    .secondaryButtonStyle(isDisable: isDisable)
            }
            .padding(.top, 15)
            .disabled(isDisable)
        } else {
            NavigationLink(destination: destination) {
                Text(text)
                    .font(.headline)
                    .foregroundColor(isDisable ? .black : .white)
                    .primaryButtonStyle(isDisable: isDisable)
            }
            .padding(.top, 15)
            .disabled(isDisable)
        }
        
    }
}


struct NavigationButton_Preview: View {
    var body: some View {
        NavigationButton(text: "Vista", isDisable: false) {
            
        }
    }
}

#Preview {
    NavigationButton_Preview().padding(10)
}
