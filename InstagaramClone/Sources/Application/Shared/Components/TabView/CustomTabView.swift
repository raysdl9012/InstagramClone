//
//  CustomTabView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedIndex = 0
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView().tabItem {
                Label("Home", systemImage: "house")
            }
            HomeView().tabItem {
                Label("Reels", systemImage: "video")
            }
            ProfileView().tabItem {
                Label("Profile", systemImage: "person")
            }
        }
        .tint(Color.indigo)
    }
}

#Preview {
    NavigationStack {
        CustomTabView()
    }
    
}
