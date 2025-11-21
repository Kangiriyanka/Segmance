//
//  AudioTrimmerModel.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/20.
//

import Foundation
import SwiftUI
import AVFoundation

@Observable
class AudioTrimmerModel: NSObject {
    
    private var audioPlayer: AVAudioPlayer?
    var showError: Bool = false
    var errorMessage: String?
    var audioURL: URL?
    var isPlaying: Bool = false
    var selectionStart: Double = 0
    var selectionEnd: Double = 0
    var waveform: [Float] = Array(repeating: 0.5, count: 100)
    
    // The difference between the AudioPlayerModel and AudioTrimmer is that we already know the URL attached when we upload a routine.
    func setupAudio(url: URL?) {
        do {
            // Bluetooth Support
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            // Audio Player
            guard let audioFileURL = url else {
                errorMessage = "Invalid audio file URL"
                showError = true
                return
            }
            
            audioURL = audioFileURL
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            audioPlayer?.prepareToPlay()
           
            
        } catch {
          
            errorMessage = AudioPlayerError.initializationFailed(error).errorDescription
            showError = true
         
        }
    }
    
    func togglePlayPause() {
           
            
            if isPlaying {
                audioPlayer?.pause()
            } else {
                audioPlayer?.play()
            }
            
            isPlaying.toggle()
        }
   
   
    
    
    
 
}
