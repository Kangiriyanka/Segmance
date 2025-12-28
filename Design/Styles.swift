//
//  Styles.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/11/28.
//

import Foundation

import SwiftUI


struct NavButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
        
            .animation(.organicFastBounce, value: configuration.isPressed)
    }
}

struct MiniAudioButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    var opacity: Double = 0.85
    var width: CGFloat
    var color: Color
    var isDisabled: Bool? = nil

    func makeBody(configuration: Configuration) -> some View {
        let disabled = isDisabled ?? false
        configuration.label
            .frame(width: width)
            .padding(3)
            .background(RoundedRectangle(cornerRadius: 4.0)
                        
                .fill(color.opacity(0.5))
                .stroke(.black.opacity(0.3), lineWidth: 1)
                .shadow(radius: 2, x: 0, y: 1)
                
            )
        
           
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(disabled ? 0.3 : (configuration.isPressed ? opacity : 1))
            .foregroundStyle(.mainText)
            .font(.caption)
            .opacity(configuration.isPressed ? opacity : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
          
          
    }
}

struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    var opacity: Double = 0.85
    var isDisabled: Bool? = nil
    var width: CGFloat = 50
    var height: CGFloat = 50
    
    func makeBody(configuration: Configuration) -> some View {
        let disabled = isDisabled ?? false
        configuration.label
            .padding()
            .frame(width: width, height: height)
            .background(
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.routineCard, Color.routineCard.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(.black.opacity(0.12), lineWidth: 0.5)
                    )
            )
            .font(.system(size: 16, weight: .semibold))
            .shadow(color: .black.opacity(0.1), radius: 0.5, x: 0, y: 1)
            .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .foregroundStyle(.mainText)
            .opacity(disabled ? 0.3 : (configuration.isPressed ? opacity : 1))
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
    }
}


struct FormButtonStyle: ButtonStyle {
    
    let width: CGFloat
    let height: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color.mainText)
            .frame(width: width, height: height)
            .buttonStyle(.borderedProminent)
    }
        
        
}

struct ReviewButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    var opacity: Double = 0.85
    var isDisabled: Bool? = nil
    
    func makeBody(configuration: Configuration) -> some View {
        let disabled = isDisabled ?? false
        
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color.mainText)
            .frame(maxWidth: .infinity)
            .padding()
         
            .background {
                ZStack {
                    // Animated sine wave background
                    ForEach(0..<1) { i in
                        SineWave(frequency: 0.5, amplitude: 12.0, phase: 1)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.customLB,
                                        Color.customLB.opacity(0.9),
                                        Color.customLB.opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                style: StrokeStyle(
                                    lineWidth: 30,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                        
                        
                            .rotationEffect(.degrees(0))
                            .offset(x: CGFloat(i) * 10 )
                            .blur(radius: 20)
                     
                    }
                    .clipped()
                    
       
                    // Base gradient fill
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            
                            LinearGradient(
                                colors:  [
                                    Color.customBlue.opacity(0.75),
                                    Color.customBlue.opacity(0.65),
                                    Color.customBlue.opacity(0.55)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                  
                }
                .clipShape(RoundedRectangle(cornerRadius: 10)) 
                .background(shadowOutline)
                
            }
            
         
          
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(disabled ? 0.2 : (configuration.isPressed ? opacity : 1))
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
    }
}


// Preview
#Preview {
    VStack(spacing: 30) {
        Button("Start Practice") {}
            .buttonStyle(ReviewButtonStyle())
      
    }
    .padding()
    
}

#Preview {
    
    Button("+1"){}
        .buttonStyle(MiniAudioButtonStyle(width: 30, color: .customPink))
    Divider()
    Button("Review"){}
        .buttonStyle(ReviewButtonStyle())
    
    Button("Review"){}
        .buttonStyle(FormButtonStyle(width: 100, height: 10))
}
