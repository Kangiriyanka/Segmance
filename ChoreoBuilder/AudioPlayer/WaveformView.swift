//
//  WaveformView.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/27.
//

import Foundation

import SwiftUI

struct Waveform: View {
    @Binding var startHandle: CGFloat
    @Binding var endHandle: CGFloat
    
    let amplitudes: [CGFloat]
    
    var trimmer: AudioTrimmerModel?
    

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    
                    Rectangle()
                                .fill(Color.customLB.opacity(0.5))  
                                .frame(
                                    width: (endHandle - startHandle) * geo.size.width,
                                    height: geo.size.height
                                )
                                .position(
                                    x: (startHandle + endHandle) / 2 * geo.size.width,
                                    y: geo.size.height / 2
                                )
                   
                    .frame(maxWidth: .infinity)
                    .border(.accent)

                    // Start handle
                    Rectangle()
                        .fill(Color.accent)
                        .frame(width: 10, height: geo.size.height)
                        .position(x: startHandle * geo.size.width, y: geo.size.height / 2)
                        .gesture(DragGesture().onChanged { value in
                            let newPos = min(max(0, value.location.x / geo.size.width), endHandle - 0.01)
                            startHandle = newPos
                        })

                    // End handle
                    Rectangle()
                        .fill(Color.accent)
                        .frame(width: 10, height: geo.size.height)
                        .position(x: endHandle * geo.size.width, y: geo.size.height / 2)
                        .gesture(DragGesture().onChanged { value in
                            let newPos = max(min(1, value.location.x / geo.size.width), startHandle)
                            endHandle = newPos
                        })
                }
            }
            .frame(height: 50)

            // Display selected times
            HStack {
                Text("Start: \(formatTime(startHandle * CGFloat(trimmer?.duration ?? 1)))")
                Spacer()
                Text("End: \(formatTime(endHandle * CGFloat(trimmer?.duration ?? 1 )))")
            }
            .padding(.horizontal)
        }
    }

 

    func formatTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
