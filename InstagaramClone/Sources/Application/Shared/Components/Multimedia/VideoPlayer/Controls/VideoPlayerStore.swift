//
//  VideoPlayerStore.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 11/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//

import Foundation
internal import Combine

final class VideoPlayerStore: ObservableObject {
    
    static let shared = VideoPlayerStore()
    private var cache: [URL: VideoPlayerManager] = [:]
    private var cleanTimer: Timer?
    
    init () {
        if cache.count > 15 {
            startAutoClean(interval: 60)
        }
    }
    
    func manager(for url: URL) -> VideoPlayerManager {
        if let existing = cache[url] {
            return existing
        } else {
            let manager = VideoPlayerManager(videoURL: url)
            cache[url] = manager
            return manager
        }
    }
    
    /// Inicia un temporizador que limpia automáticamente cada cierto intervalo
    func startAutoClean(interval: TimeInterval) {
        cleanTimer?.invalidate()
        cleanTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.clearUnused()
            }
        }
    }
    
    // Limpia los managers que no estén reproduciendo
    func clearUnused() {
        let beforeCount = cache.count
        cache = cache.filter { $0.value.isPlaying }
        let afterCount = cache.count
        print("🧹 Limpieza ejecutada — antes: \(beforeCount), después: \(afterCount)")
    }
    
    /// Detiene la limpieza automática (si la necesitas)
    func stopAutoClean() {
        cleanTimer?.invalidate()
        cleanTimer = nil
    }
}
