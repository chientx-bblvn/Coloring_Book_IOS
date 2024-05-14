//
//  DowloadOperation.swift
//  STIMUL-iOS
//
//  Created by Việt Anh Nguyễn on 19/07/2023.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

class DownloadOperation : AsynchronousOperation {
    
    public var task: URLSessionTask!
    
    init(session: URLSession, url: URL) {
        task = session.downloadTask(with: url)
        
        super.init()
    }

    override func cancel() {
        task.cancel()
        super.cancel()
    }

    override func main() {
        task.resume()
    }
}

// MARK: Track the download progress from Download manager's urlsession

extension DownloadOperation {
    
    /// Download complete. Save file to document directory.
    func trackDownloadByOperation(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL, fileTo: URL, isTheme: Bool, coloringLocal: ColoringHistoryModel?) {
        do {
            let manager = FileManager.default
            let urlDownLoad = downloadTask.originalRequest?.url?.path.replacingOccurrences(of: "/doll-coloring2/canvas/", with: "") ?? ""
            let destinationURL = fileTo
            if manager.fileExists(atPath: destinationURL.path) {
                try manager.removeItem(at: destinationURL)
            }
            try manager.moveItem(at: location, to: destinationURL)
            let id = SQLiteManager.shared.selectionColorings().max(by: {$0.id < $1.id})?.id ?? 0
            SQLiteManager.shared.insertTableColoring(data: ColoringHistoryModel(id: id + 1, filePath: urlDownLoad, fileLocal: fileTo.lastPathComponent, historys: []))
        }
        catch {
            print("\(error)")
        }
        
        completeOperation()
    }

    /// Downloading progress.
    func trackDownloadByOperation(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite)
    }
    
    /// Download failed.
    func trackDownloadByOperation(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print("\(String(describing: error))")
        }
        completeOperation()
    }
}

