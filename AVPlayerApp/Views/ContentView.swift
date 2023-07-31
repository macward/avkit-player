//
//  ContentView.swift
//  AVPlayerApp
//
//  Created by Max Ward on 29/07/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            Color("Background")
                .ignoresSafeArea()
            VStack {
                VideoPlayerView(player: viewModel.playerInstance)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(color: .black, radius: 10, x: 2, y: 2)
                    .overlay{
                        self.progressBar(progress: viewModel.videoProgress)
                    }
                    .onTapGesture {
                        self.viewModel.togglePlay()
                    }
                HStack (spacing: 30) {
                    controlButton("backward.circle.fill", action: viewModel.playPrev)
                    HStack {
                        controlButton("gobackward.10", action: viewModel.play)
                        controlButton(viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill", action: viewModel.togglePlay)
                        controlButton("goforward.10", action: viewModel.play)
                    }
                    controlButton("forward.circle.fill", action: viewModel.playNext)
                    
                }
                .padding(.top)
            }
            .background(Color("Background"))
            .padding()
            .onAppear() {
                viewModel.configure()
            }
        }
    }
    
    @ViewBuilder
    func progressBar(progress: Int) -> some View {
        VStack {
            GeometryReader { proxy in
                let frame = proxy.frame(in: .local)
                let actualWidth = ((CGFloat(progress)) * frame.maxX) / 100
                let barHeight: CGFloat = 5.0
                let paddingBottom: CGFloat = 8.0
                
                RoundedRectangle(cornerRadius: barHeight)
                    .fill(.white.opacity(0.2))
                    .frame(width: frame.size.width,height: barHeight)
                    .position(x: frame.midX,
                              y: frame.size.height - paddingBottom)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.6))
                    .frame(width: actualWidth, height: barHeight)
                    .position(x: frame.minX + (actualWidth / 2),
                              y: frame.size.height - paddingBottom)
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func controlButton(_ image: String, action: @escaping () -> ()) -> some View {
        Button(action: action, label: {
            Image(systemName: image)
                .foregroundStyle(.gray)
                .font(.largeTitle)
        })
    }
}

#Preview {
    ContentView()
}
