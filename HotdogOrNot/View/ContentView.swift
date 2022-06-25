//
//  ContentView.swift
//  HotdogOrNot
//
//  Created by Ryan J. W. Kim on 2022/06/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var image: CGImage?
    private let label = Text("Camera feed")
    var session = AVCaptureSession()
    @State var showLabel = false
    
    @State var classifier = Classifier()
    
    @StateObject private var vm = ContentViewModel()
    
    var body: some View {
        ZStack {
            FrameView(image: vm.frame)
                .edgesIgnoringSafeArea(.all)
            ErrorView(error: vm.error)
            VStack {
                Spacer()
                
                Label {
                    Text(classifier.results == "hot dog" ? "Hotdog!" : "Not Hotdog!")
                } icon: {
                    Image(systemName: classifier.results == "hot dog" ? "o.circle" : "x.circle")
                }
                .foregroundColor(classifier.results == "hot dog" ? .green : .red)
                .font(.title)
//                .hidden()
                Button {
                    if vm.frame != nil {
                        guard let image = vm.frame else { return }
                        classifier.detect(cgImage: image)
                    }
                    print(classifier.results)
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
//    func runML(cgImage: CGImage?) {
//        guard let cgImage = image else { fatalError() }
//        classifier.detect(cgImage: cgImage)
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
