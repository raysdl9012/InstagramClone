//
//  ReelsViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine

class ReelsViewModel: ObservableObject {
    
    @Published var reels: [ReelEntity] = []
    
    init() {
        self.fetchPosts()
    }
    
    public func fetchPosts() {
        let list = addManagerToVideoReels(reel: ReelEntity.mock)
        self.reels = list
    }
    
    private func addManagerToVideoReels(reel: [ReelEntity]) -> [ReelEntity] {
        let listPost = reel.map { post in
            var newPost = post
            guard post.media.type == .video else {
                return post
            }
            guard let url = post.media.getVideoURL() else {
                return post
            }
            newPost.media.manager = VideoPlayerManager(videoID: post.media.id,
                                                       videoURL: url,
                                                       defaultHeight: true)
            return newPost
        }
        return listPost
    }
}
