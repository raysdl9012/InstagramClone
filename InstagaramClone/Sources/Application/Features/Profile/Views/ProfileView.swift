//
//  ProfileView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 6/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HeaderProfileView()
                
                ProfileInfoView()
                
                ButtonsProfileView {
                    
                } onShare: {
                    
                }
                
                ImagesPublicationView()
            }
            .padding(.horizontal, 15)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarItem { }
                principalToolbarItem(title: "Steven", size: 25)
            }
        }
    }
}

#Preview {
    ProfileView()
}
