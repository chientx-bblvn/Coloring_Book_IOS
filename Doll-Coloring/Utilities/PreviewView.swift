//
//  PreviewView.swift
//  Doll-Coloring
//
//  Created by BBLabs on 06/09/2023.
//
import UIKit
import AVFoundation

/**
 The camera frame is displayed on this view.
 */
class PreviewView: UIView {

  var previewLayer: AVCaptureVideoPreviewLayer {
    guard let layer = layer as? AVCaptureVideoPreviewLayer else {
      fatalError("Layer expected is of type VideoPreviewLayer")
    }
    layer.videoGravity = .resizeAspectFill
    return layer
  }

  var session: AVCaptureSession? {
    get {
      return previewLayer.session
    }
    set {
      previewLayer.session = newValue
    }
  }

  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }
}
