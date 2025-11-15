//
//  VideoPlayerManager.swift
//  InstagaramClone
//
//  Created by Reinner Steven Daza Leiva on 7/11/25.
//  Copyright © 2025 rsdl. All rights reserved.
//
import UIKit
import AVFoundation
internal import Combine


class VideoPlayerManager: ObservableObject, Equatable {
    
    private let player: AVPlayer
    
    static func == (lhs: VideoPlayerManager, rhs: VideoPlayerManager) -> Bool {
        lhs.player == rhs.player
    }
    
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var totalDuration: Double = 0
    @Published var videoAspectRatio: CGFloat = UIScreen.screenWidth / (UIScreen.screenHeight - 110)
    
    init(videoURL: URL) {
        self.player = AVPlayer(url: videoURL)
        let asset = AVAsset(url: videoURL)
        Task {
            configureAudioSession()
            self.setupPlayerObservers()
            await self.loadDurationTime(asset: asset)
            await self.loadVideoAspectRatio(asset: asset)
        }
    }
    
    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("⚠️ Error configurando AVAudioSession: \(error.localizedDescription)")
        }
    }
    
    public func getPlayer() -> AVPlayer {
        player
    }
    
    public func pause() {
        player.pause()
    }
    
    public func play() {
        player.play()
    }
    
    public func seek(time: CMTime){
        player.seek(to: time)
    }
    
    private func setupPlayerObservers() {
        let time = CMTime(seconds: 0.1, preferredTimescale: 500)
        player.addPeriodicTimeObserver(forInterval: time, queue: .main) { time in
            self.currentTime = CMTimeGetSeconds(time)
        }
    }
    
    private func loadDurationTime(asset: AVAsset) async {
        do {
            let duration = try await asset.load(.duration)
            await MainActor.run {
                self.totalDuration = duration.seconds
            }
        } catch {
            await MainActor.run {
                self.totalDuration = 0.0
            }
        }
    }
    
    private func loadVideoAspectRatio(asset: AVAsset) async {
        guard videoAspectRatio == 1.0 else { return }
        do {
            let tracks = try await asset.load(.tracks)
            guard  let videoTrack = tracks.first(where: { $0.mediaType == .video }) else {
                fatalError("Error process video")
            }
            let size = try await videoTrack.load(.naturalSize)
            let aspectRatio = size.height == 0 ? 1.0 : size.width / size.height
            await MainActor.run {
                videoAspectRatio = aspectRatio > 0.55 ? 0.8 : aspectRatio
            }
        }catch {
            await MainActor.run {
                videoAspectRatio = 1.0
            }
        }
    }
    
}

