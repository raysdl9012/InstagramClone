//
//  ReelEntity.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 8/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation

struct ReelEntity: Identifiable, Codable {
    var id: UUID
    var ownerId: String
    var likes: [String]
    var media: MultimediaEntity
    let timestamp: Date
    init(ownerId: String, likes: [String], media: MultimediaEntity) {
        self.id = UUID()
        self.ownerId = ownerId
        self.likes = likes
        self.media = media
        self.timestamp = Date()
    }
}

extension ReelEntity {
    public static var mock: [ReelEntity] = [
        .init(
            ownerId: "12345",
            likes: [""],
            media: .init(id: UUID(),
                         url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(4).mp4?alt=media&token=51d6e836-9489-435f-b7d4-3584bb2d5bdf",
                         type: .video, aspectRatio: 1)),
       
    ]
}
