//
//  AudioPlayerModel.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/03.
//

import Foundation
import AVKit

@Observable
class AudioPlayerModel: NSObject, AVAudioPlayerDelegate {
    private var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool = false
    var isLooping: Bool = false
    var isCustomLooping: Bool  = false
    var delay: Float = 0.0
    var totalTime: TimeInterval = 0.0
    var currentTime: TimeInterval = 0.0
    var audioFileURL: URL?
    var firstMark:  TimeInterval = 0.0
    var secondMark: TimeInterval = 0.0 
    
    
    init(audioFileURL: URL) {
    
        self.audioFileURL = audioFileURL
    }
     func setupAudio() {
       
        
    
         // Bluetooth Support
         do {
                 let audioSession = AVAudioSession.sharedInstance()
             try audioSession.setCategory(.playback, mode: .default)
                 try audioSession.setActive(true)
             } catch {
                 print("Failed to set up audio session: \(error)")
             }
        
         do {
             guard let audioFileUrl = audioFileURL else {
                 print("Error: audioFileURL is nil")
                 return
             }
             
             audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
             audioPlayer?.prepareToPlay()
             audioPlayer?.enableRate = true
             totalTime = audioPlayer?.duration ?? 0.0
             audioPlayer?.delegate = self
             
         } catch {
             print("Error initializing AVAudioPlayer: \(error.localizedDescription)")
         }
            
      
    }
        
    
    
    func playAudio() {

    
        isPlaying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay)) {
            self.audioPlayer?.play()
           }
        
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
    
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0.0
        isPlaying = false
    }
    
    
    
    func loop() {
        isLooping = true
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
        audioPlayer?.currentTime += 5.0
    }
    
    func seekBackwards() {
        
        audioPlayer?.currentTime -= 5.0
    }
    
    
 
    
    func updateProgress() {
        guard let player = audioPlayer else {
            currentTime = 0.0
            return
        }
        
   
        currentTime = player.currentTime
       
        if isCustomLooping {
              if firstMark > secondMark {
                  swap(&firstMark, &secondMark)  // Ensure firstMark is always before secondMark
              }
              
              // When we reach the second mark, pause and seek to the first mark.
              if currentTime >= secondMark {
                  player.pause()  // Pause the player
                  seekAudio(to: firstMark)  // Go back to the first mark
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  // Small delay to allow the seek to complete
                      player.play()  // Resume playing
                  }
              } else if currentTime < firstMark {
             
                  seekAudio(to: firstMark + 0.1 )
              }
          }
    }
    
    func seekAudio(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    // Function called when playback is finished.
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        
        if !isLooping {
            isPlaying = false
            
            
        }
        
        if isLooping {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(delay)) {
                self.audioPlayer?.play()
               }
        }
        
       
        
    }
    
    
    
    
    
    
    
    
    
}






