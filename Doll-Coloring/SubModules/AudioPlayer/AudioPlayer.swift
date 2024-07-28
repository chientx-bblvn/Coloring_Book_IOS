//
//  AudioPlayer.swift
//  EmojiMixer-iOS
//
//  Created by PrankSound on 04/03/2024.
//  Copyright © 2024 Ongaeshi. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioType {
    case Background
    case Sound
    case fillColor
    
    var path: String {
        switch self {
        case .Background:
            let path = Bundle.main.path(forResource: "musicBackground.mp3", ofType: nil)!
            return path
        case .Sound:
            let path = Bundle.main.path(forResource: "asrmColoring.mp3", ofType:nil)!
            return path
        case .fillColor:
            let path = Bundle.main.path(forResource: "soundFillColor.mp3", ofType:nil)!
            return path
        }
    }
}

class AudioPlayer {
    fileprivate var audioPlayer: AVAudioPlayer?
    
    func loadAudio(type: AudioType, isLoop: Bool = false) {
        clearAudioPlayer()
        var audio: String = ""
        switch type {
        case .Background:
            audio = type.path
        case .Sound:
            audio = type.path
        case .fillColor:
            audio = type.path
        }
        let url = URL(fileURLWithPath: audio)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            createAudioSession()
            if isLoop {
                audioPlayer?.numberOfLoops = -1
            } else {
                audioPlayer?.numberOfLoops = 1
            }
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    fileprivate func createAudioSession() {
        do {
            /// this codes for making this app ready to takeover the device player
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.soloAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
    }
    
    func pauseAudio() {
        guard let audio = audioPlayer else {return}
        audio.pause()
    }
    
    func playAudio() {
        guard let audio = audioPlayer else {
            return
        }
        audio.play()
    }
    
    func clearAudioPlayer() {
        pauseAudio()
        audioPlayer = nil
    }
}

let audioBackground = AudioPlayer()
