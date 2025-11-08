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
    var manager: VideoPlayerManager?
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
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback.mp4?alt=media&token=8adcd820-cb8b-415a-8048-5a0b659f6193",
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
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/Download.mp4?alt=media&token=4714c48e-861b-4ce8-ab4d-f69e539ddc50",
                           type: .video)),
        .init(id: UUID(),
              userId: "",
              userName: "Marco",
              likes: 13,
              media: .init(id: UUID(),
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback.mp4?alt=media&token=bc88fbc1-c217-4126-96e4-9a686d2ffb21",
                           type: .video)),
        .init(id: UUID(),
              userId: "",
              userName: "Marvel",
              likes: 13,
              media: .init(id: UUID(),
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(2).mp4?alt=media&token=d838859d-475d-49a5-8432-9462988fbee9",
                           type: .video)),
        .init(id: UUID(),
              userId: "",
              userName: "El tiempho",
              likes: 13,
              media: .init(id: UUID(),
                           url: "https://firebasestorage.googleapis.com/v0/b/instagramclone-2d24e.firebasestorage.app/o/videoplayback%20(1).mp4?alt=media&token=9f0f9f12-ecdd-45d5-8385-654033081d33",
                           type: .video)),
    ]
}
