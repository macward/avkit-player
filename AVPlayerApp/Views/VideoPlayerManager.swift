//
//  VideoPlayerManager.swift
//  AVPlayerApp
//
//  Created by Max Ward on 29/07/2023.
//

import Foundation
import Combine
import AVKit

class VideoPlayerManager: ObservableObject {
    
    enum PlayerState {
        case idle
        case playing
        case paused
    }
    
    private var player: AVPlayer
    private var subscriptions = Set<AnyCancellable>()
    private var timeObserver: Any?
    
    @Published var state: PlayerState = .idle
    @Published var progress: Int = 0
    
    init(player: AVPlayer = AVPlayer()) {
        self.player = player
    }
    
    func play() {
        if state == .playing { return }
        player.play()
        state = .playing
    }
    
    func pause() {
        player.pause()
        state = .paused
    }
    
    func playerInstance() -> AVPlayer {
        return player
    }
    
    func playMedia(at url: URL) {
        state = .idle
        let asset = AVAsset(url: url)
        
        let playerItem = AVPlayerItem(
            asset: asset,
            automaticallyLoadedAssetKeys: [.duration])
        
        removePeriodicTimeObserver()
        self.player.replaceCurrentItem(with: playerItem)
        addPeriodicTimeObserver()
        
        playerItem.publisher(for: \.status)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { status in
                switch status {
                case .readyToPlay:
                    print("ready to play")
                    self.play()
                case .failed:
                    print("cant load data")
                case .unknown:
                    break
                @unknown default:
                    break
                }
            }
            .store(in: &subscriptions)
    }
    
    private func addPeriodicTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 1000)
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            let totalDuration = self.player.currentItem?.duration.seconds ?? 0
            guard !(totalDuration.isNaN || totalDuration.isInfinite) else {
                return
            }
            let progress = Int((time.seconds * 100) / totalDuration)
            if self.progress < 100 {
                self.progress = progress
            } else if progress == 100 {
                self.progress = 0
            }
        }
    }
    
    private func removePeriodicTimeObserver() {
        guard let timeObserver else { return }
        player.removeTimeObserver(timeObserver)
        self.timeObserver = nil
        self.progress = 0
    }
}
