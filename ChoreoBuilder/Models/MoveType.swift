//
//  MoveType.swift
//  ChoreoBuilder
//
//  Created by Kangiriyanka The Single Leaf on 2025/10/05.
//

import Foundation
import SwiftData


@Model
class MoveType {
   
    var name: String
    var abbreviation: String
    
    init(name: String, abbreviation: String) {
        self.name = name
        self.abbreviation = abbreviation
    }
    
    
}



extension MoveType {
    @MainActor
    static var previewContainer: ModelContainer {
        do {
            let container = try ModelContainer (for: Routine.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            var samples: [MoveType] {
                [
                    MoveType(name: "Juggling", abbreviation: "J"),
                    MoveType(name: "Dancing", abbreviation: "D")
                ]
            }
            samples.forEach {
                container.mainContext.insert($0)
            }
            
            return container
        } catch {
            fatalError("Failed to create the model container: \(error)")
        }
    }
}
