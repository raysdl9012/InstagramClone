//
//  VideoControlViewModel.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine

class VideoControlViewModel: ObservableObject {
    @Published var videoPlayer: UUID = UUID()
}
