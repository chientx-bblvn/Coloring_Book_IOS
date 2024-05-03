//
//  PlayerManager.swift
//  BBLabs
//
//  Created by BBLabs on 08/11/23.
//  Copyright ©2023 BBLabs. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

@objc
enum StateAudio: Int {
    case Idle
    case Playing
    case Pausing
    case Failed
}

enum Quality : String {
    case Quality240p = "240p"
    case Quality360p = "360p"
    case Quality480p = "480p"
    case Quality720p = "720p"
    case Quality1080p = "1080p"
    case Quality2K = "2K"
    case Quality4K = "4K"
    case QualityAuto = "Auto"
}

enum KeyPathEle: String {
    case None = ""
    case KeyFramePath = "frame"
    case RateKeyPath = "rate"
    case StatusKeyPath = "status"
    case TimeMetadata = "timedMetadata"
    case KeyLoadTimeRange = "loadedTimeRanges"
    case KeyOutputVolume = "outputVolume"
}

@objc
protocol PlayerDelegate: AnyObject {
    
    @objc
    optional
    func playerSeekedTime(toTime:Float64, finished:Bool, player: PlayerManager)
    
    @objc
    optional
    func playerUpdatedTime(currentTime:Float64, player: PlayerManager)
    
    @objc
    optional
    func playerVolumeChange(oldVolume: Float, newVolume: Float, player: PlayerManager)
    
    @objc
    optional
    func playerBufferChange(key:String, value:Any, player: PlayerManager)
    
    @objc
    optional
    func playerPreparedState(_ state:StateAudio, _ message:String, player: PlayerManager)
    
    @objc
    optional
    func playerFinishing(successfully flag: Bool, player: PlayerManager)
    
}

class PlayerManager: NSObject {
    
    private let VERSION_PLAYER = "0.1.0"
    
    static let LIMIT_PLAYER = 5
    fileprivate static var listPlayer = [PlayerManager]()
    
    /* Player keys */
    let TracksKey = "tracks"
    let PlayableKey = "playable"
    let DurationKey = "duration"
    var observer:Any?
    var frameObserver:Any?
    
    static let BufferTime = "bufferTime"
    static let StartBuffer = "StartBuffer"
    static let StopBuffer = "StopBuffer"
    
    var playbackBufferEmptyKeyPath:String = ""
    var playbackLikelyToKeepUpKeyPath:String = ""
    var playbackBufferFullKeyPath:String = ""
    var isAddObserVol = false
    var isRegisterStatus = false
    
    fileprivate var autoPlay = true
    fileprivate var currentURL = ""
    fileprivate var playMusic: AVPlayer?
    fileprivate var currentState = StateAudio.Idle
    weak var playerPlayDelegate:PlayerDelegate?
    var imageGenerator: AVAssetImageGenerator?
    
    var currentLayer:AVPlayerLayer!
    var parentView:UIView?
    var imgThumb: UIImage?
    
    override init() {
        super.init()
        initPlayer()
    }
    
    private static var musicManager: PlayerManager? = {
        let musicManager = PlayerManager()
        return musicManager
    }()
    
    class func shared() -> PlayerManager {
        if musicManager == nil {
            musicManager = PlayerManager()
        }
        return musicManager!
    }
    
    // ACTION Music player
    // Play video return state player
    
