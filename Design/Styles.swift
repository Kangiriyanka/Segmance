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
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: configuration.isPressed)
    }
}

struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.9
    var opacity: Double = 0.85

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
           
            .padding()
            .background(
                
                Circle()
                
                    .fill(Color.routineCard)
                
            )
            .font(.system(size: 20, weight: .semibold))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? scale : 1)
            .foregroundStyle(.mainText)
            .opacity(configuration.isPressed ? opacity : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: configuration.isPressed)
            .foregroundColor(.mainText)
          
    }
}
