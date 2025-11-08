//
//  ReelsView.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ReelsView: View {
    
    @StateObject var viewModel: ReelsViewModel = ReelsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                ScrollView{
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.reels) { reel in
                            ReelsCard(reel: reel)
                        }
                    }
                }
                
                VStack {
                    Text("Reels!!  🎊")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .pink, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.top, 15)
                    Spacer()
                }   
            }
            .background(.black)
        }
    }
}

#Preview {
    ReelsView()
        .environmentObject(VideoControlViewModel())
}
