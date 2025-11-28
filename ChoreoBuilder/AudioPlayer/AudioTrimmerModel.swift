//
//  AudioTrimmerModel.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/20.
//

import Foundation
import SwiftUI
import AVFoundation
import Accelerate


@Observable
class AudioTrimmerModel: NSObject {
    
    private var audioPlayer: AVAudioPlayer?
    var showError: Bool = false
    var errorMessage: String?
    var audioURL: URL?
    var isPlaying: Bool = false
    var showWaveError: Bool = false
    var selectionStart: Double = 0
    var selectionEnd: Double = 0
    var duration: Double? {
        audioPlayer?.duration
    }
    
    var clippedURLs: [URL] = []
    
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
    
    
    func clipSelection(startFraction: CGFloat, endFraction: CGFloat) async throws -> URL {
        guard let url = audioURL, let duration = audioPlayer?.duration else {
            throw AudioClipError.invalidAudioURLOrDuration
        }
        
        let start = Double(startFraction) * duration
        let end = Double(endFraction) * duration
        let startString = formatTime(start)
        let endString = formatTime(end)
                                       
        let startTime = CMTime(seconds: start, preferredTimescale: 600)
        let endTime = CMTime(seconds: end, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: startTime, end: endTime)

        let asset = AVURLAsset(url: url)
        
       
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(startString)___\(endString)" + ".m4a")
        
        // Delete old file if it exists—otherwise export would fail
        try? FileManager.default.removeItem(at: outputURL)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            throw AudioClipError.failedToCreateExportSession
        }
        
        exportSession.timeRange = timeRange
        try await exportSession.export(to: outputURL, as: .m4a)
        
        clippedURLs.append(outputURL)
        return outputURL
    }
    
    // Delete the file and remove it from the array.
    func removeURL(url: URL) {
        // Remove the file if it still exists
        try? FileManager.default.removeItem(at: url)
        
        // Remove from the list in memory
        clippedURLs.removeAll { $0 == url }
    }
    
    func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    
    
  
    
   
   
   

    
 
}

