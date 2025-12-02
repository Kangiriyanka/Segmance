//
//  AudioWaveformView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/27.
//

import SwiftUI
import DSWaveformImageViews
import DSWaveformImage



struct SimpleDSWaveformView: View {
    let audioURL: URL
    
    let config = Waveform.Configuration(
        backgroundColor: .clear,
        style: .striped(Waveform.Style.StripeConfig(color: DSColor(Color.customWhite.opacity(0.3)), width: 2, spacing: 5.5)),
        verticalScalingFactor: 0.4,
      
    )
    

    var body: some View {
        WaveformView(
            audioURL: audioURL,
            configuration: config,
         
        ) { shape in
            shape.stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round))
        } placeholder: {
            VStack{
                Text("Drawing waveform...").foregroundStyle(.secondary).font(.caption)
            }.padding(5)
               
        }
        
        
        
    }
}




struct AudioWaveformView: View {
    @Binding var startTime: Double
    @Binding var endTime: Double
    @State private var previewTime: Double = 0
    var trimmer: AudioTrimmerModel?

    var body: some View {
        VStack(spacing: 15) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    if let url = trimmer?.audioURL, let duration = trimmer?.duration {
                        // Destroy the Waveform view if the url changes.
                        SimpleDSWaveformView(audioURL: url)
                            
                            .id(url)
                            
                           
                                                   
                        
                        // Convert times to fractions for overlay
                        let startFraction = CGFloat(startTime / duration)
                        let endFraction = CGFloat(endTime / duration)
                        
                        // Selection overlay
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accent.opacity(0.3))
                            .frame(
                                width: (endFraction - startFraction) * geo.size.width,
                                height: geo.size.height
                            )
                            .offset(x: startFraction * geo.size.width)
                        
                        // Start handle
                        HandleView(height: geo.size.height, color: .customPink)
                            .position(x: startFraction * geo.size.width, y: geo.size.height / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let fraction = min(max(0, value.location.x / geo.size.width), CGFloat(endTime / duration) - 0.01)
                                        let rawTime = Double(fraction) * duration
                                        startTime = round(rawTime)
                                    }
                                    .onEnded { _ in
                                        trimmer?.seekAudio(to: previewTime)
                                    }
                            )
                        
                        // End handle
                        HandleView(height: geo.size.height, color: .customBlue)
                            .position(x: endFraction * geo.size.width, y: geo.size.height / 2)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let fraction = max(min(1, value.location.x / geo.size.width), CGFloat(startTime / duration) + 0.01)
                                        let rawTime = Double(fraction) * duration
                                        endTime = round(rawTime)
                                    }
                            )
                    }
                }
               
            }
            #if targetEnvironment(simulator)
            .border(.customBlue)
            #endif
            .background(shadowOutline)
            .frame(width: UIScreen.main.bounds.width - 50, height: 50)
            
            
            if trimmer?.duration != nil {
                timeControls
                #if targetEnvironment(simulator)
                .border(.red)
                #endif
            }
        }
        .padding(.horizontal, 20)
       
        
       
        
        #if targetEnvironment(simulator)
        .border(.green)
        #endif
      
        
    }
    
    private var timeControls: some View {
        VStack(spacing: 15) {
            // Time labels in their own HStack
            HStack {
                Text("Start: \(formatTime(startTime))")
                Spacer()
                Text("Duration: \(formatTime(endTime - startTime))")
                Spacer()
                Text("End: \(formatTime(endTime))")
            }
            .padding(5)
            .frame(maxWidth: .infinity)
            .font(.caption)
            .foregroundColor(.secondary)
            
            // Button groups in their own HStack
            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Button("-10") { startTime = max(0, startTime - 10) }
                    Button("-1") { startTime = max(0, startTime - 1) }
                    Button("+1") { startTime = min(endTime - 1, startTime + 1) }
                    Button("+10") { startTime = min(endTime - 1, startTime + 10) }
                }
                .buttonStyle(MiniAudioButtonStyle(color: .customPink))
                
                Divider()
                    .frame(width: 2, height: 30)
                
                HStack(spacing: 6) {
                    Button("-10") { endTime = max(startTime + 1, endTime - 10) }
                    Button("-1") { endTime = max(startTime + 1, endTime - 1) }
                    Button("+1") { endTime = min(trimmer?.duration ?? endTime, endTime + 1) }
                    Button("+10") { endTime = min(trimmer?.duration ?? endTime, endTime + 10) }
                }
                .buttonStyle(MiniAudioButtonStyle(color: Color.customBlue))
            }
        }
       
    }

    func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

struct HandleView: View {
    let height: CGFloat
    let color: Color
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color)
            .frame(width: 6, height: height)
            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var startTime: Double = 0
        @State private var endTime: Double = 1
        
        var body: some View {
            let sampleURL = Bundle.main.url(forResource: "gabagoo", withExtension: "mp3")!
            let mockTrimmer = AudioTrimmerModel()
            
            AudioWaveformView(
                startTime: $startTime,
                endTime: $endTime,
                trimmer: mockTrimmer
            )
            .onAppear {
                mockTrimmer.setupAudio(url: sampleURL)
            }
            .padding()
        }
    }
    
    return PreviewWrapper()
}
