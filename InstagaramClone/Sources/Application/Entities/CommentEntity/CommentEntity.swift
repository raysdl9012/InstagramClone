//
//  CommentEntity.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 14/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import Foundation

struct CommentEntity: Identifiable, Codable {
    var id: UUID
    var name: String
    var message: String
    var media: MultimediaEntity
    let timestamp: Date
    let postId: UUID
    init(ownerId: String, name:String,  message:String, media: MultimediaEntity, postId: UUID) {
        self.id = UUID()
        self.name = name
        self.media = media
        self.message = message
        self.timestamp = Date()
        self.postId = postId
    }
}

extension CommentEntity {
    public static let mock: [CommentEntity] = [
        .init(ownerId: "",
              name: "Daniel Carrasco",
              message: "lo mejor de la vida es comer y dormir",
              media: MultimediaEntity(id: UUID(),
                                      url: "https://i.pinimg.com/736x/d5/0a/66/d50a66cea6083f992efd9c3a793586b0.jpg",
                                      type: .image,
                                      aspectRatio: 1),
              postId: UUID()),
        
        .init(ownerId: "",
              name: "Valencia Torres",
              message: "Increíble esta vista desde el cielo, lo mejor de la vida es comer y dormir",
              media: MultimediaEntity(id: UUID(),
                                      url: "https://media.craiyon.com/2025-10-02/M0oPBM1_Ri2r1zbHpV8zFw.webp",
                                      type: .image,
                                      aspectRatio: 1),
              postId: UUID())
        

    ]
}
