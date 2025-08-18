//
//  AudioPlayerView.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/03.
//

import SwiftUI
import AVKit

struct OldAudioPlayerView: View {
    

    @State private var isPlaying: Bool = false
    @State private var totalTime: TimeInterval = 0.0
    @State private var currentTime: TimeInterval = 0.0
    @State private var playbackSpeed: Float = 1.0
    @State private var delay: Float = 0.0
    @State private var audioPlayerManager: AudioPlayerModel
  
  
    
    let playbackSpeedOptions: [Float] = [2.0,1.5,1.25,1.0,0.5,0.25]
    let delayOptions: [Float] = [15,10,5,2,1,0]
   
    var body: some View {
        
       
          
          
                
              
                VStack(spacing: 5) {
                    
                    
                    HStack {
                        
                        Image(systemName: audioPlayerManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .onTapGesture {
                                
                                audioPlayerManager.isPlaying ? audioPlayerManager.pauseAudio() : audioPlayerManager.playAudio()
                                
                                
                            }
                        
                        
                        
                        Image(systemName: audioPlayerManager.isLooping ? "repeat.circle.fill" : "repeat.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(audioPlayerManager.isLooping ? Color.customPink : Color.white)
                            .onTapGesture {
                                audioPlayerManager.isLooping ? audioPlayerManager.stopLoop() : audioPlayerManager.loop()
                            }
                        
                        Image(systemName: "stop.circle.fill")
                            .font(.largeTitle)
                            .onTapGesture {
                                audioPlayerManager.stopAudio()
                               
                            }
                        
                    }
                    

                    HStack {
                        Text(audioPlayerManager.timeString(time: audioPlayerManager.currentTime))
                            .foregroundStyle(.white)
                        Spacer()
                        
                        Text(audioPlayerManager.timeString(time: audioPlayerManager.totalTime))
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                 
                    HStack {
                        
                        Menu {
                            Picker("Delay", selection: $delay) {
                                
                                ForEach(delayOptions, id: \.self) { delay in
                                    Text("\(delay, specifier: "%g")" ).tag(delay)
                                }
                                
                                
                            }
                            
                            
                            .onChange(of: delay) {
                                
                                audioPlayerManager.changeDelay(delay)
                                
                            }
                        } label: {
                           
                            Text("Delay: \(delay, specifier: "%g") secs").bold()
                        }
                        
                        
                  
                        
                        Menu {
                            Picker("Playback Speed", selection: $playbackSpeed) {
                                
                                ForEach(playbackSpeedOptions, id: \.self) { speedRate in
                                    Text("\(speedRate, specifier: "%g")" ).tag(speedRate)
                                }
                                
                                
                            }
                            
                            
                            .onChange(of: playbackSpeed) {
                                
                                audioPlayerManager.changeSpeedRate(playbackSpeed)
                                
                            }
                        } label: {
                            Spacer()
                            Text("Playback: \(playbackSpeed, specifier: "%g")x").bold()
                        }
                    }
                    
                }
               
                .frame(maxWidth: .infinity, maxHeight: 80)
        
                .padding(10)
                .background(Color.customPink)
                .cornerRadius(12)
         
                
            
            
            
          
            
            
        
        
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in audioPlayerManager.updateProgress()
        
        }
    }
    
    init(audioFileURL: URL) {
       
        self.audioPlayerManager = AudioPlayerModel(audioFileURL: audioFileURL)
        self.audioPlayerManager.setupAudio()
        
    }
    
 


}

#Preview {
    let URL = Bundle.main.url(forResource: "furio", withExtension: "mp3")!
    let URL2 = Bundle.main.url(forResource: "gabagoo", withExtension: "mp3")!
    OldAudioPlayerView(audioFileURL: URL )
    OldAudioPlayerView(audioFileURL: URL2 )
}

