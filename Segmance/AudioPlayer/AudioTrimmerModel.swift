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
class AudioTrimmerModel: NSObject, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer?
    private var currentExportSession: AVAssetExportSession?
    
    var showError: Bool = false
    var errorMessage: String?
    var audioURL: URL?
    var isPlaying: Bool = false
    var originalFilename: String?
    
    /// Start and end of the selection in seconds
    var selectionStart: TimeInterval = 0
    var selectionEnd: TimeInterval = 1
    
    var duration: TimeInterval? {
        audioPlayer?.duration
    }
    
    var clippedURLs: [URL] = []

    func setupAudio(url: URL?) {
        guard let audioFileURL = url else {
            errorMessage = "Invalid audio file"
            showError = true
            return
        }
        
        guard audioFileURL.startAccessingSecurityScopedResource() else {
            errorMessage = "Failed to access audio file"
            showError = true
            return
        }
        
        defer { audioFileURL.stopAccessingSecurityScopedResource() }
        
     
        
        originalFilename = String(audioFileURL.deletingPathExtension().lastPathComponent.prefix(6))
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(audioFileURL.pathExtension)
        
        do {
            try FileManager.default.copyItem(at: audioFileURL, to: tempURL)
            
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(true)
            
            audioURL = tempURL
            audioPlayer = try AVAudioPlayer(contentsOf: tempURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            // Initialize selection to full track
            selectionStart = 0
            selectionEnd = audioPlayer?.duration ?? 0
            
        } catch {
            errorMessage = AudioPlayerError.initializationFailed(error).errorDescription
            showError = true
            try? FileManager.default.removeItem(at: tempURL)
        }
    }
    
    func togglePlayPause() {
        guard audioPlayer != nil else { return }
        if isPlaying { audioPlayer?.pause() } else { audioPlayer?.play() }
        isPlaying.toggle()
    }
    
    func stop() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func seekAudio(to time: TimeInterval) {
        guard let duration = audioPlayer?.duration else { return }
        audioPlayer?.currentTime = max(0, min(time, duration))
    }
    
    
    func seekInterval(_ seekTime: TimeInterval, updateHandles: ((TimeInterval, TimeInterval) -> Void)? = nil) {
        guard let duration = audioPlayer?.duration else { return }
        
        let newTime = max(0, min((audioPlayer?.currentTime ?? 0) + seekTime, duration))
        audioPlayer?.currentTime = newTime
        
        // If the current time is inside selection, just update end of selection
        let clampedTime = max(selectionStart, min(newTime, selectionEnd))
        
        updateHandles?(selectionStart, clampedTime)
    }
    
    func clipSelection(startTime: TimeInterval, endTime: TimeInterval) async throws {
        guard let url = audioURL, let duration = audioPlayer?.duration else {
            throw AudioClipError.invalidAudioURLOrDuration
        }
        
        let start = max(0, min(startTime, duration))
        let end = max(0, min(endTime, duration))
        
        guard end > start else { return }
        
        let startCM = CMTime(seconds: start, preferredTimescale: 600)
        let endCM = CMTime(seconds: end, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: startCM, end: endCM)
        
        
        let base = (originalFilename ?? "Clip")
      
       
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(base)_\(formatTime(start))_\(formatTime(end)).m4a")
        
        
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
        
        currentExportSession = exportSession
        exportSession.timeRange = timeRange
        try await exportSession.export(to: outputURL, as: .m4a)
        
        clippedURLs.append(outputURL)
    }
    
    func removeURL(url: URL) {
        try? FileManager.default.removeItem(at: url)
        clippedURLs.removeAll { $0 == url }
    }
    
    func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
    
    func cleanup() {
        stop()
        audioPlayer = nil
        
        currentExportSession?.cancelExport()
        currentExportSession = nil
        
        if let url = audioURL {
            try? FileManager.default.removeItem(at: url)
        }
        
        for url in clippedURLs {
            try? FileManager.default.removeItem(at: url)
        }
        
        audioURL = nil
        clippedURLs.removeAll()
        selectionStart = 0
        selectionEnd = 0
    }
    
    deinit {
        cleanup()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        isPlaying = false

    }
}
