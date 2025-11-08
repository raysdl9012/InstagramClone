//
//  ReelEntity.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation

struct ReelEntity: Identifiable {
    var id: UUID
    var userId: String
    var userName: String
    var likes: Int
    var media: MultimediaEntity
}

extension ReelEntity {
    public static var mock: [ReelEntity] = [
        .init(
            id: UUID(),
            userId: "12345",
            userName: "rsdl",
            likes: 1000,
            media: .init(id: UUID(),
                         url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(4).mp4?alt=media&token=51d6e836-9489-435f-b7d4-3584bb2d5bdf",
                         type: .video)),
        
        .init(
            id: UUID(),
            userId: "12345",
            userName: "rsdl",
            likes: 1000,
            media: .init(id: UUID(),
                         url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(5).mp4?alt=media&token=71e4113c-6f4c-4438-a37e-6de9a5e32875",
                         type: .video)),
        
            .init(
                id: UUID(),
                userId: "12345",
                userName: "rsdl",
                likes: 1000,
                media: .init(id: UUID(),
                             url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(3).mp4?alt=media&token=8c4426d1-da69-46c0-8cc3-2d9f635bd9af",
                             type: .video)),
        
            .init(
                id: UUID(),
                userId: "12345",
                userName: "rsdl",
                likes: 1000,
                media: .init(id: UUID(),
                             url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(1).mp4?alt=media&token=9f0f9f12-ecdd-45d5-8385-654033081d33f",
                             type: .video))
    ]
}