    fileprivate func initPlayer() {
        playMusic = AVPlayer.init()
        currentLayer = AVPlayerLayer.init(player: playMusic)
        currentLayer.videoGravity = .resizeAspectFill
        currentLayer.backgroundColor = UIColor.black.cgColor
        self.createAudioSession()
        playMusic?.addObserver(self, forKeyPath: KeyPathEle.RateKeyPath.rawValue, options: [.new, .old], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        self.setVolumeChangeObserver()
        let interval = CMTimeMakeWithSeconds(0.5, preferredTimescale:Int32(NSEC_PER_SEC))
        if observer != nil {
            playMusic?.removeTimeObserver(observer!)
            observer = nil
        }
        observer = playMusic?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (time) in
            let myTime = self.getCurrentTime()
            if self.playerPlayDelegate != nil {
                self.playerPlayDelegate?.playerUpdatedTime?(currentTime: myTime, player: self)
            }
        })
        playMusic?.allowsExternalPlayback = true
        playMusic?.usesExternalPlaybackWhileExternalScreenIsActive = true
    }
    
    func changeFrameTypePlayer(_ sizeToFit:Int) {
        switch sizeToFit {
        case 0:
            currentLayer.videoGravity = .resizeAspectFill
        case 1:
            currentLayer.videoGravity = .resizeAspect
        default:
            currentLayer.videoGravity = .resizeAspectFill
        }
    }
    
    func setLayerColor(_ colorSelected:UIColor) {
        currentLayer.backgroundColor = colorSelected.cgColor
    }
    
    func addPlayerToView(_ parentView:UIView, frame: CGRect = .zero) {
        var parentFrame = frame
        if frame == .zero {
            parentFrame = parentView.frame
        }
        parentView.layer.sublayers?.forEach({
            $0.removeFromSuperlayer()
        })
        self.parentView?.layer.sublayers?.forEach({
            $0.removeFromSuperlayer()
        })
        currentLayer.removeFromSuperlayer()
        if frameObserver != nil {
            self.parentView?.removeObserver(self, forKeyPath: "frame")
        }
        self.parentView = parentView
        frameObserver = parentView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        currentLayer.frame = parentFrame
        self.parentView?.layer.masksToBounds = true
        self.parentView?.layer.addSublayer(currentLayer)
        currentLayer.masksToBounds = true
        
    }
    
    fileprivate func createAudioSession() {
        do {
            /// this codes for making this app ready to takeover the device player
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                            mode: .moviePlayback,
                                                            options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
    func prepareToPlay(_ urlVideo:String,
                       currentTime:Int = 0,
                       autoPlay: Bool = true,
                       isNetwork: Bool = false) {
        var urlMusic: URL?
        if !isNetwork {
            urlMusic = URL(fileURLWithPath: urlVideo)
        } else {
            urlMusic = URL(string: urlVideo)
        }
        prepareToPlay(urlMusic, currentTime: currentTime, autoPlay: autoPlay, isNetwork: isNetwork)
    }
    
    func prepareToPlay(_ urlMusic:URL?,
                       currentTime:Int = 0,
                       autoPlay: Bool = true,
                       isNetwork: Bool = false) {
        resetPlayer()
        var urlVideo = ""
        if isNetwork {
            urlVideo = urlMusic?.absoluteString ?? ""
        } else {
            urlVideo = urlMusic?.path ?? ""
        }
        currentURL = urlVideo
        self.autoPlay = autoPlay
        if urlVideo.isEmpty {
            if playerPlayDelegate != nil {
                playerPlayDelegate?.playerPreparedState?(.Failed, "No video to play!", player: self)
            }
            return
        }
        if playerPlayDelegate != nil {
            playerPlayDelegate?.playerPreparedState?(.Idle, "Preparing video...", player: self)
        }
        guard let url = urlMusic else {
            if playerPlayDelegate != nil {
                playerPlayDelegate?.playerPreparedState?(.Failed, "No video to play!", player: self)
            }
            return
        }
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let agent = "BBLabs/\(version) (iOS \(UIDevice.current.model)) PlayerKit/\(VERSION_PLAYER) BBLabs/app-player/\(UIDevice.current.systemVersion)"
        print("agent---  \(agent)\nPlay from Url: \(url)")
        let headerFields: [String:String] = ["User-Agent": agent]
        let urlAssets = AVURLAsset.init(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headerFields])
        let requestedKeys = ["tracks", "playable", "duration"]
        urlAssets.loadValuesAsynchronously(forKeys: requestedKeys) {
            DispatchQueue.main.async {
                self.prepareToPlayAsset(urlAssets, withKeys: requestedKeys, currentTime)
            }
        }
    }
    
    fileprivate func prepareToPlayAsset(_ urlAsset:AVURLAsset, withKeys:[String], _ currentTime:Int) {
        for key in withKeys {
            let error = NSErrorPointer.init(nilLiteral: ())
            let keyStatus = urlAsset.statusOfValue(forKey: key, error: error)
            if keyStatus == AVKeyValueStatus.failed {
                if error != nil {
                    if self.playerPlayDelegate != nil {
                        self.playerPlayDelegate?.playerPreparedState?(.Failed, error.debugDescription, player: self)
                    }
                }
                return
            }
        }
        print("playerSource: %@", urlAsset.url.absoluteString)
        if !urlAsset.isPlayable {
            let errorMsg = String.init(format: "The follwoing source: %@ is not playable", urlAsset.url.absoluteString)
            print("errorMsg \(errorMsg)")
            if self.playerPlayDelegate != nil {
                playerPlayDelegate?.playerPreparedState?(.Failed, "The item is non playable", player: self)
            }
            return
        }
        
        let playItem = AVPlayerItem.init(asset: urlAsset, automaticallyLoadedAssetKeys: withKeys)
        playItem.addObserver(self, forKeyPath: KeyPathEle.StatusKeyPath.rawValue, options: [.new, .old], context: nil)
        playItem.addObserver(self, forKeyPath: KeyPathEle.TimeMetadata.rawValue, options: [.new, .old], context: nil)
        isRegisterStatus = true
        if playMusic?.currentItem != playItem {
            playMusic?.replaceCurrentItem(with: playItem)
            imageGenerator = AVAssetImageGenerator(asset: playItem.asset)
        }
        
        if currentTime > 0 {
            seek(Float64(currentTime))
        }
    }
    
    func resetPlayer() {
        if playMusic != nil {
            playMusic?.replaceCurrentItem(with: nil)
            imageGenerator = nil
        }
        if currentLayer != nil {
            currentLayer.removeFromSuperlayer()
        }
        if playMusic == nil {
            initPlayer()
        }
    }
    
    func releasePlayer() {
        if playMusic != nil {
            playMusic?.pause()
        }
        removeStatusObserver()
        removeVolumeChangeObserver()
        if playMusic != nil {
            playMusic?.replaceCurrentItem(with: nil)
            imageGenerator = nil
        }
        if currentLayer != nil {
            currentLayer.removeFromSuperlayer()
        }
        clearPlayer()
    }
    
    func clearPlayer() {
        if playMusic == nil {
            return
        }
        self.unregisterForPlaybackNotification()
        playMusic?.removeObserver(self, forKeyPath: KeyPathEle.RateKeyPath.rawValue, context: nil)
        if observer != nil {
            playMusic?.removeTimeObserver(observer!)
        }
        if frameObserver != nil {
            parentView?.removeObserver(self, forKeyPath: "frame")
        }
        // swiftlint:disable notification_center_detachment
        NotificationCenter.default.removeObserver(self)
        frameObserver = nil
        observer = nil
        playerPlayDelegate = nil
        playMusic = nil
        PlayerManager.musicManager = nil
    }
    
    deinit {
        clearPlayer()
    }
    
    // Pause video return state player
    @discardableResult
    func pauseSong() -> Bool {
        if playMusic != nil {
            playMusic?.pause()
            return true
        }
        return false
    }
    
    func playSong() {
        if playMusic != nil {
            playMusic?.play()
        }
    }
    
    func isPlaying() -> Bool {
        return playMusic?.rate == 1
    }
    
    func setVolume(_ volume:Float) -> Float {
        return playMusic?.volume ?? 0
    }
    
    func seek(_ toTime:Float64) {
        let duration = getDuration()
        var time = toTime
        if toTime < 0 {
            time = 0
        } else if toTime > duration {
            time = duration
        }
        let timeScale = self.playMusic?.currentItem?.asset.duration.timescale ?? 0
        playMusic?.seek(to: CMTime(seconds: Double(time), preferredTimescale: timeScale),
                        toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { (finished) in
                            if self.playerPlayDelegate != nil {
                                self.playerPlayDelegate?.playerSeekedTime?(toTime: toTime, finished: finished, player: self)
                            }
                        })
    }
    
}

