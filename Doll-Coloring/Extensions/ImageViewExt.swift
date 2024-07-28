//
//  ImageViewExt.swift
//  BBLabs.
//
//  Created by BBLabs on 12/14/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import Accelerate
import Photos
import SDWebImage
import UIKit
import VideoToolbox

extension UIImageView {
    func fetchImageFromAsset(_ asset: PHAsset,
                             deliveryMode: PHImageRequestOptionsDeliveryMode = .fastFormat,
                             size: CGSize = CGSize.zero,
                             completion: ((_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)?) {
        let phImageOptions = PHImageRequestOptions()
        phImageOptions.deliveryMode = deliveryMode
        phImageOptions.isNetworkAccessAllowed = true
        phImageOptions.isSynchronous = true
        let targetSize = size == .zero ? CGSize(width: asset.pixelWidth, height: asset.pixelHeight) : size
        /// Load image from asset gallery and request with asynchronous
        PHCachingImageManager.default().requestImage(for: asset,
                                                     targetSize: targetSize,
                                                     contentMode: .aspectFit, options: phImageOptions) { [weak self] (image, info) in
            guard let this = self else { return }
            guard let imageData = image else {
                this.image = UIImage()
                completion?(image, [:])
                return
            }
            this.image = imageData
            completion?(imageData, info)
        }
    }
    
    func setImage(with url: String?, placeholder: UIImage? = nil) {
        var link = url ?? ""
        if !link.starts(with: "http://") && !link.starts(with: "https://") {
            link = "\(apiBaseUrl)\(link)"
        }
        let indicatorView = SDWebImageActivityIndicator()
        indicatorView.indicatorView.color = R.color.mainPrimary()
        self.sd_imageIndicator = indicatorView
        self.sd_setImage(with: URL(string: link)) { [weak self] _, error, _, _ in
            if error != nil {
                self?.image = placeholder
            }
        }
    }
    
    func setImageAccessKey(with url: String? = "https://storage.bunnycdn.com/bblprivate/doll-coloring%5Cdoll%202024-07-24%5CPrincess/princess%20(10).png", placeholder: UIImage? = nil) {
        var link = url ?? ""
        if !link.starts(with: "http://") && !link.starts(with: "https://") {
            link = "\(baseURLImage)\(link)"
        }
        if let url = URL(string: link) {
            let manager = SDWebImageDownloader()
            manager.setValue(apiAccessKey, forHTTPHeaderField: "AccessKey")
            _ = manager.downloadImage(with: url, completed: { image, data, error, success in
                DispatchQueue.main.async {
                    if let image = image {
                        self.image = image
                    } else {
                        self.image = placeholder
                    }
                }
            })
        } else {
            self.image = placeholder
        }
    }
    
    func setLocalImage(with url: String?, placeholder: UIImage?, size: CGSize = CGSize(width: 250, height: 250)) {
        self.sd_setImage(with: URL(fileURLWithPath: url ?? ""), placeholderImage: placeholder)
    }
    
}

extension String {
    
    private func fetchImageFromAsset(_ asset: PHAsset, _ deliveryMode: PHImageRequestOptionsDeliveryMode = .fastFormat,
                                     completion: ((_ image: UIImage?, _ info: [AnyHashable: Any]?) -> Void)?) {
        let phImageOptions = PHImageRequestOptions()
        phImageOptions.deliveryMode = deliveryMode
        phImageOptions.isNetworkAccessAllowed = true
        phImageOptions.isSynchronous = true
        /// Load image from asset gallery and request with asynchronous
        PHCachingImageManager.default().requestImage(for: asset,
                                                     targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                                     contentMode: .aspectFit, options: phImageOptions) {  (image, info) in
            guard let imageData = image else {
                completion?(image, [:])
                return
            }
            completion?(imageData, info)
        }
    }
    
    func loadImageFromPHAsset(completion: ((_ image: UIImage?) -> Void)?) {
        let phImageOptions = PHFetchOptions()
        phImageOptions.fetchLimit = 1
        let phResults = PHAsset.fetchAssets(withLocalIdentifiers: [self], options: phImageOptions)
        if let photoAsset = phResults.firstObject {
            fetchImageFromAsset(photoAsset, .highQualityFormat) { (image, _) in
                completion?(image)
            }
            return
        }
        completion?(nil)
    }
    
    func loadVideoFromPHAsset(completion: ((_ video: String) -> Void)?) {
        let phImageOptions = PHFetchOptions()
        phImageOptions.fetchLimit = 1
        let phResults = PHAsset.fetchAssets(withLocalIdentifiers: [self], options: phImageOptions)
        if let photoAsset = phResults.firstObject {
            photoAsset.requestAVURLAsset { (url) in
                guard let url = url else {
                    completion?("")
                    return
                }
                completion?(url)
            }
            return
        }
        completion?("")
    }
    
    // Function for get image from video path at second time
    func generateThumbnailForVideoAtURL(timeStamp: Double, completion: ((_ image: UIImage?) -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            do {
                let vidURL = URL(fileURLWithPath: self)
                let asset = AVURLAsset(url: vidURL)
                let generator = AVAssetImageGenerator(asset: asset)
                generator.appliesPreferredTrackTransform = true
                
                let time = CMTime(seconds: timeStamp, preferredTimescale: 60)
                
                let imageRef = try generator.copyCGImage(at: time, actualTime: nil)
                DispatchQueue.main.asyncSafety{
                    completion?(UIImage(cgImage: imageRef))
                }
            } catch let error {
                debugPrint("Image generation failed with error \(error)")
                DispatchQueue.main.asyncSafety{
                    completion?(nil)
                }
            }
        }
    }
    
}

extension UIImage {
    
