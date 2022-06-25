//
//  Classifier.swift
//  HotdogOrNot
//
//  Created by Ryan J. W. Kim on 2022/06/26.
//

import CoreML
import CoreImage
import Vision
import UIKit

struct Classifier {
    var results: String?
    
    func convertImage(image: CGImage) -> CVPixelBuffer? {
        
        let newSize = CGSize(width: 224.0, height: 224.0)
        UIGraphicsBeginImageContext(newSize)
        
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        // convert to pixel buffer
        
        let attributes = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                  kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(newSize.width),
                                         Int(newSize.height),
                                         kCVPixelFormatType_32ARGB,
                                         attributes,
                                         &pixelBuffer)
        
        guard let createdPixelBuffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(createdPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(createdPixelBuffer)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: pixelData,
                                      width: Int(newSize.width),
                                      height: Int(newSize.height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(createdPixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) else {
            return nil
        }
        
        context.translateBy(x: 0, y: newSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context)
        resizedImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(createdPixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        
        return createdPixelBuffer
    }
        mutating func detect(cgImage: CGImage) {
            guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model) else { return }
    
            let request = VNCoreMLRequest(model: model)
            let handler = VNImageRequestHandler(cgImage: cgImage)
    
            try? handler.perform([request])
    
            guard let results = request.results as? [VNClassificationObservation] else { return }
    
            if let firstResult = results.first {
                self.results = firstResult.identifier
            }
        }
  
}
