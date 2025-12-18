//
//  Routine.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/11.
//

import Foundation
import SwiftData

@Model
class Routine {
    var id: UUID = UUID()
    var title: String
    var routineDescription: String
    
    // Deleting the routine will delete its parts
    @Relationship(deleteRule: .cascade) var parts =  [Part]()
    
    
    init (title: String, routineDescription: String) {
        self.title = title
        self.routineDescription = routineDescription
    }
    
    static let firstExample: Routine = {
        let routine = Routine(title: "Kakariko Village", routineDescription: "Relaxing Swift Movemement")
        let part1 = Part(title: "Example Part 1", fileName: "example1", order: 1 )
        routine.parts.append(part1)
        let part2 = Part(title: "Example Part 2", fileName: "example2", order: 2)
        routine.parts.append(part2)
        return routine
    }()
    
    static let secondExample: Routine = {
        let routine = Routine(title: "Jinjo Village", routineDescription: "Upbeat Swift Movemement")
        let part1 = Part(title: "Example Part 1", fileName: "example", order: 1)
        routine.parts.append(part1)
        let part2 = Part(title: "Example Part 2", fileName: "example2", order: 2)
        routine.parts.append(part2)
        
        return routine
    }()
    
    static let thirdExample: Routine = {
        let routine = Routine(title: "Gerudo Valley", routineDescription: "Energetic Guitar Theme with Swift Precision")
        let part1 = Part(title: "Intro Riff", fileName: "gerudo_intro", order: 1)
        routine.parts.append(part1)
        let part2 = Part(title: "Main Melody", fileName: "gerudo_main", order: 2)
        routine.parts.append(part2)
        let part3 = Part(title: "Bridge", fileName: "gerudo_bridge", order: 3)
        routine.parts.append(part3)
        return routine
    }()
    
    static let fourthExample: Routine = {
        let routine = Routine(title: "Zora’s Domain", routineDescription: "Calm and Flowing Movement Sequence")
        let part1 = Part(title: "Opening Flow", fileName: "zora_intro", order: 1)
        routine.parts.append(part1)
        let part2 = Part(title: "Underwater Glide", fileName: "zora_glide", order: 2)
        routine.parts.append(part2)
        return routine
    }()
    
    static let fifthExample: Routine = {
        let routine = Routine(title: "Lost Woods", routineDescription: "Playful and Mysterious Tempo Changes")
        let part1 = Part(title: "Mischievous Intro", fileName: "woods_intro", order: 1)
        routine.parts.append(part1)
        let part2 = Part(title: "Echo Section", fileName: "woods_echo", order: 2)
        routine.parts.append(part2)
        let part3 = Part(title: "Final Trick", fileName: "woods_final", order: 3)
        routine.parts.append(part3)
        return routine
    }()
    
    static let sixthExample: Routine = {
        let routine = Routine(title: "Lost Woods Long Version", routineDescription: "Playful and Mysterious Tempo Changes")
        let part1 = Part(title: "Mischievous Intro", fileName: "woods_intro", order: 1)
        routine.parts.append(part1)
        let part2 = Part(title: "Echo Section", fileName: "woods_echo", order: 2)
        routine.parts.append(part2)
        let part3 = Part(title: "Final Trick", fileName: "woods_final", order: 3)
        routine.parts.append(part3)
        return routine
    }()
    
    
}
    

extension Routine {
    @MainActor
    static var preview: ModelContainer {
        do {
            let container = try ModelContainer (for: Routine.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
            
            var samples: [Routine] {
                [
                    Routine.firstExample,
                    Routine.secondExample,
                    Routine.thirdExample,
                    Routine.fourthExample,
                    Routine.fifthExample,
                    Routine.sixthExample,
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
