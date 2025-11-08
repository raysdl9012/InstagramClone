//
//  HomeViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine

class HomeViewModel: ObservableObject {
    
    @Published var posts: [PostEntity] = []
    
    init() {
        self.fetchPosts()
    }
    
    public func fetchPosts() {
        let list = addManagerToVideoPosts(post: PostEntity.mock)
        self.posts = list
    }
    
    private func addManagerToVideoPosts(post: [PostEntity]) -> [PostEntity] {
        let listPost = post.map { post in
            var newPost = post
            guard post.media.type == .video else {
                return post
            }
            guard let url = post.media.getVideoURL() else {
                return post
            }
            newPost.media.manager = VideoPlayerManager(videoID: post.media.id,
                                                       videoURL: url)
            return newPost
        }
        return listPost
    }
}
