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
    @State private var selectedReelId: UUID?
    var body: some View {
        NavigationStack {
            ZStack(alignment: .center) {
                TabView(selection: $selectedReelId){
                    ForEach(viewModel.reels) { reel in
                        ReelsCard(reel: reel)
                            .tag(reel.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .ignoresSafeArea()
                .onAppear {
                    if selectedReelId == nil,
                       let firstReel = viewModel.reels.first {
                        selectedReelId = firstReel.id
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
        .refreshable {
            viewModel.fetchReels()
        }
        .task {
            if viewModel.reels.isEmpty{
                viewModel.fetchReels()
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    ReelsView()
        .environmentObject(VideoControlViewModel())
}
