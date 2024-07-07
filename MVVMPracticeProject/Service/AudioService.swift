//
//  AudioService.swift
//  MVVMPracticeProject
//
//  Created by Tamara Andonovska on 7/3/24.
//

import Foundation
import AVFoundation

protocol AudioServiceable {
    func playSound()
}

final class AudioService: AudioServiceable {
    var player: AVAudioPlayer?
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")
        guard let path else { return }
        let url = URL(filePath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch(let error) {
            print(error.localizedDescription)
        }
    }
}
