//
//  ReelsCard.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import SwiftUI

struct ReelsCard: View {
    @EnvironmentObject var videoReelsViewModel: VideoControlViewModel
    var reel: ReelEntity
    var body: some View {
        
        if let url = reel.media.getVideoURL(), let manager = reel.media.manager  {
            ZStack(alignment: .topTrailing) {
                CustomVideoPlayer(manager: manager,
                                  videoURL: url,
                                  isFocused: .constant(videoReelsViewModel.videoPlayer == reel.media.id)) {
                    videoReelsViewModel.videoPlayer = reel.media.id
                }
                
                ReelsInteractiveView()
                    .padding(.trailing, 10)
                    .padding(.top, 100)
            }
        }else {
            EmptyView()
                .background(.black)
                .frame(height: UIScreen.screenHeight*0.9)
        }
        
        
    }
}

#Preview {
    ReelsCard(reel: ReelEntity.mock.first!)
}
