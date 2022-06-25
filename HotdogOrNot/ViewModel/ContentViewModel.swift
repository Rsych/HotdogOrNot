//
//  ContentViewModel.swift
//  HotdogOrNot
//
//  Created by Ryan J. W. Kim on 2022/06/25.
//

import CoreImage

class ContentViewModel: ObservableObject {
    @Published var frame: CGImage?
    @Published var error: Error?
    
    private let cameraManager = CameraManager.shared
    private let frameManager = FrameManager.shared
    
    init() {
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        frameManager.$current
            .receive(on: RunLoop.main)
            .compactMap { buffer in
                return CGImage.create(from: buffer)
            }
            .assign(to: &$frame)
        
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)
    }
}
