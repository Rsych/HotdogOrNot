//
//  ContentView.swift
//  HotdogOrNot
//
//  Created by Ryan J. W. Kim on 2022/06/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    var image: CGImage?
    private let label = Text("Camera feed")
    var session = AVCaptureSession()
    
    var body: some View {
        ZStack {
          FrameView(image: nil)
                .edgesIgnoringSafeArea(.all)

          Text("Filter the World!")
            .foregroundColor(.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
