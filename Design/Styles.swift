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
    var color: Color
    var isDisabled: Bool? = nil

    func makeBody(configuration: Configuration) -> some View {
        let disabled = isDisabled ?? false
        configuration.label
            .frame(width: 30)
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 4.0)
                        
                .fill(color.opacity(0.5))
                .stroke(.black.opacity(0.3), lineWidth: 1)
                .shadow(radius: 2, x: 0, y: 1)
                        )
        
           
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(disabled ? 0.3 : (configuration.isPressed ? opacity : 1))
            .foregroundStyle(.mainText)
            .opacity(configuration.isPressed ? opacity : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
          
          
    }
}

struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    var opacity: Double = 0.85
    var isDisabled: Bool? = nil

    func makeBody(configuration: Configuration) -> some View {
        let disabled = isDisabled ?? false
        configuration.label
           
            .padding()
            .background(
                
                Circle()
                
                    .fill(Color.routineCard)
                
            )
            .font(.system(size: 16, weight: .semibold))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(disabled ? 0.3 : (configuration.isPressed ? opacity : 1))
            .foregroundStyle(.mainText)
            .opacity(configuration.isPressed ? opacity : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
            .foregroundColor(.mainText)
          
    }
}


struct ReviewButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    var opacity: Double = 0.85
    var isDisabled: Bool? = nil

    func makeBody(configuration: Configuration) -> some View {
        let disabled = isDisabled ?? false
        configuration.label
           
            .padding()
            .background(
                
                RoundedRectangle(cornerRadius: 16)
                
                    .fill(Color.accent.opacity(0.6))
                
            )
           
            .font(.system(size: 16, weight: .bold))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(disabled ? 0.3 : (configuration.isPressed ? opacity : 1))
            .foregroundStyle(.mainText)
            .opacity(configuration.isPressed ? opacity : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
            .foregroundColor(.mainText)
          
    }
}

#Preview {
    
    Button("+1"){}
        .buttonStyle(MiniAudioButtonStyle(color: .customPink))
}
