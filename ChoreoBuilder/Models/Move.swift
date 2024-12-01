//
//  Move.swift
//  BluesMaker
//
//  Created by Kangiriyanka The Single Leaf on 2025/02/18.
//


import Foundation
import SwiftData

@Model
class Move {
    
    var id: UUID = UUID()
    var title: String = ""
    var type: String = MoveType.neutral.rawValue
    var details: String
    var parent: Part?
    var order: Int

 
    
    func copy() -> Move {
        let newMove = Move(title: self.title, details: self.details, order: self.order, type: self.type)
        return newMove
    }
 
    enum MoveType: String, CaseIterable {
        case neutral = "N"
        case juggling = "J"
        case transition = "T"
        case dancing = "D"
    }
    
    init(title: String, details: String, order: Int, type: String) {
        
        self.title = title
        self.details = details
        self.order = order
        self.type = type
        
    }
    
    
    
    static let example1 = Move(title: "Example Move", details: "This is an example move", order: 1, type: "N")
    static let example2 = Move(title: "Example Move 2", details: "This is an example move 2", order: 2, type: "J")
    static let example3 = Move(title: "Example Move 3", details: "This is an example move 3", order: 3, type: "J")
    static let example4 = Move(title: "Example Move 4", details: "This is an example move 4", order: 3, type: "D")
        
        
        
        
        
    
    
}
