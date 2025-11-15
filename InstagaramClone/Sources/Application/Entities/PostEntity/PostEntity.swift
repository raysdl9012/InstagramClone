//
//  PostEntity.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import Foundation



struct PostEntity: Identifiable, Codable {
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

extension PostEntity {
    public static let mock: [PostEntity] = [
        .init(ownerId: "5fLCG6KgadWwzqxkBdQxvyxM9Ss2",
              likes: [],
              media: MultimediaEntity(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE2UBdlY6dIVzEyhbm8oEOngfaxnOtmQ0seA&s", type: .image, aspectRatio: 16/9)),
        .init(ownerId: "AYRv5rPHouUMngfO43ttvaSws1y2", likes: [],
              media: MultimediaEntity(url: "https://images.unsplash.com/photo-1564754943164-e83c08469116?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8dmVydGljYWx8ZW58MHx8MHx8fDA%3D&fm=jpg&q=60&w=3000", type: .image, aspectRatio: 9/16))
        

    ]
}
