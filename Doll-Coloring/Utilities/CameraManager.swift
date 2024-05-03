//
//  CameraManager.swift
//  Doll-Coloring
//
//  Created by BBLabs on 06/09/2023.
//
import AVFoundation

@objc
protocol CameraCaptureDelegate: AnyObject {
    func captureVideoOutput(sampleBuffer: CMSampleBuffer)
    @objc optional func captureAudioOutput(sampleBuffer: CMSampleBuffer)
}

class CameraManager: NSObject {
    private var videoCaptureDevice: AVCaptureDevice?
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let audioDataOutput = AVCaptureAudioDataOutput()
    private let dataOutputQueue = DispatchQueue(label: "VideoDataQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    private var currentCameraInput: AVCaptureInput?
    
    weak var delegate: CameraCaptureDelegate?
    private var isCapturing = false
            
    func setupCamera(preview view: PreviewView, useMic: Bool) {
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        self.videoCaptureDevice = videoCaptureDevice
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
            currentCameraInput = videoInput
        }
        
        // Add a video data output
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            videoDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
            videoDataOutput.connection(with: .video)?.videoOrientation = .portrait
            videoDataOutput.connection(with: .video)?.automaticallyAdjustsVideoMirroring = false
            videoDataOutput.connection(with: .video)?.isVideoMirrored = true
            view.session = captureSession
        } else {
            debugPrint("Could not add video data output to the session")
        }
        
        guard useMic,
            let audio = AVCaptureDevice.default(for: .audio),
            let audioInput = try? AVCaptureDeviceInput(device: audio) else { return }
        
        if captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        
        if captureSession.canAddOutput(audioDataOutput) {
            captureSession.addOutput(audioDataOutput)
            audioDataOutput.setSampleBufferDelegate(self, queue: dataOutputQueue)
        }
    }
    
    func startCapture() {
        debugPrint("Capture Start!!")
        
        guard isCapturing == false else { return }
        isCapturing = true
        
        #if arch(arm64)
        DispatchQueue.global().async { [weak self] in
            self?.captureSession.startRunning()
        }
        #endif
    }
    
    func stopCapture() {
        debugPrint("Capture Ended!!")
        guard isCapturing == true else { return }
        isCapturing = false

        #if arch(arm64)
        captureSession.stopRunning()
        #endif
    }
}

// MARK: Switching Camera
extension CameraManager {
    func switchCamera() {
        #if arch(arm64)
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        let nextPosition = ((currentCameraInput as? AVCaptureDeviceInput)?.device.position == .front) ? AVCaptureDevice.Position.back : .front
        
        if let currentCameraInput = currentCameraInput {
            captureSession.removeInput(currentCameraInput)
        }
                
        if let newCamera = cameraDevice(position: nextPosition),
            let newVideoInput: AVCaptureDeviceInput = try? AVCaptureDeviceInput(device: newCamera),
            captureSession.canAddInput(newVideoInput) {

            captureSession.addInput(newVideoInput)
            currentCameraInput = newVideoInput
                    
            videoDataOutput.connection(with: .video)?.videoOrientation = .portrait
            videoDataOutput.connection(with: .video)?.automaticallyAdjustsVideoMirroring = false
            videoDataOutput.connection(with: .video)?.isVideoMirrored = nextPosition == .front
        }
                
        #endif
    }

    private func cameraDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices where device.position == position {
            return device
        }

        return nil
    }
}

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if connection == videoDataOutput.connection(with: .video) {
            delegate?.captureVideoOutput(sampleBuffer: sampleBuffer)
        } else if connection == audioDataOutput.connection(with: .audio) {
            delegate?.captureAudioOutput?(sampleBuffer: sampleBuffer)
        }
    }
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    }
}
