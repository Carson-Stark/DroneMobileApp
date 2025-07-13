//
//  VideoView.swift
//  MAVSDK_Swift_Example
//
//  Created by Carson Stark on 8/11/23.
//

//rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4

import SwiftUI
import MobileVLCKit

struct RTSPPlayerView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let player = VLCMediaPlayer()
        let url = URL(string: "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mp4")!
        let media = VLCMedia(url: url)
        player.media = media
        player.drawable = self
        player.play()
        return player.drawable as? UIView ?? UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

struct VideoView: View {
    var body: some View {
        RTSPPlayerView()
            .frame(width: 300, height: 300)
            .previewLayout(.sizeThatFits)
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}

