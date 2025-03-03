//
//  LottieAnimationView++JSON.swift
// Doll-Coloring
//
//  Created by BBLabs on 05/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation
import Lottie

extension LottieAnimationView {
    
    func loadAnimation(file name: String, loopMode: LottieLoopMode = .playOnce, autoPlay: Bool = true, animationSpeed: CGFloat = 1, contentMode: UIView.ContentMode = .scaleAspectFit) {
        let animation = LottieAnimation.named(name)
        self.animation = animation
        self.contentMode = .scaleAspectFit
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
        if autoPlay {
            self.play()
        }
    }
    
    func loadAnimation(file name: String, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1, autoplay: Bool = true, complection: @escaping (Bool) -> Void)  {
        let animation = LottieAnimation.named(name)
        self.animation = animation
        self.contentMode = .scaleAspectFit
        self.loopMode =  loopMode
        self.animationSpeed = animationSpeed
        if autoplay {
            self.play { completed in
                complection(completed)
            }
        }
        
        
    }
    
}
