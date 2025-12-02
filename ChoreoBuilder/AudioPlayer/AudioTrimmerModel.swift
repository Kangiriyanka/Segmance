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
    private var currentExportSession: AVAssetExportSession?
    var showError: Bool = false
    var errorMessage: String?
    var audioURL: URL?
    var isPlaying: Bool = false
    var showWaveError: Bool = false
    var selectionStart: Double = 0
    var selectionEnd: Double = 0
    
    var duration: TimeInterval? {
        audioPlayer?.duration
    }
    
    var clippedURLs: [URL] = []

    
    // The difference between the AudioPlayerModel and AudioTrimmer is that we already know the URL attached when we upload a routine.
    func setupAudio(url: URL?) {
        guard let audioFileURL = url else {
            errorMessage = "Invalid audio file"
            showError = true
            return
        }
        
        // Start accessing security-scoped resource
        guard audioFileURL.startAccessingSecurityScopedResource() else {
            errorMessage = "Failed to access audio file"
            showError = true
            return
        }
        
        // Run the function before it exits.
        defer {
            audioFileURL.stopAccessingSecurityScopedResource()
        }
        
        // Copy file to temp directory for unrestricted access
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(audioFileURL.pathExtension)
        
        do {
           
            try FileManager.default.copyItem(at: audioFileURL, to: tempURL)
            
            // Bluetooth Support
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            // Audio Player with copied file
            audioURL = tempURL
            audioPlayer = try AVAudioPlayer(contentsOf: tempURL)
            audioPlayer?.prepareToPlay()
            
        } catch {
            errorMessage = AudioPlayerError.initializationFailed(error).errorDescription
            showError = true
            // Clean up temp file if setup failed
            try? FileManager.default.removeItem(at: tempURL)
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
    
    func stop() {
        audioPlayer?.stop()
    }
    
    func seekAudio(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func seekInterval(_ seekTime: TimeInterval) {
        audioPlayer?.currentTime += seekTime
    }
    
    func clipSelection(startFraction: CGFloat, endFraction: CGFloat) async throws {
        
        guard let url = audioURL, let duration = audioPlayer?.duration else {
            throw AudioClipError.invalidAudioURLOrDuration
        }
        
      
        
        defer {
            currentExportSession = nil
        }
        
        let start = Double(startFraction) * duration
        let end = Double(endFraction) * duration
        let startTime = CMTime(seconds: start, preferredTimescale: 600)
        let endTime = CMTime(seconds: end, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: startTime, end: endTime)
        
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(formatTime(start))_\(formatTime(end)).m4a")
        
        guard !clippedURLs.contains(outputURL) else {
            throw AudioClipError.sameClip
        }
        
        try? FileManager.default.removeItem(at: outputURL)
        
        guard let exportSession = AVAssetExportSession(
            asset: AVURLAsset(url: url),
            presetName: AVAssetExportPresetAppleM4A
        ) else {
            throw AudioClipError.failedToCreateExportSession
        }
        
        // Cancel current export session
        currentExportSession = exportSession
        
        exportSession.timeRange = timeRange
        try await exportSession.export(to: outputURL, as: .m4a)
        
        clippedURLs.append(outputURL)
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
    
    func cleanup() {
           stop()
           audioPlayer = nil
           isPlaying = false
           

           currentExportSession?.cancelExport()
           currentExportSession = nil
           
           // Delete temp audio file
           if let url = audioURL {
               try? FileManager.default.removeItem(at: url)
           }
           
           // Delete all clipped files
           for url in clippedURLs {
               try? FileManager.default.removeItem(at: url)
           }
           
           audioURL = nil
           clippedURLs.removeAll()
       }
    
    deinit {
        cleanup()
    }
}