// MARK: - Get Value
extension PlayerManager {
    
    // FUNC for get value
    func getThumb(_ toTime:Float64) -> UIImage? {
        guard let imageGenerator = imageGenerator else { return nil }
        imageGenerator.maximumSize = CGSize(width: 160, height: 90)
        let timeScale = self.playMusic?.currentItem?.asset.duration.timescale ?? 0
        let time = CMTime(seconds: Double(toTime), preferredTimescale: timeScale)
        if let imageRef = try? imageGenerator.copyCGImage(at: time, actualTime: nil) {
            return UIImage(cgImage: imageRef)
        } else {
            return nil
        }
    }
    
    func genarateThumb() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            var count = 100
            let duration = self.getDuration()
            let min = duration / 100
            var h = 900
            if duration < 100 {
                count = Int(duration)
                h = (count / 10 + 1) * 90
            }
            let size = CGSize(width: 1600, height: h)
            UIGraphicsBeginImageContext(size)
            let dispatchGroup = DispatchGroup()
            
            for i in 0..<count {
                dispatchGroup.enter()
                DispatchQueue.init(label: "\(i)").async {
                    let areaSize = CGRect(x: i % 10 * 160, y: i / 10 * 90, width: 160, height: 90)
                    if duration < 100 {
                        let img = self.getThumb(Float64(i))
                        img?.draw(in: areaSize)
                    } else {
                        let img = self.getThumb(min * Double(i))
                        img?.draw(in: areaSize)
                    }
                    dispatchGroup.leave()
                }
            }
            
