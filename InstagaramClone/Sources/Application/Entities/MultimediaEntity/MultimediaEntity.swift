//
//  MultimediaEntitty.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 11/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation


enum MultimediaType: Codable {
    case video, image
}

struct MultimediaEntity: Identifiable, Codable {
    var id: UUID = UUID()
    var url: String
    var type: MultimediaType
    var aspectRatio: CGFloat
    public func getMultimediaURL() -> URL? {
        guard let url = URL(string: url) else {
            return nil
        }
        return url
    }
}
