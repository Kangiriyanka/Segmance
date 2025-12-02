//
//  AudioPlayerModel.swift
//  Created by Kangiriyanka The Single Leaf on 2025/02/03.
//

import Foundation
import AVKit

@Observable
class AudioPlayerModel: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    private var tickPlayer: AVAudioPlayer?
    var isPlaying: Bool = false
    var isLooping: Bool = false
    var isCustomLooping: Bool  = false
    var showMarkers: Bool = false
    var isCountingDown: Bool = false
    var firstMarkerSelected = false
    var secondMarkerSelected = false
    private var delayedPlayTask: DispatchWorkItem?
    var countdownRemaining: Int = 0
    var delay: Float = 0.0
    var totalTime: TimeInterval = 0.0
    var currentTime: TimeInterval = 0.0
    var audioFileURL: URL?
    var firstMark:  TimeInterval = 0.0
    var secondMark: TimeInterval = 0.0
    var errorMessage: String?
    var seekTime: TimeInterval = 5.0
    var showError: Bool = false
    
    // You need this to destroy the countdown timer every time you pause.
    private var countdownTimer: Timer?
    
    
    init(audioFileURL: URL) {
        self.audioFileURL = audioFileURL
    }
    
    /// 2 sources of errors: the audio session or an invalidURL
    func setupAudio() {
        do {
            // Bluetooth Support
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try audioSession.setActive(true)
            
            // Audio Player
            guard let audioFileUrl = audioFileURL else {
                errorMessage = "Invalid audio file URL"
                showError = true
                return
            }
            
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            audioPlayer?.prepareToPlay()
            audioPlayer?.enableRate = true
            totalTime = audioPlayer?.duration ?? 0.0
            audioPlayer?.delegate = self
            
        } catch {
            // Take whatever error we throw and put it into our custom one
            errorMessage = AudioPlayerError.initializationFailed(error).errorDescription
            showError = true
         
        }
    }
        
    /// Play the audio with a set delay.
    func playAudio() {
            isPlaying = true
            
            
            if delay > 0 {
                countdownRemaining = Int(delay)
                isCountingDown = true
                startCountdown()
            }
            
            
            let task = DispatchWorkItem { [weak self] in
                self?.audioPlayer?.play()
            }
            delayedPlayTask = task
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay), execute: task)
        }
        
        func pauseAudio() {
            delayedPlayTask?.cancel()  
            delayedPlayTask = nil
            countdownTimer?.invalidate()
            countdownTimer = nil
            audioPlayer?.pause()
            isPlaying = false
            isCountingDown = false
            countdownRemaining = 0
        }
    
    func startCountdown() {
        // Invalidate any existing timer first (Prevents the user from spamming)
        countdownTimer?.invalidate()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            if self.countdownRemaining > 0 {
                self.countdownRemaining -= 1
                
              
                if self.countdownRemaining > 0 {
                    // Use a bundle instead
                    playTick()
                }
            }
            
            if self.countdownRemaining <= 0 {
                self.isCountingDown = false
                timer.invalidate()
                self.countdownTimer = nil
            }
        }
    }
        
        
        
        
   
    
    /// Stop the audio and reset the time to 0
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        isPlaying = false
    }
    
    
    /// Loop
    func loop() {
        if !isCustomLooping {
            isLooping = true
        }
    }
    
    func startCustomLoop() {
        
        isCustomLooping = true
       

    }
    func stopLoop() {
        isLooping = false
        audioPlayer?.numberOfLoops = 0
        
      
    }
    
    func changeSpeedRate(_ speedRate: Float) {
        
        
        audioPlayer?.rate = speedRate
  
    }
    
    func changeDelay(_ delay: Float) {
        self.delay = delay
    }
    
    func seekForwards() {
        audioPlayer?.currentTime += seekTime
    }
    
    func seekBackwards() {
        
        audioPlayer?.currentTime -= seekTime
    }
    
    
 
    
    func updateProgress() {
        guard let player = audioPlayer else {
            currentTime = 0
            return
        }

        currentTime = player.currentTime

        guard isCustomLooping else { return }

        // Always enforce correct ordering
        if firstMark > secondMark {
            swap(&firstMark, &secondMark)
        }

        // Before loop start → jump forward
        if currentTime < firstMark {
            seekAudio(to: firstMark + 0.1)
            return
        }

        // Past loop end → loop back
        if currentTime >= secondMark {
            player.pause()
            seekAudio(to: firstMark)

            resetCountdown()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 + TimeInterval(delay)) {
                player.play()
            }

            return
        }
    }
    
    
    func seekAudio(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    /// MARK: Custom Loop Logic
    
    func setFirstMarker() {
        firstMarkerSelected = true
        firstMark = currentTime
    }
    
    func setSecondMarker() {
        
        secondMarkerSelected = true
        secondMark = currentTime
        isCustomLooping = true
        if !isPlaying {
            isPlaying = true
        }
        isLooping = false
        showMarkers = false
        
    }
    
    func toggleMarkers() {
       
        showMarkers.toggle()
        firstMarkerSelected = false
        secondMarkerSelected = false
       
      
    }
    
    func cancelCustomLoop() {
        showMarkers = false
        isCustomLooping = false
        firstMark = 0
        secondMark = 0
        firstMarkerSelected = false
        secondMarkerSelected = false
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func resetCountdown() {
        if delay > 0 {
            countdownRemaining = Int(delay)
            isCountingDown = true
            startCountdown()
        }
    }
    
    ///Function called when playback is finished.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        if !isLooping {
            isPlaying = false
            
        }
       
        else {
            resetCountdown()
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay)) {
                self.audioPlayer?.play()
               }
        }
        
       
        
    }
    
    
    func playTick() {
        let URL = Bundle.main.url(forResource: "snap", withExtension: "wav")!
        
        do {
            tickPlayer = try AVAudioPlayer(contentsOf: URL)
            tickPlayer?.prepareToPlay()
            tickPlayer?.play()
        } catch {
            print("Failed to play tick sound:", error)
        }
    }
    
    
    
    
    
    
    
    
    
}






