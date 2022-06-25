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
    
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        ZStack {
            FrameView(image: vm.frame)
                .edgesIgnoringSafeArea(.all)
            ErrorView(error: vm.error)
            VStack {
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Hotdog?")
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .foregroundColor(.black)
                .background(.white)
                .animation(.easeInOut, value: 0.25)
                .cornerRadius(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
