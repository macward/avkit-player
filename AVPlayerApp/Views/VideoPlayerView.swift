//
//  VideoPlayerView.swift
//  AVPlayerApp
//
//  Created by Max Ward on 29/07/2023.
//

import SwiftUI
import UIKit
import AVKit

class VideoPlayerUIView: UIView {
    
    // Override the property to make AVPlayerLayer the view's backing layer.
    // Sobrescribe la propiedad para que AVPlayerLayer sea la capa de respaldo de la vista.
    override static var layerClass: AnyClass { AVPlayerLayer.self }
    
    // A computed property to access the AVPlayerLayer from the view's layer.
    // Una propiedad calculada para acceder a AVPlayerLayer desde la capa de la vista.
    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    
    // A property to get and set the AVPlayer associated with the view.
    // Una propiedad para obtener y establecer el AVPlayer asociado con la vista.
    var player: AVPlayer? {
        get { playerLayer.player }
        set {
            playerLayer.player = newValue
            playerLayer.videoGravity = .resizeAspectFill
        }
    }
    
}

struct VideoPlayerView: UIViewRepresentable {
    
    let player: AVPlayer
    
    func makeUIView(context: Context) -> some UIView {
        let view = VideoPlayerUIView()
        view.player = player
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
}