            // 1
            dispatchGroup.notify(queue: .global()) { [weak self] in
                self?.imgThumb = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            
        }
    }
    
    func getStateAudio() -> StateAudio {
        return currentState
    }
    
    func getVolume() -> Float {
        return playMusic?.volume ?? 0.0
    }
    
    func getDuration() -> Float64 {
        return CMTimeGetSeconds(playMusic?.currentItem?.duration ?? .zero)
    }
    
    func getCurrentTime() -> Float64 {
        return CMTimeGetSeconds(playMusic?.currentItem?.currentTime() ?? .zero)
    }
    
    func setMuted(_ muted:Bool) {
        playMusic?.isMuted = muted
    }
    
    func isMuted() -> Bool {
        return playMusic?.isMuted ?? false
    }
    
    func getCurrentURL() -> String? {
        return currentURL
    }
    
    func setBitRate(_ quality: Quality) {
        // 1. 240p = 700000
        // 2. 360p = 1500000
        // 3. 480p = 2000000
        // 4. 720p = 4000000
        // 5. 1080p = 6000000
        // 6. 2k = 16000000
        // 7. 4k = 45000000
        var maxBitRate: Double = 0
        switch quality {
        case .Quality240p:
            maxBitRate = 700000
        case .Quality360p:
            maxBitRate = 1500000
        case .Quality480p:
            maxBitRate = 2000000
        case .Quality720p:
            maxBitRate = 4000000
        case .Quality1080p:
            maxBitRate = 6000000
        case .Quality2K:
            maxBitRate = 16000000
        case .Quality4K:
            maxBitRate = 45000000
        case .QualityAuto:
            maxBitRate = 0
        }
        playMusic?.currentItem?.preferredPeakBitRate = maxBitRate
//        print("Playing in Bit Rate \(String(describing: playMusic?.currentItem?.preferredPeakBitRate))")
    }
    
    func getListQualityAvaiable() -> [Quality] {
        var listQuality = [Quality]()
        if playMusic?.rate != 0 && playMusic?.error == nil {
            let listAvaiableQuality:[AVAssetTrack] = playMusic?.currentItem?.asset.tracks(withMediaType: .video) ?? []
            let empty = listAvaiableQuality.isEmpty
            if !empty {
                listQuality.append(.QualityAuto)
            }
            for asset in listAvaiableQuality {
                let dataRate = asset.estimatedDataRate
                if dataRate > 0 && dataRate <= 700000 {
                    listQuality.append(.Quality240p)
                    continue
                }
                if dataRate > 700000 && dataRate <= 1500000 {
                    listQuality.append(.Quality360p)
                    continue
                }
                if dataRate > 1500000 && dataRate <= 2000000 {
                    listQuality.append(.Quality480p)
                    continue
                }
                if dataRate > 2000000 && dataRate <= 4000000 {
                    listQuality.append(.Quality720p)
                    continue
                }
                if dataRate > 4000000 && dataRate <= 6000000 {
                    listQuality.append(.Quality1080p)
                    continue
                }
                if dataRate > 6000000 && dataRate <= 16000000 {
                    listQuality.append(.Quality2K)
                    continue
                }
                if dataRate > 16000000 && dataRate <= 45000000 {
                    listQuality.append(.Quality4K)
                    continue
                }
            }
        }
        return listQuality
    }
    
}

