//
//  AudioWaveformView.swift  // ← Rename the file
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
            Text("Loading waveform...").background(.black)
        }
        
        
    }
}




struct AudioWaveformView: View {
    @Binding var startHandle: CGFloat
    @Binding var endHandle: CGFloat
    var trimmer: AudioTrimmerModel?
    @State private var progress: Double = .random(in: 0...1)
    
    
  
    
    var body: some View {
        VStack(spacing: 16) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    
                    if let url = trimmer?.audioURL {
                        
                        SimpleDSWaveformView(audioURL: url)
                    }
                      
                    // Selection overlay
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accent.opacity(0.3))
                        .frame(
                            width: (endHandle - startHandle) * geo.size.width,
                            height: geo.size.height
                        )
                        .offset(x: startHandle * geo.size.width)
                    
                    // Start handle
                    HandleView(height: geo.size.height)
                        .position(x: startHandle * geo.size.width, y: geo.size.height / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    startHandle = min(max(0, value.location.x / geo.size.width), endHandle - 0.01)
                                }
//                                .onEnded(
//                                    trimmer?.seekAudio(to: Double(startHandle * CGFloat(trimmer!.duration)))
//                                    
//                                )
                        )
                    
                    // End handle
                    HandleView(height: geo.size.height)
                        .position(x: endHandle * geo.size.width, y: geo.size.height / 2)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    endHandle = max(min(1, value.location.x / geo.size.width), startHandle + 0.01)
                                }
                        )
                }
            }
            .frame(height: 60)
            
            // Time labels
            HStack {
                Text(formatTime(startHandle * CGFloat(trimmer?.duration ?? 1)))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
                Spacer()
                Text(formatTime(endHandle * CGFloat(trimmer?.duration ?? 1)))
                    .font(.caption.monospacedDigit())
                    .foregroundColor(.secondary)
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
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.accent)
            .frame(width: 6, height: height)
            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white.opacity(0.5), lineWidth: 1)
            )
    }
}
