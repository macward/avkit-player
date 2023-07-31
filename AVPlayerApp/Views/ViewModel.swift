//
//  ViewModel.swift
//  AVPlayerApp
//
//  Created by Max Ward on 29/07/2023.
//


import AVKit
import Combine

class ViewModel: ObservableObject {
    
    private var player = VideoPlayerManager()
    
    @Published var queue: [URL] = MockData.items
    @Published var currentPlayQueueIndex: Int = -1
    @Published var currentPlay: AVPlayerItem?
    @Published var isPlaying: Bool = false
    @Published var videoProgress: Int = 0
    
    private var subcriptions = Set<AnyCancellable>()
    
    var playerInstance: AVPlayer {
        return player.playerInstance()
    }
    
    var state: VideoPlayerManager.PlayerState {
        return player.state
    }
    
    init() {
        self.addSubscribers()
    }
    
    func configure() {
        currentPlayQueueIndex = .zero
    }
    
    func addSubscribers() {
        $currentPlayQueueIndex
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                if newValue < 0 { return }
                self.player.playMedia(at: self.queue[newValue])
            }
            .store(in: &subcriptions)
        
        player.$state
            .receive(on: DispatchQueue.main)
            .sink { newValue in
                print(newValue)
                switch newValue {
                case .paused:
                    self.isPlaying.paused()
                case .playing:
                    self.isPlaying.playing()
                case .idle:
                    print("waiting...")
                }
            }
            .store(in: &subcriptions)
        
        player.$progress
            .receive(on: DispatchQueue.main)
            .sink { progress in
                print("play progress of index \(self.currentPlayQueueIndex) is \(progress)")
                self.videoProgress = progress
            }
            .store(in: &subcriptions)
        
        $videoProgress
            .receive(on: DispatchQueue.main)
            .sink { progress in
                if progress == 100 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.playNext()
                    }
                }
            }
            .store(in: &subcriptions)
    }
    
    func togglePlay() {
        player.state == .playing ? self.pause() : self.play()
    }
    
    func play() {
        player.play()
    }
    
    func playNext() {
        if currentPlayQueueIndex == (queue.count - 1) { return }
        currentPlayQueueIndex.increase()
    }
    
    func playPrev() {
        if currentPlayQueueIndex == 0 { return }
        currentPlayQueueIndex.decrease()
        self.videoProgress = 0
    }
    
    func pause() {
        player.pause()
    }
    
}