// MARK: - Register observe and event playing
extension PlayerManager {
    
    @objc func playerFinishPlaying(_ notification:Notification) {
        if let item = notification.object as? AVPlayerItem {
            if item == playMusic?.currentItem {
                if playerPlayDelegate != nil {
                    playerPlayDelegate?.playerFinishing?(successfully: true, player: self)
                }
            }
        }
    }
    
    fileprivate func processBufferDelegate() {
        if playMusic?.currentItem?.isPlaybackBufferEmpty ?? false {
            // rate = value of 0.0 pauses the video, while a value of 1.0 plays
            if self.getCurrentTime() >= self.getDuration()
                && self.getCurrentTime() > 0 {
                NSLog("END VIDEO _________")
                //                    if playerPlayDelegate != nil {
                //                        playerPlayDelegate?.playerFinishing(successfully: true)
                //                    }
            } else {
                // player stalled
                if playerPlayDelegate != nil {
                    playerPlayDelegate?.playerBufferChange?(key: PlayerManager.StartBuffer, value: 0, player: self)
                }
            }
        }
        if playMusic?.currentItem?.isPlaybackLikelyToKeepUp ?? false {
            //            [self stopBuffering];
            if playerPlayDelegate != nil {
                playerPlayDelegate?.playerBufferChange?(key: PlayerManager.StopBuffer, value: 0, player: self)
            }
            if isPlaying() {
                if playerPlayDelegate != nil {
                    playerPlayDelegate?.playerPreparedState?(.Playing, "", player: self)
                }
            } else {
                self.playMusic?.play()
            }
        }
        if self.playMusic?.currentItem?.isPlaybackBufferFull ?? false {
            //                    [self stopBuffering];
            if playerPlayDelegate != nil {
                playerPlayDelegate?.playerBufferChange?(key: PlayerManager.StopBuffer, value: 0, player: self)
            }
        }
    }
    
    fileprivate func processStatusKeyPath(old oldValue:Any?, new newValue:Any?) {
        switch playMusic?.currentItem?.status.rawValue {
        case AVPlayerItem.Status.failed.rawValue:
            if playerPlayDelegate != nil {
                playerPlayDelegate?.playerPreparedState?(.Failed, "Init source failed", player: self)
            }
        case AVPlayerItem.Status.unknown.rawValue:
            if playerPlayDelegate != nil {
                playerPlayDelegate?.playerPreparedState?(.Failed, "Unknown source error", player: self)
            }
        case AVPlayerItem.Status.readyToPlay.rawValue:
            if (oldValue as AnyObject).intValue ?? 0 != (newValue as AnyObject).intValue ?? 0 {
                if autoPlay {
                    self.playSong()
                } else {
                    self.pauseSong()
                }
                self.registerForPlaybackNotification()
            }
        case .none:
            break
        case .some:
            break
        }
    }
    
