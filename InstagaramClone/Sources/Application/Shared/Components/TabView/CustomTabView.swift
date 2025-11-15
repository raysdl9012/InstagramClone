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
    @StateObject private var videoPostViewModel = VideoControlViewModel()
    @StateObject private var viewModelComments = CommentViewModel()

    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView().tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(0)
            .environmentObject(viewModelComments)
            
            ReelsView().tabItem {
                Label("Reels", systemImage: "video")
            }
            .tag(1)
            .environmentObject(viewModelComments)
            
            ProfileView().tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(2)
            
        }
        .tint(Color.indigo)
        .environmentObject(videoPostViewModel)
        
    }
}

#Preview {
    NavigationStack {
        CustomTabView()
    }
    
}
