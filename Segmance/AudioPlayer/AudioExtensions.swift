//
//  AudioExtensions.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/12/02.
//

import SwiftUI

extension View {
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


