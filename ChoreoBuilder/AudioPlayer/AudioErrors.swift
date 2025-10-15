//
//  AudioErrors.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/09/13.
//

import Foundation

enum AudioPlayerError: LocalizedError {
    case fileNotFound
    case initializationFailed(Error)
    case seekOutOfBounds(TimeInterval)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Audio file not found"
  
        case .initializationFailed(let error):
            return "Failed to load audio: \(error.localizedDescription)"
        case .seekOutOfBounds(let time):
            return "Cannot seek to \(Int(time))s"
        }
    }
}