    fileprivate func processRateKeyPath() {
        if self.getCurrentTime() >= self.getDuration()
            && self.getCurrentTime() > 0
            && self.getDuration() > 0 {
            NSLog("END VIDEO _________")
            //                if playerPlayDelegate != nil {
            //                    playerPlayDelegate?.playerFinishing(successfully: true)
            //                }
        } else {
            // check end video
            if self.getCurrentTime() >= 0
//                && self.getDuration() > 0
            {
                if playMusic?.rate == 1.0 {
                    playerPlayDelegate?.playerPreparedState?(.Playing, "", player: self)
                } else if playMusic?.rate == 0.0 {
                    if playMusic?.currentItem?.status.rawValue == AVPlayer.Status.readyToPlay.rawValue {
                        playerPlayDelegate?.playerPreparedState?(.Pausing, "", player: self)
                    }
                }
            }
        }
    }
    
    // swiftlint:disable block_based_kvo
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        let oldValue = change?[.oldKey]
        let newValue = change?[.newKey]
        let keyPathEle = KeyPathEle(rawValue: keyPath ?? "") ?? .None
        switch keyPathEle {
        case .None:
            if (object as? AVPlayerItem) == playMusic?.currentItem
                && (keyPath == playbackBufferEmptyKeyPath
                        || keyPath == playbackLikelyToKeepUpKeyPath
                        || keyPath == playbackBufferFullKeyPath) {
               processBufferDelegate()
            }
        case .KeyFramePath:
            if let view = (object as? UIView), view == self.parentView, self.parentView != nil {
                let rect = change?[NSKeyValueChangeKey.newKey] as! CGRect
                
                if let videolayer = self.parentView?.layer.sublayers?.first {
                    CATransaction.begin()
                    CATransaction.setAnimationDuration(0)
                    CATransaction.setDisableActions(true)
                    videolayer.frame = rect
                    CATransaction.commit()
                }
            }
        case .RateKeyPath:
            processRateKeyPath()
        case .StatusKeyPath:
            processStatusKeyPath(old: oldValue, new: newValue)
        case .TimeMetadata:
    //            let playerItem = object as? AVPlayerItem
    //
    //            let listMetadata = playerItem?.timedMetadata ?? []
    //            for metadata in listMetadata  {
    //                if let key = metadata.commonKey, let value = metadata.stringValue  {
    //                    print("MetaData: key \(key) value \(value)")
    //                }
    //            }
        print("Time meta data")
        case .KeyLoadTimeRange:
            if let newBuffer = change?[.newKey] as? NSArray {
                if newBuffer.count > 0 {
                    if let timerange = (newBuffer.object(at: 0) as? NSValue)?.timeRangeValue {
                        let timeBuffer = CMTimeGetSeconds(timerange.duration)
                        if playerPlayDelegate != nil {
                            playerPlayDelegate?.playerBufferChange?(key: PlayerManager.BufferTime, value: timeBuffer, player: self)
                        }
                    }
                }
            }
        case .KeyOutputVolume:
            let oldVolume = (oldValue as AnyObject).floatValue ?? 0
            let newVolume = (newValue as AnyObject).floatValue ?? 0
            print("Volume change: oldVolume- \(oldVolume) newVolume- \(newVolume)")
            playerPlayDelegate?.playerVolumeChange?(oldVolume: oldVolume, newVolume: newVolume, player: self)
        }
        
    }
    
    func setVolumeChangeObserver() {
        
        do {
            try? AVAudioSession.sharedInstance().setActive(true)
            AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: [.new, .old], context: nil)
            isAddObserVol = true
        } catch /*let error as NSError*/ {
        }
    }
    
    func removeVolumeChangeObserver() {
        if isAddObserVol {
            try? AVAudioSession.sharedInstance().setActive(false)
            AVAudioSession.sharedInstance().removeObserver(self, forKeyPath: "outputVolume")
            isAddObserVol = false
        }
    }
    
    func removeStatusObserver() {
        if playMusic?.currentItem != nil && isRegisterStatus {
            playMusic?.currentItem?.removeObserver(self, forKeyPath:KeyPathEle.StatusKeyPath.rawValue, context:nil)
            playMusic?.currentItem?.removeObserver(self, forKeyPath:KeyPathEle.TimeMetadata.rawValue, context: nil)
            isRegisterStatus = false
        }
    }
    
    func registerForPlaybackNotification() {
        if playMusic?.currentItem == nil {
            return
        }
        playbackBufferEmptyKeyPath = NSStringFromSelector(#selector(getter: playMusic?.currentItem?.isPlaybackBufferEmpty))
        playbackLikelyToKeepUpKeyPath = NSStringFromSelector(#selector(getter: playMusic?.currentItem?.isPlaybackLikelyToKeepUp))
        playbackBufferFullKeyPath = NSStringFromSelector(#selector(getter: playMusic?.currentItem?.isPlaybackBufferFull))
        
        playMusic?.currentItem?.addObserver(self, forKeyPath:playbackBufferEmptyKeyPath, options:[.new, .old], context:nil)
        playMusic?.currentItem?.addObserver(self, forKeyPath:playbackLikelyToKeepUpKeyPath, options:[.new, .old], context:nil)
        playMusic?.currentItem?.addObserver(self, forKeyPath:playbackBufferFullKeyPath, options:[.new, .old], context:nil)
        playMusic?.currentItem?.addObserver(self, forKeyPath:"loadedTimeRanges", options:[.new, .old], context:nil)
    }
    
    func unregisterForPlaybackNotification() {
        playMusic?.currentItem?.removeObserver(self, forKeyPath:playbackBufferEmptyKeyPath)
        playMusic?.currentItem?.removeObserver(self, forKeyPath:playbackLikelyToKeepUpKeyPath)
        playMusic?.currentItem?.removeObserver(self, forKeyPath:playbackBufferFullKeyPath)
        playMusic?.currentItem?.removeObserver(self, forKeyPath:"loadedTimeRanges")
    }
}

// MARK: - Create multiplayer
extension PlayerManager {
    
    class func createAllPlayer() {
        for _ in 0..<PlayerManager.LIMIT_PLAYER {
            _ = newInstance()
        }
    }
    
    class func newInstance() -> PlayerManager? {
        if listPlayer.count >= LIMIT_PLAYER {
            print("Number of player reaching to maximum!")
            return nil
        }
        let player = PlayerManager()
        listPlayer.append(player)
        return player
    }
    
    static func releaseListPlayer() {
        PlayerManager.listPlayer.forEach {
            $0.releasePlayer()
        }
        PlayerManager.listPlayer.removeAll()
    }
    
    static func getListPlayer() -> [PlayerManager] {
        return listPlayer
    }
    
    static func retreivePlayer(at idx: Int) -> PlayerManager? {
        if idx < 0 || idx >= listPlayer.count {
            return nil
        }
        return listPlayer[idx]
    }
    
    static func runPlayer(at index: Int, with urls: [String], autoPlay: Bool = true) -> PlayerManager? {
        var currentPlayer: PlayerManager?
        for i in 0..<listPlayer.count {
            let player = listPlayer[i]
            if i >= urls.count {
                _ = player.pauseSong()
                continue
            }
            if !urls[i].elementsEqual(player.getCurrentURL() ?? "") {
                player.prepareToPlay(urls[i], autoPlay: (i == index) && autoPlay)
            } else {
                if i == index && autoPlay {
                    player.playSong()
                } else {
                    _ = player.pauseSong()
                }
            }
            if i == index {
                currentPlayer = player
            }
            player.changeFrameTypePlayer(0)
        }
        return currentPlayer
    }
    
}

extension PlayerManager {
    func setVolumeDevice(_ volume: Float) {
        if let slider = MPVolumeView().subviews.filter({
            NSStringFromClass($0.classForCoder) == "MPVolumeSlider"
        }).first as? UISlider {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                slider.setValue(volume, animated: false)
            })
        }
    }
    
    func getVolumeDevice() -> Float {
        return AVAudioSession.sharedInstance().outputVolume
    }
}
