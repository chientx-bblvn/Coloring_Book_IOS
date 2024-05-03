//
//  UIImageExt.swift
//  BBLabs.
//
//  Created by BBLabs on 1/4/21.
//  Copyright © 2021 BBLabs.All rights reserved.
//

import UIKit

extension String {
    
    fileprivate static let defaultFolderImageCache = "/Documents/Image-Caches/"
    
    // MARK: - Process cache Image
    func storeImage(pickedImage: UIImage) -> Bool {
        var nameSet: String = self
        if !nameSet.isEmpty {
            if !nameSet.contains(".png") {
                nameSet = "\(nameSet).png"
            }
        }
        do {
            // Save image
            let directoryPath = NSHomeDirectory().appending(String.defaultFolderImageCache)
            if !FileManager.default.fileExists(atPath: directoryPath) {
                do {
                    try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print(error)
                    return false
                }
            }
            let fileManager = FileManager.default
            let filePath = directoryPath.appending(nameSet)
            let fileURL = NSURL.fileURL(withPath: filePath)
            if !nameSet.isEmpty, fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            
            if let data = pickedImage.jpegData(compressionQuality: 0.8) {
                // writes the image data to disk
                try data.write(to: fileURL)
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
        
        return false
    }
    
    func getImage() -> String? {
        var nameSet: String = self
        if !nameSet.isEmpty {
            if !nameSet.contains(".png") {
                nameSet = "\(nameSet).png"
            }
        }
        // Get image
        let directoryPath = NSHomeDirectory().appending(String.defaultFolderImageCache)
        if !FileManager.default.fileExists(atPath: directoryPath) {
            return ""
        }
        let filePath = directoryPath.appending(nameSet)
        if !FileManager.default.fileExists(atPath: filePath) {
            return ""
        }
        let fileURL = NSURL.fileURL(withPath: filePath)
        return fileURL.path
    }
    
    func deleteImage() -> Bool {
        var nameSet: String = self
        if !nameSet.isEmpty {
            if !nameSet.contains(".png") {
                nameSet = "\(nameSet).png"
            }
        }
        do {
            // Get image
            let fileManager = FileManager.default
            let directoryPath = NSHomeDirectory().appending(String.defaultFolderImageCache)
            if !FileManager.default.fileExists(atPath: directoryPath) {
                return false
            }
            let filePath = directoryPath.appending(nameSet)
            let fileURL = NSURL.fileURL(withPath: filePath)
            try fileManager.removeItem(at: fileURL)
            return true
        } catch {
            debugPrint(error.localizedDescription)
        }
        return false
    }
    
}