    // swiftlint:disable cyclomatic_complexity function_body_length
    public func fixedOrientation() -> UIImage? {
        
        guard self.imageOrientation != .up else {
            return self
        }
        
        let size = self.size
        let imageOrientation = self.imageOrientation
        var transform: CGAffineTransform = .identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        // Flip image one more time if needed to, this is to prevent flipped image
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }
        
        guard var cgImage = self.cgImage else {
            return nil
        }
        
        autoreleasepool {
            
            guard let colorSpace = cgImage.colorSpace,
                  let context = CGContext(data: nil,
                                          width: Int(self.size.width),
                                          height: Int(self.size.height),
                                          bitsPerComponent: cgImage.bitsPerComponent,
                                          bytesPerRow: 0,
                                          space: colorSpace,
                                          bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                return
            }
            
            context.concatenate(transform)
            
            var drawRect: CGRect = .zero
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                drawRect.size = CGSize(width: size.height, height: size.width)
            default:
                drawRect.size = CGSize(width: size.width, height: size.height)
            }
            
            context.draw(cgImage, in: drawRect)
            
            guard let newCGImage = context.makeImage() else {
                return
            }
            cgImage = newCGImage
        }
        
        let uiImage = UIImage(cgImage: cgImage, scale: 1, orientation: .up)
        return uiImage
    }
    
    func pixelBuffer() -> CVPixelBuffer? {
        guard let image: CGImage = self.cgImage else {
            return nil
        }
        
        let frameSize = CGSize(width: image.width, height: image.height)
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(frameSize.width),
                                         Int(frameSize.height), kCVPixelFormatType_32BGRA, nil, &pixelBuffer)
        
        if status != kCVReturnSuccess {
            return nil
            
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags.init(rawValue: 0))
        let data = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext(data: data, width: Int(frameSize.width), height: Int(frameSize.height),
                                bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                                space: rgbColorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
        
    }
    
    /**
     Resizes the image to width x height and converts it to an RGB CVPixelBuffer.
     */
    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        return pixelBuffer(width: width, height: height,
                           pixelFormatType: kCVPixelFormatType_32ARGB,
                           colorSpace: CGColorSpaceCreateDeviceRGB(),
                           alphaInfo: .noneSkipFirst)
    }
    
    /**
     Resizes the image to width x height and converts it to a grayscale CVPixelBuffer.
     */
    public func pixelBufferGray(width: Int, height: Int) -> CVPixelBuffer? {
        return pixelBuffer(width: width, height: height,
                           pixelFormatType: kCVPixelFormatType_OneComponent8,
                           colorSpace: CGColorSpaceCreateDeviceGray(),
                           alphaInfo: .none)
    }
    
    func pixelBuffer(width: Int, height: Int, pixelFormatType: OSType,
                     colorSpace: CGColorSpace, alphaInfo: CGImageAlphaInfo) -> CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         pixelFormatType,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: alphaInfo.rawValue)
        else {
            return nil
        }
        
        UIGraphicsPushContext(context)
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}

extension UIImage {
    /**
     Creates a new UIImage from a CVPixelBuffer.
     NOTE: This only works for RGB pixel buffers, not for grayscale.
     */
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
    
    /**
     Creates a new UIImage from a CVPixelBuffer, using Core Image.
     */
    public convenience init?(pixelBuffer: CVPixelBuffer, context: CIContext) {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let rect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer),
                          height: CVPixelBufferGetHeight(pixelBuffer))
        if let cgImage = context.createCGImage(ciImage, from: rect) {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        //    Or if you need a thinner border :
        //    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func getData(expert quality: CGFloat = 1.0, dataSize max: CGFloat = 0.5) -> Data? {
//        let width = 720.0
//        let height = width * self.size.height / self.size.width
//        let image = resizeVI(size: CGSize(width: width, height: height))
//        return image?.jpegData(compressionQuality: 1.0)
        guard let data = self.jpegData(compressionQuality: quality) else { return nil }
//        if quality <= min {
//            return data
//        }
        if CGFloat(data.count) > max * 1024 * 1024 {
            return getData(expert: quality - 0.1, dataSize: max)
        }
        print("Size image: \(data.count)")
        return data
    }
    
}

// Save Image to cameraRoll
extension UIImage {
    
    func saveToCameraRoll(completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        checkPhotoAccess { success, message in
            completion(success, message)
        }
    }
    
    private func checkPhotoAccess(completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            completion(false, "Photo library is not avaiable")
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .limited:
            let photoCount = PHAsset.fetchAssets(with: .image, options: nil).count
            print("Photo access permission is limited \(photoCount)")
            if photoCount > 0 {
                completion(true, "Permission allowed")
            } else {
                completion(false, ErrorUtils.photo_IS_LIMITED())
            }
        case .authorized:
            let photoCount = PHAsset.fetchAssets(with: .image, options: nil).count
            print("Photo access permission is limited \(photoCount)")
            if photoCount > 0 {
                completion(true, "Permission allowed")
            } else {
                completion(false, ErrorUtils.photo_IS_LIMITED())
            }
            // handle authorized status
        case .denied, .restricted:
            debugPrint(ErrorUtils.photo_PERMISSION_DENIED())
            completion(false, ErrorUtils.photo_PERMISSION_DENIED())
            // handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    DispatchQueue.main.asyncSafety{
                        completion(true, "Permission allowed")
                    }
                } else {
                    completion(false, ErrorUtils.photo_PERMISSION_DENIED())
                }
            })
        default:
            debugPrint(ErrorUtils.photo_PERMISSION_DENIED())
            completion(false, ErrorUtils.photo_PERMISSION_DENIED())
        }
    }
}

// MARK: - Resize image
extension UIImage {
    func resizeVI(size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return self }
        
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: .defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate()
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        // create a destination buffer
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        return resizedImage
    }
}
