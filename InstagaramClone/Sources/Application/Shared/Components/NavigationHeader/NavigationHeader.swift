//
//  NavigationHeader.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct NavigationHeader: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .toolbar{
                leadingToolbarItem { }
                principalToolbarItem(title: "Instagram")
                trailingToolbarItem { }
            }
    }
}

#Preview {
    NavigationStack {
        NavigationHeader()
    }
}
