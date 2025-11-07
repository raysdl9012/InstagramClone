//
//  PostEntity.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import Foundation

enum MultimediaType {
    case video, image
}

struct PostEntity: Identifiable {
    var id: UUID
    var userId: String
    var userName: String
    var likes: Int
    var media: MultimediaEntity
}

struct MultimediaEntity: Identifiable {
    var id: UUID
    var url: String
    var type: MultimediaType
    
    public func getVideoURL() -> URL? {
        guard let url = URL(string: url) else {
            return nil
        }
        return url
    }
}

extension PostEntity {
    public static let mock: [PostEntity] = [
        .init(id: UUID(),
              userId: "",
              userName: "Petro",
              likes: 10,
              media: .init(id: UUID(),
                           url: "logo",
                           type: .image)),
        .init(id: UUID(),
              userId: "",
              userName: "Angela",
              likes: 4,
              media: .init(id: UUID(),
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/un_logo_de_empresa_usando_claros_enfocado.mp4?alt=media&token=a5ffa903-d30b-4ca7-88b2-f52842ab2ae3",
                           type: .video)),
        .init(id: UUID(),
              userId: "",
              userName: "Mauricio",
              likes: 9,
              media: .init(id: UUID(),
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/feb759a2-c018-443e-afff-9c2aba5e2fe3.MP4?alt=media&token=805f8ffc-ecfa-4964-ab33-1c8a109292d7",
                           type: .video)),
        .init(id: UUID(),
              userId: "",
              userName: "Camila",
              likes: 7,
              media: .init(id: UUID(),
                           url: "logo",
                           type: .image)),
        .init(id: UUID(),
              userId: "",
              userName: "Andrea",
              likes: 13,
              media: .init(id: UUID(),
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/feb759a2-c018-443e-afff-9c2aba5e2fe3.MP4?alt=media&token=805f8ffc-ecfa-4964-ab33-1c8a109292d7",
                           type: .video)),
    ]
}
