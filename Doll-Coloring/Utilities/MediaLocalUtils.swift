//
//  MediaLocalUtils.swift
//  BBLabs.
//
//  Created by BBLabs on 12/11/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import Foundation
import Photos
import RxSwift

class MediaLocalUtils: NSObject {

    private let queueMediaBlock: String = "com.bblabs.rmvbg.MediaLocalUtils.loadMedia"
    
    static let shareInstance = MediaLocalUtils()
    
    var allPhotos = BehaviorSubject<PHFetchResult<PHAsset>>(value: PHFetchResult<PHAsset>())
    var allVideos = BehaviorSubject<PHFetchResult<PHAsset>>(value: PHFetchResult<PHAsset>())
    var queueLoadMedia: DispatchQueue?
    
    override init() {
        super.init()
        queueLoadMedia = DispatchQueue.init(label: queueMediaBlock, qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: DispatchQueue.main)
    }
    
    func loadAllPhotos() {
        /// Load Photos
            PHPhotoLibrary.requestAuthorization { [weak self](status) in
                switch status {
                case .authorized:
                    print("Good to proceed")
                    self?.queueLoadMedia?.async {
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        let listMediaAssets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                        self?.allPhotos.onNext(listMediaAssets)
                    }
                case .denied, .restricted:
                    print("Not allowed")
                    self?.allPhotos.onNext(PHFetchResult<PHAsset>())
                case .notDetermined:
                    print("Not determined yet")
                    self?.allPhotos.onNext(PHFetchResult<PHAsset>())
                case .limited:
                    print("Not limited")
                    self?.allPhotos.onNext(PHFetchResult<PHAsset>())
                @unknown default:
                    print("Not default permission")
                    self?.allPhotos.onNext(PHFetchResult<PHAsset>())
                }
            }
    }
    
    func loadAllVideos() {
        /// Load Photos
            PHPhotoLibrary.requestAuthorization { [weak self](status) in
                switch status {
                case .authorized:
                    print("Good to proceed")
                    self?.queueLoadMedia?.async {
                        let fetchOptions = PHFetchOptions()
                        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                        let listMediaAssets: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: .video, options: fetchOptions)
                        self?.allVideos.onNext(listMediaAssets)
                    }
                case .denied, .restricted:
                    print("Not allowed")
                    self?.allVideos.onNext(PHFetchResult<PHAsset>())
                case .notDetermined:
                    print("Not determined yet")
                    self?.allVideos.onNext(PHFetchResult<PHAsset>())
                case .limited:
                    print("Not limited")
                    self?.allVideos.onNext(PHFetchResult<PHAsset>())
                @unknown default:
                    print("Not default permission")
                    self?.allVideos.onNext(PHFetchResult<PHAsset>())
                }
            }
    }

}
