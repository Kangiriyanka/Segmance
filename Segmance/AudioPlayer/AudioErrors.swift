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
    case waveError
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "Audio file not found"
  
        case .initializationFailed(let error):
            return "Failed to load audio: \(error.localizedDescription)"
        case .seekOutOfBounds(let time):
            return "Cannot seek to \(Int(time))s"
        
        
        case .waveError:
            return "Could generate audio waves"
        }
    }
}

enum AudioClipError: Error {
    case invalidAudioURLOrDuration
    case failedToCreateExportSession
    case failedToClip
    case waveError
    case sameClip
    case alreadyClipping
}
